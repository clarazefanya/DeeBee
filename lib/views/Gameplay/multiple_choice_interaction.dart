import 'package:deebee_user/components/components.dart'; // Sesuaikan import kamu
import 'package:deebee_user/constants/colors.dart';
import 'package:flutter/material.dart';

class MultipleChoiceInteraction extends StatefulWidget {
  const MultipleChoiceInteraction({super.key});

  @override
  State<MultipleChoiceInteraction> createState() =>
      _MultipleChoiceInteractionState();
}

class _MultipleChoiceInteractionState extends State<MultipleChoiceInteraction> {
  // Simpan status opsi yang dipilih (null berarti belum ada yang dipilih)
  String? _selectedOption;

  // Dummy data soal dan opsi, nanti ini dapet dari database
  final String _soal =
      "Perintah apa yang digunakan untuk mengambil kolom tertentu dari sebuah tabel?";
  final Map<String, String> _options = {
    'A': 'SELECT nama_kolom FROM nama_tabel;',
    'B': 'GET nama_kolom FROM nama_tabel;',
    'C': 'EXTRACT nama_kolom FROM nama_tabel;',
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end, // Nempel di bawah layar
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teks Soal
          Text(
            _soal,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlack,
            ),
          ),
          const SizedBox(height: 16),

          // Looping Opsi A, B, C
          ..._options.entries.map((entry) {
            return _buildOptionCard(entry.key, entry.value);
          }),
          const SizedBox(height: 24),

          // Tombol Submit / Jawab
          ButtonComponent(
            text: "Jawab",
            bgcolor: AppColors.primaryHoney,
            //Tombol di-disable (null) jika user belum memilih opsi apa pun
            onPressed: _selectedOption == null
                ? null
                : () {
                    // Logic cek jawaban benar/salah nanti di sini
                  },
          ),

          // Jarak aman untuk device Samsung agar tidak bentrok dengan navbar bawaan hp
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // Helper Widget untuk membuat Card Option dinamis kondisional
  Widget _buildOptionCard(String huruf, String teksOpsi) {
    bool isSelected = _selectedOption == huruf;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedOption =
                huruf; // Mengubah state pilihan (hanya bisa pilih satu)
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            // Logic warna background berubah sesuai requirement jika dipilih
            color: isSelected
                ? AppColors.primaryHoney.withValues(alpha: 0.2)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            // Logic warna border berubah sesuai requirement jika dipilih
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryHoney
                  : AppColors.borderBrown,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Lingkaran Huruf Opsi
              CircleAvatar(
                radius: 16,
                backgroundColor: isSelected
                    ? AppColors.primaryHoney
                    : const Color(0xFFF0F0F0),
                child: Text(
                  huruf,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.borderBrown,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Teks Jawaban Opsi
              Expanded(
                child: Text(
                  teksOpsi,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryBlack,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
