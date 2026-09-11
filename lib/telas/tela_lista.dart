import 'package:flutter/material.dart';

import '../models/lista.dart';
import '../utils/armazenamento.dart';
import '../widgets/modal_confirmacao.dart';

class TelaLista extends StatefulWidget {
  final ListaCompras lista;

  const TelaLista({
    super.key,
    required this.lista,
  });

  @override
  State<TelaLista> createState() =>
      _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {

  Color _corCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'frios':
        return Colors.blue;

      case 'verduras':
        return Colors.green;

      case 'prateleira':
        return Colors.orange;

      case 'limpeza':
        return Colors.grey;

      default:
        return Colors.white;
    }
  }

  Future<void> _salvarAlteracoes() async {
    await Armazenamento.salvarOuAtualizarLista(
      widget.lista,
    );
  }

  Future<void> _finalizarCompra() async {
    final itensFaltando = widget.lista.itens
        .where((item) => !item.concluido)
        .length;

    exibirModalConfirmacao(
      context: context,
      titulo: 'Finalizar compra',
      mensagem: itensFaltando > 0
          ? 'Ainda faltam $itensFaltando '
              '${itensFaltando == 1 ? 'item' : 'itens'} '
              'para serem comprados.\n\n'
              'Deseja realmente finalizar a compra?'
          : 'Todos os itens foram comprados.\n\n'
              'Deseja realmente finalizar a compra?',
      acoes: [
        AcaoModal(
          rotulo: 'Cancelar',
          aoTocar: () {
            Navigator.pop(context);
          },
        ),
        AcaoModal(
          rotulo: 'Continuar',
          cor: Colors.green,
          aoTocar: () {
            Navigator.pop(context);
            _escolherDestinoLista();
          },
        ),
      ],
    );
  }

  Future<void> _escolherDestinoLista() async {
    final preferencia =
        await Armazenamento.obterPreferenciaFinalizar();

    if (preferencia == 'reutilizar') {
      await _reutilizarLista();
      return;
    }

    if (preferencia == 'excluir') {
      await _excluirLista();
      return;
    }

    if (!mounted) return;

    bool sempreUsarEscolha = false;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setStateDialog,
          ) {
            return Dialog(
              backgroundColor:
                  const Color(0xFF111111),

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),

                side: const BorderSide(
                  color: Color(0xFF262626),
                ),
              ),

              child: Padding(
                padding:
                    const EdgeInsets.all(20),

                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'O que deseja fazer com a lista?',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    const Text(
                      'Você pode reutilizar esta lista '
                      'em uma próxima compra ou excluí-la.',

                      style: TextStyle(
                        color: Color(
                          0xFFB3B3B3,
                        ),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    CheckboxListTile(
                      contentPadding:
                          EdgeInsets.zero,

                      title: const Text(
                        'Sempre usar esta escolha',

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),

                      value:
                          sempreUsarEscolha,

                      activeColor:
                          Colors.green,

                      checkColor:
                          Colors.white,

                      onChanged: (valor) {
                        setStateDialog(() {
                          sempreUsarEscolha =
                              valor ?? false;
                        });
                      },
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(
                            dialogContext,
                          );

                          if (sempreUsarEscolha) {
                            await Armazenamento
                                .definirPreferenciaFinalizar(
                              'reutilizar',
                            );
                          }

                          await _reutilizarLista();
                        },

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.green,

                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 12,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),

                        child: const Text(
                          'Reutilizar lista',

                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(
                            dialogContext,
                          );

                          if (sempreUsarEscolha) {
                            await Armazenamento
                                .definirPreferenciaFinalizar(
                              'excluir',
                            );
                          }

                          await _excluirLista();
                        },

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.red,

                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 12,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),

                        child: const Text(
                          'Excluir lista',

                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    SizedBox(
                      width: double.infinity,

                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(
                            dialogContext,
                          );
                        },

                        child: const Text(
                          'Cancelar',

                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _reutilizarLista() async {
    final itensReutilizados =
        widget.lista.itens.map(
      (item) {
        return item.copyWith(
          concluido: false,
        );
      },
    ).toList();

    widget.lista.itens
      ..clear()
      ..addAll(itensReutilizados);

    await _salvarAlteracoes();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _excluirLista() async {
    await Armazenamento.apagarListas([
      widget.lista.id,
    ]);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        title: Text(
          widget.lista.nome,

          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: widget.lista.itens.isEmpty
          ? const Center(
              child: Text(
                "Esta lista não possui itens.",

                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 18,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.only(
                      bottom: 10,
                    ),

                    itemCount:
                        widget.lista.itens.length,

                    itemBuilder:
                        (context, index) {
                      final item =
                          widget.lista.itens[index];

                      final corCategoria =
                          _corCategoria(
                        item.categoria,
                      );

                      return Padding(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),

                        child: Container(
                          decoration:
                              BoxDecoration(
                            color:
                                Colors.grey[900],

                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),

                            border: Border(
                              left: BorderSide(
                                color: corCategoria,
                                width: 6,
                              ),
                            ),
                          ),

                          child: Padding(
                            padding:
                                const EdgeInsets.all(
                              15,
                            ),

                            child: Row(
                              children: [
                                Checkbox(
                                  value:
                                      item.concluido,

                                  activeColor:
                                      Colors.green,

                                  onChanged:
                                      (valor) async {
                                    setState(() {
                                      widget.lista
                                              .itens[index] =
                                          item.copyWith(
                                        concluido:
                                            valor ?? false,
                                      );
                                    });

                                    await _salvarAlteracoes();
                                  },
                                ),

                                const SizedBox(
                                  width: 10,
                                ),

                                Expanded(
                                  child: Text(
                                    item.nome,

                                    style: TextStyle(
                                      color:
                                          item.concluido
                                              ? Colors.grey
                                              : Colors.white,

                                      fontSize: 20,

                                      decoration:
                                          item.concluido
                                              ? TextDecoration
                                                  .lineThrough
                                              : TextDecoration
                                                  .none,
                                    ),
                                  ),
                                ),

                                Text(
                                  "x${item.quantidade}",

                                  style:
                                      const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SafeArea(
                  top: false,

                  child: Padding(
                    padding:
                        const EdgeInsets.all(16),

                    child: SizedBox(
                      width: double.infinity,
                      height: 52,

                      child: ElevatedButton(
                        onPressed:
                            _finalizarCompra,

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.green,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),
                          ),
                        ),

                        child: const Text(
                          'Finalizar compra',

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}