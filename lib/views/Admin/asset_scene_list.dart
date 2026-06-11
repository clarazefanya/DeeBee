import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/repository/asset_scene_repository.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/models/asset_scene_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AssetSceneList extends StatefulWidget {
  final String category;

  const AssetSceneList({super.key, required this.category});

  @override
  State<AssetSceneList> createState() => _AssetSceneListState();
}

class _AssetSceneListState extends State<AssetSceneList> {
  //logic upload gambar
  final ImagePicker picker = ImagePicker();

  Future<void> uploadAssetScene(String category) async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    final bytes = await file.readAsBytes();

    final asset = AssetSceneModel(
      imageName: file.name,
      image: bytes,
      category: category,
    );

    await AssetSceneRepository().createAssetScene(asset);
  }

  //refresh halaman
  late Future<List<AssetSceneModel>> assetsFuture;
  @override
  void initState() {
    super.initState();

    loadAssets();
  }

  void loadAssets() {
    assetsFuture = AssetSceneRepository().getAssetSceneByCategory(
      widget.category,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DeebeeAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //button back dan nama category yg dipilih
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.category,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            //tombol upload gambar
            ButtonCreateAdmin(
              text: "Upload Gambar",
              onPressed: () async {
                await uploadAssetScene(widget.category);
                setState(() {
                  loadAssets();
                });
              },
            ),
            const SizedBox(height: 20),

            //listtile asset scene list
            Expanded(
              child: FutureBuilder<List<AssetSceneModel>>(
                future: assetsFuture,
                builder: (context, snapshot) {
                  // 1. Kondisi Loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // 2. Kondisi Gagal/Error
                  if (snapshot.hasError) {
                    return const Center(child: Text("Gagal memuat data"));
                  }
                  // Data berhasil didapatkan
                  final assets = snapshot.data!;
                  // Belum ada data
                  if (assets.isEmpty) {
                    return const Center(child: Text('Belum ada gambar'));
                  }

                  return ListView.separated(
                    padding: EdgeInsets.only(bottom: 50),
                    itemCount: assets.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final asset = assets[index];
                      return Card(
                        margin: EdgeInsets.zero,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.memory(
                              asset.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            asset.imageName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          trailing: ActionCircleAdmin(
                            icon: Icons.delete,
                            color: AppColors.redComponent,
                            onTap: () {
                              confirmDeleteImage(asset.id!);
                            },
                          ),
                          onTap: () {
                            //jika listtile diklik muncul preview gambarnya
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.memory(
                                        asset.image,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  //function tombol icon delete
  void confirmDeleteImage(int imageId) {
    //tampilkan dialog konfirmasi
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: const Text("Yakin ingin menghapus gambar ini?"),
          actions: [
            // Tombol Batal
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Tutup dialog saja
              },
              child: const Text("Batal"),
            ),
            // Tombol Ya
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext); // Tutup dialog dulu

                // Jalankan fungsi delete
                await AssetSceneRepository().deleteAssetScene(imageId);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Gambar berhasil dihapus")),
                );

                setState(() {
                  loadAssets();
                });
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Ya, Hapus"),
            ),
          ],
        );
      },
    );
  }
}
