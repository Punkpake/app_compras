import '../constants/categorias.dart';
import '../models/item.dart';
import '../models/lista.dart';

int _indiceCategoria(String categoriaId) {
  return categorias.indexWhere((c) => c.id == categoriaId);
}

List<ItemCompra> ordenarItens(List<ItemCompra> itens, TipoOrdenacao tipo) {
  final copia = List<ItemCompra>.from(itens);
  switch (tipo) {
    case TipoOrdenacao.az:
      copia.sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
      break;
    case TipoOrdenacao.porCategoria:
      copia.sort((a, b) {
        final diff = _indiceCategoria(a.categoria) - _indiceCategoria(b.categoria);
        return diff != 0 ? diff : a.ordem - b.ordem;
      });
      break;
    case TipoOrdenacao.azPorCategoria:
      copia.sort((a, b) {
        final diff = _indiceCategoria(a.categoria) - _indiceCategoria(b.categoria);
        return diff != 0 ? diff : a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
      });
      break;
    case TipoOrdenacao.personalizado:
      copia.sort((a, b) => a.ordem - b.ordem);
      break;
  }
  return copia;
}

bool listaEmAndamento(List<ItemCompra> itens) {
  if (itens.isEmpty) return false;
  final compradosCount = itens.where((i) => i.comprado).length;
  return compradosCount > 0 && compradosCount < itens.length;
}