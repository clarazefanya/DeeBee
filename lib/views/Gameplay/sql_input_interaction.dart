import 'package:collection/collection.dart';
import 'package:deebee_user/components/components.dart'; // Sesuaikan import kamu
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/repository/exercise_db_repository.dart';
import 'package:deebee_user/models/scene_model.dart';
import 'package:flutter/material.dart';

class SqlInputInteraction extends StatefulWidget {
  final SceneModel scene; // Terima data scene aktif
  final VoidCallback onNext; // Terima fungsi trigger scene selanjutnya

  const SqlInputInteraction({
    super.key,
    required this.scene,
    required this.onNext,
  });

  @override
  State<SqlInputInteraction> createState() => _SqlInputInteractionState();
}

class _SqlInputInteractionState extends State<SqlInputInteraction> {
  final TextEditingController _sqlController = TextEditingController();
  final _exerciseDb = ExerciseDbRepository();

  bool _isResultChecked = false;

  // State untuk menampung data hasil kueri
  List<Map<String, dynamic>> _targetResult = [];
  List<Map<String, dynamic>> _userResult = [];
  // Menyimpan log error SQLite jika query user typo/salah syntax
  String? _errorMessage;
  // Variabel untuk mencatat kueri terakhir yang sukses/gagal di-run
  String _lastCheckedSql = "";

  @override
  void initState() {
    super.initState();
    _loadTargetResult();

    _sqlController.addListener(() {
      if (_isResultChecked) {
        setState(() {
          _isResultChecked = false;
          _userResult.clear();
          // Aman dibersihkan di sini karena user memang sedang mengetik ulang
          _errorMessage = null;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant SqlInputInteraction oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset state jika index scene berpindah dari halaman utama Gameplay
    if (oldWidget.scene.id != widget.scene.id) {
      _sqlController.clear();
      _isResultChecked = false;
      _lastCheckedSql = ""; // Reset pelacak kueri
      _userResult.clear();
      _errorMessage = null;
      _loadTargetResult();
    }
  }

  // Mengambil output dari kunci jawaban database secara dinamis
  void _loadTargetResult() async {
    final correctQuery = widget.scene.answerKey ?? '';
    if (correctQuery.isNotEmpty) {
      try {
        final res = await _exerciseDb.executeUserQuery(correctQuery);
        setState(() {
          _targetResult = res;
        });
      } catch (e) {
        print("Error loading target result: $e");
      }
    }
  }

  // Fungsi untuk menguji query buatan user tanpa mencocokkan jawaban dulu
  void _runUserQuery() async {
    print("RUN");
    final inputSql = _sqlController.text.trim();

    if (inputSql.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Query tidak boleh kosong!")),
      );
      return;
    }

    // Proteksi: Hanya menerima kueri bertipe SELECT
    if (!inputSql.toUpperCase().startsWith('SELECT')) {
      setState(() {
        _isResultChecked = true;
        _userResult.clear();
        _errorMessage =
            'Untuk versi saat ini hanya kueri SELECT yang diperbolehkan.';
      });
      return;
    }

    try {
      final res = await _exerciseDb.executeUserQuery(inputSql);
      setState(() {
        _userResult = List<Map<String, dynamic>>.from(res);
        _errorMessage = null; // Bersihkan error jika kueri sukses eksekusi
        _isResultChecked = true;
        _lastCheckedSql = inputSql; // Catat kueri sukses
      });
    } catch (e) {
      setState(() {
        _userResult.clear();
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isResultChecked = true;
        _lastCheckedSql = inputSql; // Catat kueri yang menghasilkan error
      });
    }
  }

  // Logika memvalidasi kesamaan output tabel user vs target kunci jawaban
  void _submitAnswer() {
    final inputSql = _sqlController.text.trim();

    // Cek apakah status belum cek hasil, ATAU teks di editor saat ini sudah berubah dibanding kueri terakhir yang dicek
    if (!_isResultChecked || inputSql != _lastCheckedSql) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Klik 'Cek Hasil' terlebih dahulu untuk menguji kueri kamu.",
          ),
        ),
      );
      return;
    }

    if (_errorMessage != null || inputSql.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kueri kamu masih error atau tidak valid!"),
        ),
      );
      return;
    }

    // Metode Deep Comparison mengecek apakah baris, kolom, dan urutan data bernilai sama persis
    final bool isCorrect = const DeepCollectionEquality().equals(
      _userResult,
      _targetResult,
    );

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
                isCorrect ? 'Query Sukses!' : 'Query Tidak Sesuai',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          content: Text(
            isCorrect
                ? 'kamu mendapatkan +${widget.scene.rewardXp} XP.'
                : 'Meskipun kueri sukses dieksekusi, output data yang dihasilkan tidak sesuai dengan Target Hasil yang diminta. Silakan periksa kembali filter atau kolom kamu!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (isCorrect) {
                  widget.onNext(); // Jika benar, panggil trigger lanjut scene
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

  /// Fungsi helper dinamis untuk membangun tabel data dari list hasil kueri SQLite
  Widget _buildDataTable(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "Tabel kosong (0 baris ditemukan)",
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      );
    }

    // Ambil string keys dari Map sebagai nama header kolom secara dinamis
    final columns = data.first.keys.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(AppColors.primaryCream),
        columns: columns.map((colName) {
          return DataColumn(
            label: Text(
              colName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
        rows: data.map((rowMap) {
          return DataRow(
            cells: columns.map((colName) {
              return DataCell(Text(rowMap[colName]?.toString() ?? 'NULL'));
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _sqlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String soalText =
        widget.scene.question ?? 'Pertanyaan tidak tersedia';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Soal
        Text(
          soalText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlack,
          ),
        ),
        const SizedBox(height: 16),

        // Accordion Target Hasil (Dinamis dari database kunci jawaban)
        ExpansionTile(
          title: const Text(
            "Target Hasil",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          iconColor: AppColors.primaryHoney,
          collapsedIconColor: AppColors.primaryBlack,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.borderBrown, width: 1),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.primaryHoney, width: 2),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: _buildDataTable(_targetResult),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Accordion Struktur Tabel (ERD)
        ExpansionTile(
          title: const Text(
            "Struktur Tabel",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          iconColor: AppColors.primaryHoney,
          collapsedIconColor: AppColors.primaryBlack,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.borderBrown, width: 1),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.primaryHoney, width: 2),
          ),
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OpenImage()),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/erd.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.fullscreen,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        const Text(
          "SQL Editor",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),

        // TextField SQL Editor Editable
        TextFormField(
          controller: _sqlController,
          maxLines: 4,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
          decoration: InputDecoration(
            hintText: "Tulis query disini, contoh: SELECT * FROM ...",
            hintStyle: const TextStyle(color: Color(0xFF626566), fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.borderBrown,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.borderBrown,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.borderBrown,
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        const Text(
          "Hasil Query",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),

        // Area Output dinamis
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 150, maxHeight: 250),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderBrown, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SingleChildScrollView(
              child: !_isResultChecked
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Klik 'Cek Hasil' untuk melihat output dari kueri kamu.",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : _errorMessage != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.red,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Kueri Error / Tidak Valid:",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  :
                    // Tampilkan tabel jika sukses tanpa error
                    _buildDataTable(_userResult),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Row Buttons Cek Hasil & Jawab
        Row(
          children: [
            Expanded(
              child: ButtonComponent(
                text: "Cek Hasil",
                bgcolor: AppColors.primaryCream,
                onPressed: _runUserQuery,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ButtonComponent(
                text: "Jawab",
                bgcolor: AppColors.primaryHoney,
                onPressed: _submitAnswer,
              ),
            ),
          ],
        ),
        const SizedBox(height: 130),
      ],
    );
  }
}

/// Halaman open image struktur query
class OpenImage extends StatelessWidget {
  const OpenImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 1.0,
          maxScale: 5.0,
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset('assets/images/erd.png', fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
