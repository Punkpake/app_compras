import 'package:flutter/material.dart';

import '../models/lista.dart';
import '../utils/armazenamento.dart';
import 'tela_criar_lista.dart';
import 'tela_lista.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() =>
      _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  List<ListaCompras> listas = [];

  @override
  void initState() {
    super.initState();
    carregarListas();
  }

  Future<void> carregarListas() async {
    final listasCarregadas =
        await Armazenamento.obterListas();

    if (mounted) {
      setState(() {
        listas = listasCarregadas;
      });
    }
  }

  Future<void> abrirLista(
    ListaCompras lista,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TelaLista(lista: lista),
      ),
    );

    await carregarListas();
  }

  Future<void> excluirLista(
    int index,
  ) async {
    final lista = listas[index];

    await Armazenamento.apagarListas([
      lista.id,
    ]);

    await carregarListas();
  }

  Future<void> criarNovaLista() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const TelaCriarLista(),
      ),
    );

    await carregarListas();
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

              itemBuilder: (context, index) {
                final lista = listas[index];

                return Padding(
                  padding:
                      const EdgeInsets.all(10),

                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(20),

                    onTap: () async {
                      await abrirLista(lista);
                    },

                    child: Container(
                      padding:
                          const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.grey[900],

                        borderRadius:
                            BorderRadius.circular(20),
                      ),

                      child: Row(
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
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                  height: 5,
                                ),

                                Text(
                                  "${lista.itens.length} itens",

                                  style: TextStyle(
                                    color:
                                        Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            onPressed: () async {
                              await excluirLista(
                                index,
                              );
                            },

                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

      floatingActionButton:
          FloatingActionButton(
        backgroundColor: Colors.green,

        onPressed: () async {
          await criarNovaLista();
        },

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}