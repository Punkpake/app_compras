import 'package:flutter/material.dart';

class AcaoModal {
  final String rotulo;
  final VoidCallback aoTocar;
  final Color? cor;

  AcaoModal({required this.rotulo, required this.aoTocar, this.cor});
}

Future<void> exibirModalConfirmacao({
  required BuildContext context,
  required String titulo,
  String? mensagem,
  required List<AcaoModal> acoes,
  Widget? conteudoExtra,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (ctx) => Dialog(
      backgroundColor: const Color(0xFF111111),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF262626)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            if (mensagem != null) ...[
              const SizedBox(height: 8),
              Text(mensagem, style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 14, height: 1.4)),
            ],
            if (conteudoExtra != null) ...[
              const SizedBox(height: 12),
              conteudoExtra,
            ],
            const SizedBox(height: 16),
            ...acoes.map(
              (a) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: a.aoTocar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: a.cor ?? const Color(0xFF1F1F1F),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(a.rotulo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}