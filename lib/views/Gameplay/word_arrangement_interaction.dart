import 'package:deebee_user/components/components.dart'; // Sesuaikan import kamu
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/preference_handler.dart';
import 'package:deebee_user/models/scene_model.dart';
import 'package:deebee_user/services/gameplay_progress_service.dart';
import 'package:flutter/material.dart';

class WordArrangementInteraction extends StatefulWidget {
  final SceneModel scene; // Terima data scene aktif
  final VoidCallback onNext; // Terima fungsi trigger scene selanjutnya
  final VoidCallback onRefresh; // Terima fungsi trigger refresh 1 halaman

  const WordArrangementInteraction({
    super.key,
    required this.scene,
    required this.onNext,
    required this.onRefresh,
  });

  @override
  State<WordArrangementInteraction> createState() =>
      _WordArrangementInteractionState();
}

class _WordArrangementInteractionState
    extends State<WordArrangementInteraction> {
  //Ambil userId dari SharedPreferences
  final int? currentUserId = PreferenceHandler.userId;

  List<String> _randomizedWords = [];
  final List<int> _selectedIndexes = [];

  @override
  void initState() {
    super.initState();
    _initializeWords();
  }

  // Dipanggil otomatis oleh Flutter jika object widget.scene diganti dari parent (Gameplay)
  @override
  void didUpdateWidget(covariant WordArrangementInteraction oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scene.id != widget.scene.id) {
      _initializeWords();
    }
  }

  // Fungsi memecah dan mengacak kata dari database
  void _initializeWords() {
    _selectedIndexes.clear(); // Bersihkan sisa jawaban scene sebelumnya
    final String kunciJawaban = widget.scene.answerKey ?? '';

    if (kunciJawaban.trim().isNotEmpty) {
      _randomizedWords = kunciJawaban.split(' ');
      _randomizedWords.shuffle(); // Acak urutan array
    } else {
      _randomizedWords = [];
    }
  }

  // Fungsi untuk menggabungkan kata-kata yang dipilih menjadi satu kalimat utuh
  String get _currentAnswer {
    return _selectedIndexes.map((index) => _randomizedWords[index]).join(' ');
  }

  // Fungsi memvalidasi jawaban susun kata
  Future<void> _checkAnswer() async {
    final String jawabanUser = _currentAnswer.trim().toLowerCase();
    final String jawabanBenar = (widget.scene.answerKey ?? '')
        .trim()
        .toLowerCase();

    final bool isCorrect = jawabanUser == jawabanBenar;

    // Jika jawaban benar: simpan progress dan tambah xp, refresh halaman
    if (isCorrect) {
      await saveSceneProgress(userId: currentUserId!, scene: widget.scene);
      widget.onRefresh();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                isCorrect ? 'Query Berhasil!' : 'Query Error / Salah',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          content: Text(
            isCorrect
                ? 'Kamu mendapatkan +${widget.scene.rewardXp} XP.'
                : 'Susunan kueri SQL kamu tidak valid. Coba susun ulang!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup pop-up dialog
                if (isCorrect) {
                  widget
                      .onNext(); // Hanya jika benar, lanjut ke scene berikutnya
                }
              },
              child: Text(
                isCorrect ? 'Lanjut' : 'Coba Lagi',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String soalText =
        widget.scene.question ?? 'Pertanyaan tidak tersedia';

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Soal Asli DB
          Text(
            soalText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlack,
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            "SQL Editor",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),

          // Kotak Tampilan Output
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
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Area Kotak-kotak Kata
          Wrap(
            spacing: 10,
            runSpacing: 12,
            children: List.generate(_randomizedWords.length, (index) {
              bool isSelected = _selectedIndexes.contains(index);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedIndexes.remove(
                        index,
                      ); // Bebas hapus darimana saja
                    } else {
                      _selectedIndexes.add(index); // Tambahkan ke array jawaban
                    }
                  });
                },
                child: Card(
                  elevation: isSelected ? 0 : 3,
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
              Expanded(
                child: ButtonComponent(
                  text: "Hapus",
                  bgcolor: AppColors.primaryCream,
                  onPressed: _selectedIndexes.isEmpty
                      ? null // Matikan tombol jika belum nulis apa-apa
                      : () {
                          setState(() {
                            _selectedIndexes.clear();
                          });
                        },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ButtonComponent(
                  text: "Jawab",
                  bgcolor: AppColors.primaryHoney,
                  onPressed: _selectedIndexes.isEmpty ? null : _checkAnswer,
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
