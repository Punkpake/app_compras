import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lista.dart';
import '../models/item.dart';

const _chaveListas = 'my_list_listas';
const _chavePrefOrdenacao = 'my_list_pref_ordenacao';
const _chavePrefFinalizar = 'my_list_pref_finalizar';

class Armazenamento {
  static Future<List<ListaCompras>> obterListas() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_chaveListas);
    if (raw == null) return [];
    final List<dynamic> decodificado = jsonDecode(raw);
    return decodificado
        .map((e) => ListaCompras.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> _salvarListas(List<ListaCompras> listas) async {
    final prefs = await SharedPreferences.getInstance();
    final codificado = jsonEncode(listas.map((l) => l.toJson()).toList());
    await prefs.setString(_chaveListas, codificado);
  }

  static Future<ListaCompras?> obterListaPorId(String id) async {
    final listas = await obterListas();
    try {
      return listas.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  static Future<void> salvarOuAtualizarLista(ListaCompras lista) async {
    final listas = await obterListas();
    final indice = listas.indexWhere((l) => l.id == lista.id);
    if (indice >= 0) {
      listas[indice] = lista;
    } else {
      listas.add(lista);
    }
    await _salvarListas(listas);
  }

  static Future<void> apagarListas(List<String> ids) async {
    final listas = await obterListas();
    listas.removeWhere((l) => ids.contains(l.id));
    await _salvarListas(listas);
  }

  static Future<void> atualizarItensDaLista(
      String listaId, List<ItemCompra> itens) async {
    final listas = await obterListas();
    final indice = listas.indexWhere((l) => l.id == listaId);
    if (indice >= 0) {
      listas[indice] = listas[indice].copyWith(
        itens: itens,
        atualizadoEm: DateTime.now().millisecondsSinceEpoch,
      );
      await _salvarListas(listas);
    }
  }

  // Preferência de ordenação (memória de 3 escolhas seguidas)
  static Future<Map<String, dynamic>> obterPreferenciaOrdenacao() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_chavePrefOrdenacao);
    if (raw == null) {
      return {'historico': <String>[], 'padrao': TipoOrdenacao.porCategoria.valor};
    }
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  static Future<TipoOrdenacao> registrarEscolhaOrdenacao(TipoOrdenacao tipo) async {
    final prefs = await SharedPreferences.getInstance();
    final pref = await obterPreferenciaOrdenacao();
    final List<String> historico = List<String>.from(pref['historico'] as List);
    historico.add(tipo.valor);
    if (historico.length > 3) historico.removeAt(0);

    String padrao = pref['padrao'] as String;
    if (historico.length == 3 && historico.every((h) => h == tipo.valor)) {
      padrao = tipo.valor;
    }
    await prefs.setString(
      _chavePrefOrdenacao,
      jsonEncode({'historico': historico, 'padrao': padrao}),
    );
    return TipoOrdenacaoValor.fromValor(padrao);
  }

  // Preferência de "Finalizar Compra" lembrada
  static Future<String?> obterPreferenciaFinalizar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_chavePrefFinalizar);
  }

  static Future<void> definirPreferenciaFinalizar(String? acao) async {
    final prefs = await SharedPreferences.getInstance();
    if (acao == null) {
      await prefs.remove(_chavePrefFinalizar);
    } else {
      await prefs.setString(_chavePrefFinalizar, acao);
    }
  }
}