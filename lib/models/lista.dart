import 'item.dart';

enum TipoOrdenacao { az, porCategoria, azPorCategoria, personalizado }

extension TipoOrdenacaoValor on TipoOrdenacao {
  String get valor {
    switch (this) {
      case TipoOrdenacao.az:
        return 'AZ';
      case TipoOrdenacao.porCategoria:
        return 'POR_CATEGORIA';
      case TipoOrdenacao.azPorCategoria:
        return 'AZ_POR_CATEGORIA';
      case TipoOrdenacao.personalizado:
        return 'PERSONALIZADO';
    }
  }

  String get label {
    switch (this) {
      case TipoOrdenacao.az:
        return 'A-Z por ordem';
      case TipoOrdenacao.porCategoria:
        return 'Por itens';
      case TipoOrdenacao.azPorCategoria:
        return 'A-Z por itens';
      case TipoOrdenacao.personalizado:
        return 'Personalizado';
    }
  }

  static TipoOrdenacao fromValor(String valor) {
    switch (valor) {
      case 'AZ':
        return TipoOrdenacao.az;
      case 'POR_CATEGORIA':
        return TipoOrdenacao.porCategoria;
      case 'AZ_POR_CATEGORIA':
        return TipoOrdenacao.azPorCategoria;
      case 'PERSONALIZADO':
        return TipoOrdenacao.personalizado;
      default:
        return TipoOrdenacao.porCategoria;
    }
  }
}

class ListaCompras {
  final String id;
  final String nome;
  final int criadoEm;
  final int atualizadoEm;
  final TipoOrdenacao tipoOrdenacao;
  final List<ItemCompra> itens;

  ListaCompras({
    required this.id,
    required this.nome,
    required this.criadoEm,
    required this.atualizadoEm,
    required this.tipoOrdenacao,
    required this.itens,
  });

  ListaCompras copyWith({
    String? nome,
    int? atualizadoEm,
    TipoOrdenacao? tipoOrdenacao,
    List<ItemCompra>? itens,
  }) {
    return ListaCompras(
      id: id,
      nome: nome ?? this.nome,
      criadoEm: criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      tipoOrdenacao: tipoOrdenacao ?? this.tipoOrdenacao,
      itens: itens ?? this.itens,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'criadoEm': criadoEm,
        'atualizadoEm': atualizadoEm,
        'tipoOrdenacao': tipoOrdenacao.valor,
        'itens': itens.map((i) => i.toJson()).toList(),
      };

  factory ListaCompras.fromJson(Map<String, dynamic> json) => ListaCompras(
        id: json['id'] as String,
        nome: json['nome'] as String,
        criadoEm: json['criadoEm'] as int,
        atualizadoEm: json['atualizadoEm'] as int,
        tipoOrdenacao:
            TipoOrdenacaoValor.fromValor(json['tipoOrdenacao'] as String),
        itens: (json['itens'] as List<dynamic>)
            .map((i) => ItemCompra.fromJson(i as Map<String, dynamic>))
            .toList(),
      );
}