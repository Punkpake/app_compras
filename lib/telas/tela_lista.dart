import 'package:flutter/material.dart';

import '../models/lista.dart';

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
          : ListView.builder(
              itemCount:
                  widget.lista.itens.length,

              itemBuilder: (context, index) {
                final item =
                    widget.lista.itens[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  child: Container(
                    padding:
                        const EdgeInsets.all(15),

                    decoration: BoxDecoration(
                      color: Colors.grey[900],

                      borderRadius:
                          BorderRadius.circular(15),
                    ),

                    child: Row(
                      children: [
                        Checkbox(
                          value: item.concluido,

                          activeColor: Colors.green,

                          onChanged: (valor) {
                            setState(() {
                              widget.lista.itens[index] = item.copyWith(
                                  concluido: valor ?? false,
                              );
                            });
                          },
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            item.nome,

                            style: TextStyle(
                              color: item.concluido
                                  ? Colors.grey
                                  : Colors.white,

                              fontSize: 20,

                              decoration:
                                  item.concluido
                                      ? TextDecoration
                                          .lineThrough
                                      : TextDecoration.none,
                            ),
                          ),
                        ),

                        Text(
                          "x${item.quantidade}",

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}