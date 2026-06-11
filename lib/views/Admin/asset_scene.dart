import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/views/Admin/asset_scene_list.dart';
import 'package:flutter/material.dart';

class AssetScene extends StatefulWidget {
  const AssetScene({super.key});

  @override
  State<AssetScene> createState() => _AssetSceneState();
}

class _AssetSceneState extends State<AssetScene> {
  @override
  Widget build(BuildContext context) {
    //data asset scene
    final List<String> category = ['Background', 'Karakter'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //judul halaman
              const Center(
                child: Text(
                  'Asset Scene',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),

              //listtile asset scene
              ...category.map(
                (category) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      category,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.push(AssetSceneList(category: category));
                    },
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
