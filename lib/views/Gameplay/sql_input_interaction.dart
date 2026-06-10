import 'package:deebee_user/components/components.dart'; // Sesuaikan import kamu
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:flutter/material.dart';

class SqlInputInteraction extends StatefulWidget {
  const SqlInputInteraction({super.key});

  @override
  State<SqlInputInteraction> createState() => _SqlInputInteractionState();
}

class _SqlInputInteractionState extends State<SqlInputInteraction> {
  // Controller
  final TextEditingController _sqlController = TextEditingController();

  // State untuk melacak apakah tombol "Cek Hasil" sudah dipencet
  bool _isResultChecked = false;

  final String _soal =
      "Tampilkan semua data dari tabel products yang memiliki harga di atas 5000!";

  @override
  void dispose() {
    _sqlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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

        // Accordion Target Hasil
        ExpansionTile(
          title: const Text(
            "Target Hasil",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          iconColor: AppColors.primaryHoney,
          collapsedIconColor: AppColors.primaryBlack,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          // border saat tertutup
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.borderBrown, width: 1),
          ),
          // border saat terbuka
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.primaryHoney, width: 2),
          ),
          children: [
            // Dummy Tabel Hasil yang Diharapkan
            Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    AppColors.primaryCream,
                  ),
                  columns: const [
                    DataColumn(
                      label: Text(
                        'id',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'nama_produk',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'harga',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('1')),
                        DataCell(Text('Kopi Arabica')),
                        DataCell(Text('15000')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('3')),
                        DataCell(Text('Teh Manis')),
                        DataCell(Text('8000')),
                      ],
                    ),
                  ],
                ),
              ),
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
          // border saat tertutup
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.borderBrown, width: 1),
          ),
          // border saat terbuka
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.primaryHoney, width: 2),
          ),
          children: [
            // Gambar (sementara pakai foto yang sudah ada)
            GestureDetector(
              onTap: () {
                // buka gambar, bisa dizoom
                context.push(OpenImage());
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/toko-deebee.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Label SQL Editor
        const Text(
          "SQL Editor",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),

        // TextField SQL Editor Editable
        TextFormField(
          controller: _sqlController,
          maxLines: 5,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
          decoration: InputDecoration(
            hintText: "Ketik query SQL di sini...",
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

        // Label Hasil Query
        const Text(
          "Hasil Query",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),

        // Area Tabel Hasil Query (muncul jika udh pernah klik cek hasil)
        !_isResultChecked
            ? const Text(
                "Klik 'Cek Hasil' untuk melihat output dari query kamu.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                // Dummy hasil render dari input user
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    AppColors.primaryCream,
                  ),
                  columns: const [
                    DataColumn(label: Text('id')),
                    DataColumn(label: Text('nama_produk')),
                    DataColumn(label: Text('harga')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('1')),
                        DataCell(Text('Kopi Arabica')),
                        DataCell(Text('15000')),
                      ],
                    ),
                    // Nanti ini diisi berdasarkan response pengecekan DB
                  ],
                ),
              ),
        const SizedBox(height: 32),

        // Row Buttons Cek Hasil & Jawab
        Row(
          children: [
            Expanded(
              child: ButtonComponent(
                text: "Cek Hasil",
                bgcolor: AppColors.primaryCream,
                onPressed: () {
                  setState(() {
                    // Munculkan tabel hasil query
                    _isResultChecked = true;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: ButtonComponent(
                text: "Jawab",
                bgcolor: AppColors.primaryHoney,
                onPressed: () {
                  // Logic submit jawaban
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}

///halaman open image struktur query
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
          minScale: 1.0, // Ukuran asli
          maxScale: 5.0, // Maksimal zoom sampai 5x lipat
          child: Image.asset(
            'assets/images/toko-deebee.jpg',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
