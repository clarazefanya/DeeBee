import 'package:deebee_user/components/components.dart'; // Sesuaikan import kamu
import 'package:deebee_user/constants/colors.dart';
import 'package:flutter/material.dart';

class WordArrangementInteraction extends StatefulWidget {
  const WordArrangementInteraction({super.key});

  @override
  State<WordArrangementInteraction> createState() =>
      _WordArrangementInteractionState();
}

class _WordArrangementInteractionState
    extends State<WordArrangementInteraction> {
  final String _soal = "Tampilkan semua kolom dari tabel products!";
  final String _kunciJawaban = "SELECT * FROM products";

  List<String> _randomizedWords = [];
  // Kita menyimpan INDEX dari kata yang dipilih, bukan string-nya.
  // Ini penting agar jika ada kata yang sama (misal ada dua kata "SELECT"), sistem tidak bingung.
  final List<int> _selectedIndexes = [];

  @override
  void initState() {
    super.initState();
    // Pecah kalimat menjadi array kata-kata berdasarkan spasi
    _randomizedWords = _kunciJawaban.split(' ');
    // Acak urutan array nya
    _randomizedWords.shuffle();
  }

  // Fungsi untuk menggabungkan kata-kata yang dipilih menjadi satu kalimat utuh
  String get _currentAnswer {
    return _selectedIndexes.map((index) => _randomizedWords[index]).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Soal
          Text(
            _soal,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlack,
            ),
          ),
          const SizedBox(height: 16),

          // Label SQL Editor
          const Text(
            "SQL Editor",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),

          // Kotak Tampilan (Pengganti TextField Readonly)
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 120),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderBrown, width: 1),
            ),
            child: Text(
              _currentAnswer.isEmpty
                  ? "Tap kata di bawah untuk menyusun query..."
                  : _currentAnswer,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _currentAnswer.isEmpty ? Colors.grey : Colors.black,
                fontFamily:
                    'monospace', // Opsional: Biar fontnya kayak di code editor beneran
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Area Kotak-kotak Kata (Menggunakan Wrap agar otomatis turun baris)
          Wrap(
            spacing: 10, // Jarak horizontal antar kotak
            runSpacing: 12, // Jarak vertikal antar kotak
            children: List.generate(_randomizedWords.length, (index) {
              bool isSelected = _selectedIndexes.contains(index);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      // LOGIC UNSELECT: Hanya bisa unselect jika ini adalah kata terakhir yang dimasukkan
                      // if (_selectedIndexes.last == index) {
                      //   _selectedIndexes.removeLast();
                      // } else {
                      //   // Opsional: Tampilkan snackbar peringatan kalau user ngeyel pencet kata di tengah
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(
                      //       content: Text(
                      //         "Hapus dari kata yang paling terakhir dulu!",
                      //       ),
                      //       duration: Duration(seconds: 1),
                      //     ),
                      //   );
                      // }

                      // LOGIC UNSELECT: Bebas hapus darimana saja
                      _selectedIndexes.remove(index);
                    } else {
                      // LOGIC SELECT: Tambahkan ke array jawaban
                      _selectedIndexes.add(index);
                    }
                  });
                },
                child: Card(
                  elevation: isSelected
                      ? 0
                      : 3, // Kalau dipencet, bayangan hilang
                  color: isSelected ? Colors.grey[300] : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isSelected
                          ? Colors.grey[400]!
                          : AppColors.borderBrown,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      _randomizedWords[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isSelected ? Colors.grey[600] : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 32),

          // Row Buttons
          Row(
            children: [
              // Button Hapus Jawaban
              Expanded(
                child: ButtonComponent(
                  text: "Hapus Jawaban",
                  bgcolor: AppColors.redComponent,
                  onPressed: () {
                    setState(() {
                      // Ngosongin semua jawaban & unselect semua kotak
                      _selectedIndexes.clear();
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Button Jawab
              Expanded(
                child: ButtonComponent(
                  text: "Jawab",
                  bgcolor: AppColors.primaryHoney,
                  onPressed: () {
                    // Logic cek jawaban nanti di sini
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
