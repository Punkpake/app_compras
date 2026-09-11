import 'package:flutter/material.dart';
import '../constants/categorias.dart';
import '../models/item.dart';
import '../models/lista.dart';
import '../utils/armazenamento.dart';
import '../utils/ordenacao.dart';
import '../widgets/botao_categoria.dart';
import '../widgets/modal_confirmacao.dart';

class TelaCriarLista extends StatefulWidget {
  final String? listaId;
  const TelaCriarLista({super.key, this.listaId});

  @override
  State<TelaCriarLista> createState() => _TelaCriarListaState();
}

class _TelaCriarListaState extends State<TelaCriarLista> {
  final _controladorNome = TextEditingController();
  final Map<String, TextEditingController> _controladoresNomeItem = {};
  final Map<String, TextEditingController> _controladoresQtdItem = {};

  List<ItemCompra> _itens = [];
  TipoOrdenacao _tipoOrdenacao = TipoOrdenacao.porCategoria;
  String? _idExistente;
  int _criadoEm = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void dispose() {
    _controladorNome.dispose();
    for (final c in _controladoresNomeItem.values) c.dispose();
    for (final c in _controladoresQtdItem.values) c.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    if (widget.listaId != null) {
      final existente = await Armazenamento.obterListaPorId(widget.listaId!);
      if (existente != null) {
        setState(() {
          _idExistente = existente.id;
          _controladorNome.text = existente.nome;
          _itens = existente.itens;
          _tipoOrdenacao = existente.tipoOrdenacao;
          _criadoEm = existente.criadoEm;
        });
        return;
      }
    }
    final pref = await Armazenamento.obterPreferenciaOrdenacao();
    if (mounted) {
      setState(() => _tipoOrdenacao = TipoOrdenacaoValor.fromValor(pref['padrao'] as String));
    }
  }

  String _gerarId() => '${DateTime.now().microsecondsSinceEpoch}_${_itens.length}';

  TextEditingController _ctrlNome(ItemCompra item) =>
      _controladoresNomeItem.putIfAbsent(item.id, () => TextEditingController(text: item.nome));

  TextEditingController _ctrlQtd(ItemCompra item) =>
      _controladoresQtdItem.putIfAbsent(item.id, () => TextEditingController(text: item.quantidade));

  void _adicionarItem(String categoriaId) {
    setState(() {
      _itens.add(ItemCompra(
        id: _gerarId(),
        nome: '',
        categoria: categoriaId,
        tipoMedida: 'Quantidade',
        quantidade: '1',
        concluido: false,
        ordem: _itens.length,
      ));
    });
  }

  void _atualizarItem(String id, ItemCompra Function(ItemCompra) atualizar) {
    setState(() {
      _itens = _itens.map((i) => i.id == id ? atualizar(i) : i).toList();
    });
  }

  void _removerItem(String id) {
    setState(() => _itens.removeWhere((i) => i.id == id));
    _controladoresNomeItem.remove(id)?.dispose();
    _controladoresQtdItem.remove(id)?.dispose();
  }

  List<ItemCompra> get _itensExibidos => _tipoOrdenacao == TipoOrdenacao.personalizado
      ? (List<ItemCompra>.from(_itens)..sort((a, b) => a.ordem.compareTo(b.ordem)))
      : ordenarItens(_itens, _tipoOrdenacao);

  void _reordenar(int oldIndex, int newIndex) {
    setState(() {
      final lista = _itensExibidos;
      if (newIndex > oldIndex) newIndex -= 1;
      final item = lista.removeAt(oldIndex);
      lista.insert(newIndex, item);
      for (var i = 0; i < lista.length; i++) {
        final idx = _itens.indexWhere((x) => x.id == lista[i].id);
        _itens[idx] = _itens[idx].copyWith(ordem: i);
      }
    });
  }

  Future<void> _salvar() async {
    if (_controladorNome.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Dê um nome para a lista antes de salvar.')));
      return;
    }
    final agora = DateTime.now().millisecondsSinceEpoch;
    final lista = ListaCompras(
      id: _idExistente ?? _gerarId(),
      nome: _controladorNome.text.trim(),
      criadoEm: _criadoEm,
      atualizadoEm: agora,
      tipoOrdenacao: _tipoOrdenacao,
      itens: _itens,
    );
    await Armazenamento.salvarOuAtualizarLista(lista);
    await Armazenamento.registrarEscolhaOrdenacao(_tipoOrdenacao);
    if (mounted) {
      Navigator.pop(context); // fecha o modal
      Navigator.pop(context); // volta pra Home
    }
  }

  void _abrirModalSalvar() {
    exibirModalConfirmacao(
      context: context,
      titulo: 'Salvar lista',
      mensagem: 'Tem certeza que deseja salvar esta lista?',
      acoes: [
        AcaoModal(rotulo: 'Cancelar', aoTocar: () => Navigator.pop(context)),
        AcaoModal(rotulo: 'Salvar', cor: const Color(0xFF3B82F6), aoTocar: _salvar),
      ],
    );
  }

  Widget _linhaItem(ItemCompra item) {
    final categoria = obterCategoria(item.categoria);
    return Padding(
      key: ValueKey(item.id),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(color: categoria.cor, shape: BoxShape.circle),
          ),
          Expanded(
            child: TextField(
              controller: _ctrlNome(item),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Nome do item',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF111111),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
              onChanged: (v) => _atualizarItem(item.id, (i) => i.copyWith(nome: v)),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(color: const Color(0xFF111111), borderRadius: BorderRadius.circular(8)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: item.tipoMedida,
                dropdownColor: const Color(0xFF1A1A1A),
                style: const TextStyle(color: Colors.white, fontSize: 13),
                items: tiposMedida.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (v) {
                  if (v != null) _atualizarItem(item.id, (i) => i.copyWith(tipoMedida: v));
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 50,
            child: TextField(
              controller: _ctrlQtd(item),
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF111111),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
              onChanged: (v) => _atualizarItem(item.id, (i) => i.copyWith(quantidade: v)),
            ),
          ),
          if (_tipoOrdenacao == TipoOrdenacao.personalizado)
            ReorderableDragStartListener(
              index: _itensExibidos.indexWhere((i) => i.id == item.id),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.drag_handle, color: Colors.grey),
              ),
            ),
          IconButton(
            onPressed: () => _removerItem(item.id),
            icon: const Icon(Icons.close, color: Color(0xFFEF4444), size: 20),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itensExibidos = _itensExibidos;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _controladorNome,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                decoration: const InputDecoration(
                  hintText: 'Nome da lista (ex: Mercado do mês)',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF1A1A1A))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: categorias.map((c) => BotaoCategoria(categoria: c, aoTocar: () => _adicionarItem(c.id))).toList()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: TipoOrdenacao.values.map((tipo) {
                  final ativo = _tipoOrdenacao == tipo;
                  return GestureDetector(
                    onTap: () => setState(() => _tipoOrdenacao = tipo),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: ativo ? const Color(0xFF3B82F6) : const Color(0xFF161616),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(tipo.label,
                          style: TextStyle(
                              color: ativo ? Colors.white : Colors.grey,
                              fontSize: 12,
                              fontWeight: ativo ? FontWeight.w600 : FontWeight.normal)),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: itensExibidos.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text('Toque em uma categoria acima para adicionar itens.',
                          textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                    )
                  : (_tipoOrdenacao == TipoOrdenacao.personalizado
                      ? ReorderableListView(
                          buildDefaultDragHandles: false,
                          padding: const EdgeInsets.only(bottom: 100),
                          onReorder: _reordenar,
                          children: [for (final item in itensExibidos) _linhaItem(item)],
                        )
                      : ListView(
                          padding: const EdgeInsets.only(bottom: 100),
                          children: [for (final item in itensExibidos) _linhaItem(item)],
                        )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3B82F6),
        onPressed: _abrirModalSalvar,
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }
}