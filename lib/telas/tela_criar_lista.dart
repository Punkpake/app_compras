import 'package:flutter/material.dart';

import '../models/item.dart';
import '../models/lista.dart';

class TelaCriarLista extends StatefulWidget {
  const TelaCriarLista({super.key});

  @override
  State<TelaCriarLista> createState() =>
      _TelaCriarListaState();
}

class _TelaCriarListaState
    extends State<TelaCriarLista> {

  List<Item> itens = [];

  final TextEditingController nomeListaController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    nomeListaController.text = "Nova Lista";
  }

  void adicionarItem(String categoria) {

    setState(() {

      itens.add(

        Item(
          nome: "Item 1",
          categoria: categoria,
          quantidade: 1,
        ),

      );

      organizarItens();

    });

  }

  void organizarItens() {

    List<String> ordem = [
      "geladeira",
      "hortifruti",
      "prateleira",
      "limpeza",
    ];

    itens.sort((a, b) {

      return ordem.indexOf(a.categoria)
          .compareTo(
        ordem.indexOf(b.categoria),
      );

    });

  }

  Color corCategoria(String categoria) {

    switch (categoria) {

      case "geladeira":
        return Colors.cyan;

      case "hortifruti":
        return Colors.green;

      case "prateleira":
        return Colors.orange;

      case "limpeza":
        return Colors.grey;

      default:
        return Colors.white;

    }

  }

  IconData iconeCategoria(String categoria) {

    switch (categoria) {

      case "geladeira":
        return Icons.ac_unit;

      case "hortifruti":
        return Icons.eco;

      case "prateleira":
        return Icons.inventory_2;

      case "limpeza":
        return Icons.cleaning_services;

      default:
        return Icons.shopping_cart;

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        title: TextField(

          controller: nomeListaController,

          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),

          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Nome da Lista",
            hintStyle: TextStyle(
              color: Colors.white54,
            ),
          ),
        ),
      ),

      floatingActionButton:
          FloatingActionButton(

        backgroundColor: Colors.green,

        onPressed: () {

          ListaCompras novaLista =
              ListaCompras(

            nome: nomeListaController.text,

            data: DateTime.now(),

            itens: itens,
          );

          Navigator.pop(
            context,
            novaLista,
          );

        },

        child: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),

      body: Column(

        children: [

          const SizedBox(height: 15),

          Row(

            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,

            children: [

              botaoCategoria(
                "geladeira",
              ),

              botaoCategoria(
                "hortifruti",
              ),

              botaoCategoria(
                "prateleira",
              ),

              botaoCategoria(
                "limpeza",
              ),

            ],
          ),

          const SizedBox(height: 20),

          Expanded(

            child: itens.isEmpty

                ? const Center(

                    child: Text(

                      "Nenhum item adicionado",

                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 18,
                      ),
                    ),
                  )

                : ListView.builder(

                    itemCount: itens.length,

                    itemBuilder:
                        (context, index) {

                      Item item = itens[index];

                      TextEditingController
                          nomeController =
                          TextEditingController(
                        text: item.nome,
                      );

                      TextEditingController
                          quantidadeController =
                          TextEditingController(
                        text:
                            item.quantidade
                                .toString(),
                      );

                      return Padding(

                        padding:
                            const EdgeInsets
                                .all(10),

                        child: Container(

                          padding:
                              const EdgeInsets
                                  .all(15),

                          decoration:
                              BoxDecoration(

                            color: corCategoria(
                              item.categoria,
                            ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              20,
                            ),
                          ),

                          child: Row(

                            children: [

                              Icon(
                                iconeCategoria(
                                  item.categoria,
                                ),
                                color:
                                    Colors.black,
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              Expanded(

                                child: TextField(

                                  controller:
                                      nomeController,

                                  onChanged:
                                      (valor) {

                                    item.nome =
                                        valor;

                                  },

                                  decoration:
                                      const InputDecoration(

                                    filled:
                                        true,

                                    fillColor:
                                        Colors
                                            .white,

                                    border:
                                        OutlineInputBorder(),

                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              SizedBox(

                                width: 70,

                                child: TextField(

                                  controller:
                                      quantidadeController,

                                  keyboardType:
                                      TextInputType
                                          .number,

                                  onChanged:
                                      (valor) {

                                    item.quantidade =
                                        int.tryParse(
                                              valor,
                                            ) ??
                                            1;

                                  },

                                  decoration:
                                      const InputDecoration(

                                    filled:
                                        true,

                                    fillColor:
                                        Colors
                                            .white,

                                    border:
                                        OutlineInputBorder(),

                                  ),
                                ),
                              ),

                              IconButton(

                                onPressed: () {

                                  setState(() {

                                    itens.removeAt(
                                      index,
                                    );

                                  });

                                },

                                icon: const Icon(
                                  Icons.delete,
                                  color:
                                      Colors.black,
                                ),
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget botaoCategoria(
    String categoria,
  ) {

    return GestureDetector(

      onTap: () {

        adicionarItem(categoria);

      },

      child: Container(

        width: 75,
        height: 75,

        decoration: BoxDecoration(

          color: corCategoria(categoria),

          borderRadius:
              BorderRadius.circular(18),

        ),

        child: Icon(

          iconeCategoria(categoria),

          size: 35,

          color: Colors.black,

        ),
      ),
    );
  }
}