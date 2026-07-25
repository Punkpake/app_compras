import 'item.dart';

class ListaCompras {

  String nome;
  DateTime data;
  List<Item> itens;

  ListaCompras({
    required this.nome,
    required this.data,
    required this.itens,
  });

  Map<String, dynamic> toJson() {

    return {

      'nome': nome,

      'data': data.toIso8601String(),

      'itens':
          itens.map((item) {

            return item.toJson();

          }).toList(),

    };

  }

  factory ListaCompras.fromJson(
    Map<String, dynamic> json,
  ) {

    return ListaCompras(

      nome: json['nome'],

      data: DateTime.parse(
        json['data'],
      ),

      itens:
          (json['itens'] as List)

              .map((itemJson) {

                return Item.fromJson(
                  itemJson,
                );

              }).toList(),

    );

  }

}