import 'package:flutter/material.dart';
import '../constants/categorias.dart';
import '../models/item.dart';

class ItemLinha extends StatelessWidget {
  final ItemCompra item;
  final VoidCallback aoMarcar;

  const ItemLinha({super.key, required this.item, required this.aoMarcar});

  @override
  Widget build(BuildContext context) {
    final categoria = obterCategoria(item.categoria);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF1A1A1A))),
      ),
      child: Row(
        children: [
          Container(width: 4, height: 32, color: categoria.cor, margin: const EdgeInsets.only(right: 10)),
          Icon(categoria.icone, color: categoria.cor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nome.isEmpty ? '(sem nome)' : item.nome,
                  style: TextStyle(
                    color: item.concluido ? const Color(0xFF6B7280) : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: item.concluido ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text('${item.quantidade} ${item.tipoMedida}',
                    style: const TextStyle(color: Color(0xFF8A8A8A), fontSize: 12)),
              ],
            ),
          ),
          GestureDetector(
            onTap: aoMarcar,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.concluido ? const Color(0xFF22C55E) : Colors.transparent,
                border: Border.all(
                  color: item.concluido ? const Color(0xFF22C55E) : const Color(0xFF3B3B3B),
                  width: 2,
                ),
              ),
              child: item.concluido ? const Icon(Icons.check, size: 16, color: Colors.black) : null,
            ),
          ),
        ],
      ),
    );
  }
}