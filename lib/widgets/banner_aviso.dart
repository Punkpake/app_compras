import 'package:flutter/material.dart';

class BannerAviso extends StatelessWidget {
  final String texto;
  const BannerAviso({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(8),
        border: const Border(left: BorderSide(color: Color(0xFFF97316), width: 4)),
      ),
      child: Text(texto, style: const TextStyle(color: Colors.white, fontSize: 13)),
    );
  }
}