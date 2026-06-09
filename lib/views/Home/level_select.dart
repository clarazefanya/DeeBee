import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/models/home_mode.dart';
import 'package:deebee_user/views/Admin/scene_list.dart';
import 'package:flutter/material.dart';

class LevelSelect extends StatefulWidget {
  const LevelSelect({super.key, required this.mode});

  final HomeMode mode;

  @override
  State<LevelSelect> createState() => _LevelSelectState();
}

class _LevelSelectState extends State<LevelSelect> {
  //var test gridview builder
  int levelsLength = 8;

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
                        context.pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Chapter 1",
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
                  "SELECT: Menampilkan Data",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                //paragraf desc chapter
                Text(
                  "Belajar mengambil data dari tabel menggunakan perintah SELECT dan memahami struktur query dasar.",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 24),

                //progres level
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryCream,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryHoney),
                  ),
                  //column tulisan dan progress bar
                  child: Column(
                    children: [
                      //row text dan angka progress
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Progres  Level",
                            style: TextStyle(
                              color: AppColors.primaryHoney,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "32%",
                            style: TextStyle(
                              color: AppColors.primaryHoney,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: 0.32,
                        backgroundColor: const Color(0xFFEBDFCE),
                        color: AppColors.primaryHoney,
                        borderRadius: BorderRadius.circular(9999),
                        minHeight: 16,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

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
                        if (widget.mode == HomeMode.admin) ...[
                          //tombol delete intro utk admin
                          ActionCircleAdmin(
                            icon: Icons.delete,
                            color: AppColors.redComponent,
                            onTap: () {},
                          ),
                          SizedBox(width: 8),
                        ],
                        Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () {
                      if (widget.mode == HomeMode.admin) {
                        //jika mode admin, ke halaman scene list
                        //nanti hrs ngikutin nama intro
                        context.push(SceneList(namaLevel: "Intro"));
                      } else {
                        //selain mode admin, ke halaman gameplay scene
                      }
                    },
                  ),
                ),
                SizedBox(height: 24),

                //tombol create intro utk admin
                if (widget.mode == HomeMode.admin) ...[
                  ButtonCreateAdmin(text: "Buat Intro Baru", onPressed: () {}),
                  SizedBox(height: 24),
                ],

                //gridview level
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.mode == HomeMode.admin
                      ? levelsLength + 1
                      : levelsLength,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    //button create level utk admin di slot terakhir
                    if (widget.mode == HomeMode.admin &&
                        index == levelsLength) {
                      return CreateLevelCard();
                    }

                    //card kotak level
                    String isStatus = "i";
                    return Column(
                      children: [
                        Expanded(
                          child:
                              //stack utk icon edit delete admin
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (widget.mode == HomeMode.admin) {
                                        //jika mode admin, ke halaman scene list
                                        context.push(
                                          SceneList(
                                            namaLevel: "Level ${index + 1}",
                                          ),
                                        );
                                      } else {
                                        //selain mode admin, ke halaman gameplay scene
                                      }
                                    },
                                    child: Card(
                                      margin: EdgeInsets.zero,
                                      elevation: isStatus == "l" ? 0 : 2,
                                      color: isStatus == "c"
                                          ? AppColors.statusCompleted
                                          : isStatus == "i"
                                          ? AppColors.primaryHoney
                                          : AppColors.statusLocked,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: SizedBox.expand(
                                        // width: double.infinity,
                                        // height: 80,
                                        child: Icon(
                                          isStatus == "c"
                                              ? Icons.check_circle_outline
                                              : isStatus == "i"
                                              ? Icons.play_arrow
                                              : Icons.lock_outline,
                                          color: isStatus == "c"
                                              ? AppColors.statusCompletedIcon
                                              : Colors.black,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  ),

                                  //tombol delete utk admin
                                  if (widget.mode == HomeMode.admin) ...[
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 4),
                                          ActionCircleAdmin(
                                            icon: Icons.delete,
                                            color: AppColors.redComponent,
                                            onTap: () {},
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

                        //reward XP
                        Text(
                          "REWARD: 20 XP",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
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
      onTap: () {},
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
