import 'package:deebee_user/components/components.dart'; // Sesuaikan import kamu
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/models/scene_model.dart';
import 'package:flutter/material.dart';

class DialogInteraction extends StatefulWidget {
  final SceneModel scene; // Terima data scene aktif dari parent
  final VoidCallback onNext; // Terima fungsi trigger scene selanjutnya

  const DialogInteraction({
    super.key,
    required this.scene,
    required this.onNext,
  });

  @override
  State<DialogInteraction> createState() => _DialogInteractionState();
}

class _DialogInteractionState extends State<DialogInteraction> {
  @override
  Widget build(BuildContext context) {
    // Ambil kalimat opsional langsung dari object scene database
    final String? kalimatOpsional = widget.scene.optionalSentence;
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.end, // Menjaga konten tetap di bawah layar
      children: [
        // Kalimat opsional muncul jika data dari DB tidak null/kosong
        if (kalimatOpsional != null && kalimatOpsional.trim().isNotEmpty) ...[
          Text(
            kalimatOpsional,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Tombol Lanjut
        ButtonComponent(
          text: "Lanjut",
          bgcolor: AppColors.primaryHoney,
          onPressed: () {
            widget.onNext();
          },
        ),
        // Jarak aman khusus navbar device (seperti Samsung) agar tidak tumpang tindih
        const SizedBox(height: 50),
      ],
    );
  }
}
