class ItemCompra {
  final String id;
  final String nome;
  final String categoria; // 'frios' | 'verduras' | 'prateleira' | 'limpeza'
  final String tipoMedida; // 'Quilo' | 'Litro' | 'Quantidade' | 'Dinheiro'
  final String quantidade;
  final bool comprado;
  final int ordem;

  ItemCompra({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.tipoMedida,
    required this.quantidade,
    this.comprado = false,
    required this.ordem,
  });

  ItemCompra copyWith({
    String? nome,
    String? categoria,
    String? tipoMedida,
    String? quantidade,
    bool? comprado,
    int? ordem,
  }) {
    return ItemCompra(
      id: id,
      nome: nome ?? this.nome,
      categoria: categoria ?? this.categoria,
      tipoMedida: tipoMedida ?? this.tipoMedida,
      quantidade: quantidade ?? this.quantidade,
      comprado: comprado ?? this.comprado,
      ordem: ordem ?? this.ordem,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'categoria': categoria,
        'tipoMedida': tipoMedida,
        'quantidade': quantidade,
        'comprado': comprado,
        'ordem': ordem,
      };

  factory ItemCompra.fromJson(Map<String, dynamic> json) => ItemCompra(
        id: json['id'] as String,
        nome: json['nome'] as String,
        categoria: json['categoria'] as String,
        tipoMedida: json['tipoMedida'] as String,
        quantidade: json['quantidade'] as String,
        comprado: json['comprado'] as bool? ?? false,
        ordem: json['ordem'] as int? ?? 0,
      );
}