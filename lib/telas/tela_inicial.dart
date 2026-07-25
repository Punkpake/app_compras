import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/lista.dart';
import 'tela_criar_lista.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() =>
      _TelaInicialState();
}

class _TelaInicialState
    extends State<TelaInicial> {

  List<ListaCompras> listas = [];

  @override
  void initState() {

    super.initState();

    carregarListas();

  }

  Future<void> salvarListas() async {

    final prefs =
        await SharedPreferences.getInstance();

    List<String> listasJson =

        listas.map((lista) {

          return jsonEncode(
            lista.toJson(),
          );

        }).toList();

    await prefs.setStringList(
      'listas',
      listasJson,
    );

  }

  Future<void> carregarListas() async {

    final prefs =
        await SharedPreferences.getInstance();

    List<String>? listasJson =
        prefs.getStringList('listas');

    if (listasJson != null) {

      setState(() {

        listas =
            listasJson.map((jsonString) {

          return ListaCompras.fromJson(

            jsonDecode(jsonString),

          );

        }).toList();

      });

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        title: const Text(

          "Minhas Listas",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: listas.isEmpty

          ? const Center(

              child: Text(

                "Nenhuma lista criada",

                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 20,
                ),
              ),
            )

          : ListView.builder(

              itemCount: listas.length,

              itemBuilder:
                  (context, index) {

                final lista = listas[index];

                return Padding(

                  padding:
                      const EdgeInsets.all(10),

                  child: Container(

                    padding:
                        const EdgeInsets.all(20),

                    decoration: BoxDecoration(

                      color: Colors.grey[900],

                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),

                    child: Row(

                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [

                        Expanded(

                          child: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Text(

                                lista.nome,

                                style:
                                    const TextStyle(

                                  color:
                                      Colors.white,

                                  fontSize: 22,

                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              Text(

                                "${lista.itens.length} itens",

                                style:
                                    TextStyle(

                                  color:
                                      Colors
                                          .grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(

                          onPressed: () async {

                            setState(() {

                              listas.removeAt(
                                index,
                              );

                            });

                            await salvarListas();

                          },

                          icon: const Icon(

                            Icons.delete,

                            color:
                                Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton:
          FloatingActionButton(

        backgroundColor: Colors.green,

        onPressed: () async {

          final novaLista =
              await Navigator.push(

            context,

            MaterialPageRoute(

              builder: (context) =>
                  const TelaCriarLista(),
            ),
          );

          if (novaLista != null) {

            setState(() {

              listas.insert(
                0,
                novaLista,
              );

            });

            await salvarListas();

          }

        },

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}