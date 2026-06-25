import 'package:deebee_user/components/components.dart'; // Sesuaikan import kamu
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/preference_handler.dart';
import 'package:deebee_user/database/repository/user_scene_progress_repository.dart';
import 'package:deebee_user/models/scene_model.dart';
import 'package:deebee_user/services/gameplay_progress_service.dart';
import 'package:flutter/material.dart';

class MultipleChoiceInteraction extends StatefulWidget {
  final SceneModel scene; // Terima data scene aktif
  final VoidCallback onNext; // Terima fungsi trigger scene selanjutnya
  final VoidCallback onRefresh; // Terima fungsi trigger refresh 1 halaman

  const MultipleChoiceInteraction({
    super.key,
    required this.scene,
    required this.onNext,
    required this.onRefresh,
  });

  @override
  State<MultipleChoiceInteraction> createState() =>
      _MultipleChoiceInteractionState();
}

class _MultipleChoiceInteractionState extends State<MultipleChoiceInteraction> {
  //Ambil userId dari SharedPreferences
  final int? currentUserId = PreferenceHandler.userId;

  // Simpan status opsi yang dipilih (null berarti belum ada yang dipilih)
  String? _selectedOption;

  // Fungsi untuk memvalidasi jawaban saat tombol di-klik
  Future<void> _checkAnswer() async {
    if (_selectedOption == null) return;

    // Var cek apakah scene ini sudah pernah complete
    final bool alreadyCompleted = await UserSceneProgressRepository()
        .isSceneCompleted(currentUserId!, widget.scene.id!);

    // Ambil kunci jawaban asli dari database (A, B, atau C)
    final String correctKey = widget.scene.answerKeyMultipleChoice ?? '';
    final bool isCorrect = _selectedOption == correctKey;

    // Jika jawaban benar: simpan progress dan tambah xp, refresh halaman
    if (isCorrect) {
      await saveSceneProgress(userId: currentUserId!, scene: widget.scene);
      widget.onRefresh();
    }

    // Tampilkan feedback pop-up berdasarkan kebenaran jawaban
    showDialog(
      context: context,
      barrierDismissible: false, // User wajib menekan tombol di dalam dialog
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isCorrect
                  ? AppColors.greenComponent
                  : AppColors.redComponent,
              width: 3,
            ),
          ),
          title: Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect
                    ? AppColors.greenComponent
                    : AppColors.redComponent,
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                isCorrect ? 'Jawaban Benar!' : 'Jawaban Salah',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCorrect
                      ? AppColors.greenComponent
                      : AppColors.redComponent,
                ),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 300),
            child: Text(
              isCorrect
                  ? alreadyCompleted
                        ? 'Selamat jawabanmu benar.'
                        : 'Kamu mendapatkan +${widget.scene.rewardXp} XP.'
                  : 'Yah, jawabanmu kurang tepat. Coba lagi.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup pop-up dialog feedback
                // JIKA BENAR: Lanjut ke scene berikutnya
                if (isCorrect) {
                  widget.onNext();
                }
              },
              child: Text(
                isCorrect ? 'Lanjut' : 'Perbaiki',
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
    // Ambil soal asli dari database
    final String soalText =
        widget.scene.question ?? 'Pertanyaan tidak tersedia';

    // Bungkus opsi dari DB ke dalam Map yang rapi
    final Map<String, String> options = {
      if (widget.scene.optionA != null) 'A': widget.scene.optionA!,
      if (widget.scene.optionB != null) 'B': widget.scene.optionB!,
      if (widget.scene.optionC != null) 'C': widget.scene.optionC!,
    };

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end, // Nempel di bawah layar
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teks Soal
          Text(
            soalText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlack,
            ),
          ),
          const SizedBox(height: 16),

          // Looping Opsi A, B, C
          ...options.entries.map((entry) {
            return buildOptionCard(entry.key, entry.value);
          }),
          const SizedBox(height: 24),

          // Tombol Submit / Jawab
          ButtonComponent(
            text: "Jawab",
            bgcolor: AppColors.primaryHoney,
            //Tombol di-disable (null) jika user belum memilih opsi apa pun
            onPressed: _selectedOption == null ? null : _checkAnswer,
          ),

          // Jarak aman untuk device Samsung agar tidak bentrok dengan navbar bawaan hp
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // Helper Widget untuk membuat Card Option dinamis kondisional
  Widget buildOptionCard(String huruf, String teksOpsi) {
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
