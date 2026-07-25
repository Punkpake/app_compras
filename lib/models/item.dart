class Item {

  String nome;
  String categoria;
  int quantidade;
  bool concluido;

  Item({
    required this.nome,
    required this.categoria,
    required this.quantidade,
    this.concluido = false,
  });

  Map<String, dynamic> toJson() {

    return {

      'nome': nome,
      'categoria': categoria,
      'quantidade': quantidade,
      'concluido': concluido,

    };

  }

  factory Item.fromJson(
    Map<String, dynamic> json,
  ) {

    return Item(

      nome: json['nome'],

      categoria: json['categoria'],

      quantidade: json['quantidade'],

      concluido:
          json['concluido'] ?? false,

    );

  }

}