import 'package:flutter/material.dart';

class CategoriaConfig {
  final String id;
  final String label;
  final Color cor;
  final IconData icone;

  const CategoriaConfig({
    required this.id,
    required this.label,
    required this.cor,
    required this.icone,
  });
}

const List<CategoriaConfig> categorias = [
  CategoriaConfig(id: 'frios', label: 'Frios', cor: Color(0xFF3B82F6), icone: Icons.ac_unit),
  CategoriaConfig(id: 'verduras', label: 'Verduras', cor: Color(0xFF22C55E), icone: Icons.eco),
  CategoriaConfig(id: 'prateleira', label: 'Prateleira', cor: Color(0xFFF97316), icone: Icons.inventory_2),
  CategoriaConfig(id: 'limpeza', label: 'Limpeza', cor: Color(0xFF6B7280), icone: Icons.cleaning_services),
];

CategoriaConfig obterCategoria(String id) {
  return categorias.firstWhere((c) => c.id == id, orElse: () => categorias.first);
}

const List<String> tiposMedida = ['Quilo', 'Litro', 'Quantidade', 'Dinheiro'];