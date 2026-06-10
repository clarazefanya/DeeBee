import 'package:deebee_user/components/components.dart'; // Sesuaikan import kamu
import 'package:deebee_user/constants/colors.dart';
import 'package:flutter/material.dart';

class DialogInteraction extends StatefulWidget {
  const DialogInteraction({super.key});

  @override
  State<DialogInteraction> createState() => _DialogInteractionState();
}

class _DialogInteractionState extends State<DialogInteraction> {
  // Dummy data kalimat opsional, nanti ini didapat dari database
  final String _kalimatOpsional =
      "Gunakan kesempatan ini untuk memahami dasar-dasarnya.";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.end, // Menjaga konten tetap di bawah layar
      children: [
        // Kalimat opsional muncul jika data dari DB tidak null/kosong
        if (_kalimatOpsional.isNotEmpty) ...[
          Text(
            _kalimatOpsional,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Tombol Lanjut
        ButtonComponent(
          text: "Lanjut",
          bgcolor: AppColors.primaryHoney,
          onPressed: () {
            // Aksi pindah scene berikutnya
          },
        ),
        // Jarak aman khusus navbar device (seperti Samsung) agar tidak tumpang tindih
        const SizedBox(height: 50),
      ],
    );
  }
}
