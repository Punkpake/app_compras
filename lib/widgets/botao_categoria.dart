import 'package:flutter/material.dart';
import '../constants/categorias.dart';

class BotaoCategoria extends StatelessWidget {
  final CategoriaConfig categoria;
  final VoidCallback aoTocar;

  const BotaoCategoria({super.key, required this.categoria, required this.aoTocar});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: aoTocar,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: categoria.cor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(categoria.icone, color: Colors.white, size: 22),
              const SizedBox(height: 4),
              Text(
                categoria.label,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}