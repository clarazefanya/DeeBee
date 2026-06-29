import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/components/components_admin.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/preference_handler.dart';
import 'package:deebee_user/database/repository/level_repository.dart';
import 'package:deebee_user/database/repository/scene_repository.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/models/enums/home_mode_model.dart';
import 'package:deebee_user/models/enums/progress_status.dart';
import 'package:deebee_user/models/level_model.dart';
import 'package:deebee_user/services/progress_service.dart';
import 'package:deebee_user/views/admin/scene_list.dart';
import 'package:deebee_user/views/gameplay/gameplay_scene.dart';
import 'package:flutter/material.dart';

class LevelSelect extends StatefulWidget {
  const LevelSelect({
    super.key,
    required this.mode,
    required this.chapterId,
    required this.chapterName,
    required this.chapterTitle,
    required this.chapterLongDesc,
  });

  final HomeMode mode;
  final int chapterId;
  final String chapterName;
  final String chapterTitle;
  final String chapterLongDesc;

  @override
  State<LevelSelect> createState() => _LevelSelectState();
}

class _LevelSelectState extends State<LevelSelect> {
  //future di level
  late Future<List<LevelModel>> _levelsFuture;

  //Ambil userId n role dari SharedPreferences
  late int? currentUserId = PreferenceHandler.userId;
  final String? currentRole = PreferenceHandler.role;

  @override
  void initState() {
    super.initState();

    currentUserId = PreferenceHandler.userId;
    _levelsFuture = LevelRepository().getLevelsByChapter(widget.chapterId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DeebeeAppbar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //row  button back dan nomor chapter
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pop(true);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      widget.chapterName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                //nama chapter
                Text(
                  widget.chapterTitle,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                //paragraf longDesc chapter
                Text(widget.chapterLongDesc, style: TextStyle(fontSize: 14)),
                SizedBox(height: 24),

                //progres level
                // Container(
                //   padding: EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //     color: AppColors.primaryCream,
                //     borderRadius: BorderRadius.circular(12),
                //     border: Border.all(color: AppColors.primaryHoney),
                //   ),
                //   //column tulisan dan progress bar
                //   child: Column(
                //     children: [
                //       //row text dan angka progress
                //       Row(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           Text(
                //             "Progres  Level",
                //             style: TextStyle(
                //               color: AppColors.primaryHoney,
                //               fontWeight: FontWeight.w600,
                //               fontSize: 14,
                //             ),
                //           ),
                //           Spacer(),
                //           Text(
                //             "32%",
                //             style: TextStyle(
                //               color: AppColors.primaryHoney,
                //               fontWeight: FontWeight.bold,
                //               fontSize: 14,
                //             ),
                //           ),
                //         ],
                //       ),
                //       SizedBox(height: 8),
                //       LinearProgressIndicator(
                //         value: 0.32,
                //         backgroundColor: const Color(0xFFEBDFCE),
                //         color: AppColors.primaryHoney,
                //         borderRadius: BorderRadius.circular(9999),
                //         minHeight: 16,
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 24),

                //future builder utk intro dan grid level
                FutureBuilder<List<LevelModel>>(
                  future: _levelsFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final levels = snapshot.data!;
                    if (levels.isEmpty) {
                      return const Center(child: Text("Belum ada chapter"));
                    }

                    final intro = levels.firstWhere(
                      (e) => e.levelType == 'intro',
                    );

                    final gameplayLevels = levels
                        .where((e) => e.levelType == 'gameplay')
                        .toList();

                    return Column(
                      children: [
                        //intro
                        Card(
                          margin: EdgeInsets.zero,
                          elevation: 2,
                          color: AppColors.primaryHoney,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.play_arrow),
                            ),
                            title: Text(
                              "Intro",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // if (widget.mode == HomeMode.admin) ...[
                                //   //tombol delete intro utk admin
                                //   ActionCircleAdmin(
                                //     icon: Icons.delete,
                                //     color: AppColors.redComponent,
                                //     onTap: () {},
                                //   ),
                                //   SizedBox(width: 8),
                                // ],
                                Icon(Icons.chevron_right),
                              ],
                            ),
                            onTap: () async {
                              if (widget.mode == HomeMode.admin) {
                                //jika mode admin, ke halaman scene list
                                context.push(
                                  SceneList(
                                    namaLevel: "Intro",
                                    levelId: intro.id!,
                                    levelNote: intro.note,
                                    mode: widget.mode,
                                  ),
                                );
                              } else {
                                //selain mode admin, ke halaman gameplay
                                //Ambil data scene untuk level intro dari database
                                final scenes = await SceneRepository()
                                    .getScenesByLevel(intro.id!);

                                if (scenes.isEmpty) {
                                  // Antisipasi jika admin belum membuat scene sama sekali di level ini
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Konten level belum tersedia',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                // Arahkan ke halaman Gameplay dengan membawa list scenes
                                context.push(
                                  Gameplay(
                                    namaLevel: "Intro",
                                    levelId: intro.id!,
                                    scenes: scenes,
                                    isIntro: true,
                                    mode: widget.mode,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 24),

                        // //tombol create intro utk admin
                        // if (widget.mode == HomeMode.admin) ...[
                        //   ButtonCreateAdmin(text: "Buat Intro Baru", onPressed: () {}),
                        //   SizedBox(height: 24),
                        // ],

                        //gridview level
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.mode == HomeMode.admin
                              ? gameplayLevels.length + 1
                              : gameplayLevels.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.7,
                              ),
                          itemBuilder: (context, index) {
                            //button create level utk admin di slot terakhir
                            if (widget.mode == HomeMode.admin &&
                                index == gameplayLevels.length) {
                              return CreateLevelCard();
                            }

                            final level = gameplayLevels[index];

                            // future builder utk status level
                            return FutureBuilder<ProgressStatus>(
                              future: ProgressService().getLevelStatus(
                                currentUserId!,
                                level.id!,
                              ),
                              builder: (context, statusSnapshot) {
                                if (!statusSnapshot.hasData) {
                                  return const SizedBox.shrink();
                                }

                                final status = statusSnapshot.data!;

                                String isStatus;

                                switch (status) {
                                  case ProgressStatus.completed:
                                    isStatus = 'c';
                                    break;

                                  case ProgressStatus.inProgress:
                                    isStatus = 'i';
                                    break;

                                  case ProgressStatus.locked:
                                    isStatus = 'l';
                                    break;
                                }

                                //card kotak level
                                return Column(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1,
                                      child:
                                          //stack utk icon edit delete admin
                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  //jika status locked, tdk bisa dipencet
                                                  if (status ==
                                                      ProgressStatus.locked) {
                                                    return;
                                                  }

                                                  if (widget.mode ==
                                                      HomeMode.admin) {
                                                    //jika mode admin, ke halaman scene list
                                                    context.push(
                                                      SceneList(
                                                        namaLevel:
                                                            "Level ${index + 1}",
                                                        levelId: level.id!,
                                                        levelNote: level.note,
                                                        mode: widget.mode,
                                                      ),
                                                    );
                                                  } else {
                                                    //selain mode admin, ke halaman gameplay scene
                                                    //Ambil data scene untuk level gameplay ini
                                                    final scenes =
                                                        await SceneRepository()
                                                            .getScenesByLevel(
                                                              level.id!,
                                                            );

                                                    if (scenes.isEmpty) {
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                            'Konten level belum tersedia',
                                                          ),
                                                        ),
                                                      );
                                                      return;
                                                    }
                                                    // Arahkan ke halaman Gameplay
                                                    await context.push(
                                                      Gameplay(
                                                        namaLevel:
                                                            "Level ${index + 1}",
                                                        levelId: level.id!,
                                                        scenes: scenes,
                                                        mode: widget.mode,
                                                      ),
                                                    );
                                                    setState(() {});
                                                  }
                                                },
                                                child: Card(
                                                  margin: EdgeInsets.zero,
                                                  elevation: isStatus == "l"
                                                      ? 0
                                                      : 2,
                                                  color: isStatus == "c"
                                                      ? AppColors
                                                            .statusCompleted
                                                      : isStatus == "i"
                                                      ? AppColors.primaryHoney
                                                      : AppColors.statusLocked,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  child: SizedBox.expand(
                                                    // width: double.infinity,
                                                    // height: 80,
                                                    child: Icon(
                                                      isStatus == "c"
                                                          ? Icons
                                                                .check_circle_outline
                                                          : isStatus == "i"
                                                          ? Icons.play_arrow
                                                          : Icons.lock_outline,
                                                      color: isStatus == "c"
                                                          ? AppColors
                                                                .statusCompletedIcon
                                                          : Colors.black,
                                                      size: 32,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              //tombol delete utk admin
                                              if (widget.mode ==
                                                  HomeMode.admin) ...[
                                                Positioned(
                                                  top: 5,
                                                  right: 5,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: 4),
                                                      ActionCircleAdmin(
                                                        icon: Icons.delete,
                                                        color: AppColors
                                                            .redComponent,
                                                        onTap: () {
                                                          //blm tersedia
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                "Fitur ini belum tersedia pada MVP",
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ], //if
                                            ], ////b
                                          ), /////b
                                    ),
                                    SizedBox(height: 10),

                                    //nomor level
                                    Text(
                                      "Level ${index + 1}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    // //reward XP
                                    // Text(
                                    //   "Hadiah: 20 XP",
                                    //   style: TextStyle(
                                    //     fontSize: 10,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

///function button create level
class CreateLevelCard extends StatelessWidget {
  const CreateLevelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //blm tersedia
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fitur ini belum tersedia pada MVP")),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryHoney, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 36, color: AppColors.primaryHoney),
                  SizedBox(height: 8),
                  Text(
                    "Buat Level Baru",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //supaya tingginya mirip dengan LevelCard biasa
          SizedBox(height: 10),
          Text("", style: TextStyle(fontSize: 14)),
          Text("", style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
