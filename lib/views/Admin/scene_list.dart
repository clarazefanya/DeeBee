import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/views/Admin/scene_form.dart';
import 'package:flutter/material.dart';

class SceneList extends StatelessWidget {
  final String namaLevel;
  final bool isIntro;

  const SceneList({super.key, required this.namaLevel, this.isIntro = false});

  @override
  Widget build(BuildContext context) {
    //Data dummy untuk simulasi ListView.separated
    final int sceneLength = 10;

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
                    namaLevel,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            //Tombol buat scene baru
            ButtonCreateAdmin(
              text: "Buat Scene Baru",
              onPressed: () {
                //ketika scene diklik, ke halaman SceneCreateForm
                context.push(
                  SceneForm(
                    nomorLevel: namaLevel,
                    nomorScene: isIntro
                        ? "Intro Scene ${sceneLength + 1}"
                        : "Scene ${sceneLength + 1}",
                    title: "Buat Scene Baru",
                    isIntro: isIntro,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            //List Scene
            Expanded(
              child: ListView.separated(
                // padding: EdgeInsets.zero,
                padding: EdgeInsets.only(bottom: 50),
                itemCount: sceneLength,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
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
                        isIntro
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
                          //Icon edit
                          ActionCircleAdmin(
                            icon: Icons.edit,
                            color: AppColors.blueComponent,
                            onTap: () {
                              //uncomment kalau sudah integrasi DB
                              // context.push(
                              //   SceneCreateForm(
                              //     nomorLevel: namaLevel,
                              //     nomorScene: isIntro
                              //         ? "Intro Scene ${index + 1}"
                              //         : "Scene ${index + 1}",
                              //     title: isIntro
                              //         ? "Intro Scene ${index + 1}"
                              //         : "Scene ${index + 1}",
                              //     isIntro: isIntro,
                              //   ),
                              // );
                            },
                          ),
                          const SizedBox(width: 8),
                          //Icon delete
                          ActionCircleAdmin(
                            icon: Icons.delete,
                            color: AppColors.redComponent,
                            onTap: () {},
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
      ),
    );
  }
}
