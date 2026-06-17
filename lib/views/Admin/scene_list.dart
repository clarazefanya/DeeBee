import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/components/components_admin.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/repository/scene_repository.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/models/scene_model.dart';
import 'package:deebee_user/views/admin/scene_form.dart';
import 'package:flutter/material.dart';

class SceneList extends StatefulWidget {
  final String namaLevel;
  final int levelId;
  final String? levelNote;
  final bool isIntro;

  const SceneList({
    super.key,
    required this.namaLevel,
    required this.levelId,
    this.levelNote,
    this.isIntro = false,
  });

  @override
  State<SceneList> createState() => _SceneListState();
}

class _SceneListState extends State<SceneList> {
  // Inisialisasi class SceneRepository() tempat fungsi getScenesByLevel berada
  final _sceneRepo = SceneRepository();

  // Variabel untuk menampung fungsi Future agar tidak ter-trigger ulang saat build dikerjakan
  late Future<List<SceneModel>> _scenesFuture;

  @override
  void initState() {
    super.initState();
    refreshScenes();
  }

  // Fungsi untuk memicu pengambilan/pembaruan data dari database (refresh data)
  void refreshScenes() {
    setState(() {
      _scenesFuture = _sceneRepo.getScenesByLevel(widget.levelId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DeebeeAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Row back button dan nama level
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.namaLevel,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            //note admin
            Row(
              children: [
                Text(
                  'Catatan admin',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 6),
                ActionCircleAdmin(
                  icon: Icons.edit,
                  color: AppColors.blueComponent,
                  onTap: () {
                    //blm tersedia
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Fitur ini belum tersedia pada MVP"),
                      ),
                    );
                  },
                ),
              ],
            ),
            if (widget.levelNote?.isNotEmpty ?? false)
              Container(
                constraints: const BoxConstraints(maxHeight: 60),
                child: SingleChildScrollView(
                  child: Text(
                    '${widget.levelNote}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            const SizedBox(height: 10),

            // FutureBuilder diletakkan sebelum pembentukan tombol agar total panjang data (sceneLength) diketahui secara real-time
            FutureBuilder<List<SceneModel>>(
              future: _scenesFuture,
              builder: (context, snapshot) {
                // 1. Kondisi Loading data database
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                // 2. Kondisi jika terjadi error
                if (snapshot.hasError) {
                  return Expanded(
                    child: Center(
                      child: Text('Terjadi kesalahan: ${snapshot.error}'),
                    ),
                  );
                }
                // Ambil data list hasil return dari database
                final listScene = snapshot.data ?? [];
                final int sceneLength = listScene.length;

                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tombol buat scene baru
                      ButtonCreateAdmin(
                        text: "Buat Scene Baru",
                        onPressed: () async {
                          // Menunggu feedback true jika penambahan data di halaman form sukses dilakukan
                          final result = await context.push(
                            SceneForm(
                              levelId: widget.levelId,
                              nomorLevel: widget.namaLevel,
                              nomorScene: widget.isIntro
                                  ? "Intro Scene ${sceneLength + 1}"
                                  : "Scene ${sceneLength + 1}",
                              title: "Buat Scene Baru",
                              isIntro: widget.isIntro,
                            ),
                          );

                          // Jika kembali membawa status true, refresh list view
                          if (result == true) refreshScenes();
                        },
                      ),
                      const SizedBox(height: 20),

                      // 3. Kondisi jika data di database kosong
                      if (sceneLength == 0)
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Belum ada scene di level ini.\nSilakan buat scene baru.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        // 4. Kondisi jika data berhasil ditemukan
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.only(bottom: 50),
                            itemCount: sceneLength,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final currentScene = listScene[index];

                              return Card(
                                margin: EdgeInsets.zero,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  title: Text(
                                    widget.isIntro
                                        ? "Intro Scene ${index + 1}"
                                        : "Scene ${index + 1}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Icon Edit
                                      ActionCircleAdmin(
                                        icon: Icons.edit,
                                        color: AppColors.blueComponent,
                                        onTap: () async {
                                          // Menunggu feedback true jika pengeditan data di halaman form sukses dilakukan
                                          final result = await context.push(
                                            SceneForm(
                                              levelId: widget.levelId,
                                              scene: currentScene,
                                              nomorLevel: widget.namaLevel,
                                              nomorScene: widget.isIntro
                                                  ? "Intro Scene ${index + 1}"
                                                  : "Scene ${index + 1}",
                                              title: "Edit Scene",
                                              isIntro: widget.isIntro,
                                            ),
                                          );

                                          if (result == true) refreshScenes();
                                        },
                                      ),
                                      const SizedBox(width: 8),

                                      // Icon Delete
                                      ActionCircleAdmin(
                                        icon: Icons.delete,
                                        color: AppColors.redComponent,
                                        onTap: () {
                                          _showDeleteDialog(currentScene.id);
                                        },
                                      ),
                                    ],
                                  ),
                                  onTap: () {},
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Dialog konfirmasi delete data
  void _showDeleteDialog(int? sceneId) {
    if (sceneId == null) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Scene'),
        content: const Text('Apakah Anda yakin ingin menghapus scene ini?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () async {
              context.pop();
              // Panggil fungsi delete di SceneRepo
              await _sceneRepo.deleteScene(sceneId);
              refreshScenes(); // Refresh list setelah dihapus
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Scene berhasil dihapus')),
              );
            },
            child: const Text('Ya, Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
