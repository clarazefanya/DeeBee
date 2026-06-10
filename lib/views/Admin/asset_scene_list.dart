import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:flutter/material.dart';

class AssetSceneList extends StatelessWidget {
  final String category;

  const AssetSceneList({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk simulasi ListView.builder/separated
    final List<Map<String, String>> dummyImages = [
      {
        'nama': 'Asset Gambar 1',
        'path': 'assets/images/avatars/user-avatars-1.jpg',
      },
      {
        'nama': 'Asset Gambar 2',
        'path': 'assets/images/avatars/user-avatars-2.jpg',
      },
    ];

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
                    category,
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
            ButtonCreateAdmin(text: "Upload Gambar", onPressed: () {}),
            const SizedBox(height: 20),

            //listtile asset scene list
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(bottom: 50),
                itemCount: dummyImages.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.zero,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          dummyImages[index]['path']!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        dummyImages[index]['nama']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      trailing: ActionCircleAdmin(
                        icon: Icons.delete,
                        color: AppColors.redComponent,
                        onTap: () {},
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
                                  child: Image.asset(
                                    dummyImages[index]['path']!,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
