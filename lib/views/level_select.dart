import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:flutter/material.dart';

class LevelSelect extends StatefulWidget {
  const LevelSelect({super.key});

  @override
  State<LevelSelect> createState() => _LevelSelectState();
}

class _LevelSelectState extends State<LevelSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DeebeeAppbar(isGameplay: false),
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

                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
                SizedBox(height: 24),

                //gridview level
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 8,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    String isStatus = "i";
                    return Column(
                      children: [
                        //card kotak level
                        Expanded(
                          child:
                              //stack utk icon edit delete admin
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Card(
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

                                  //tombol edit delete utk admin
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Row(
                                      children: [
                                        ActionCircleAdmin(
                                          icon: Icons.edit,
                                          color: AppColors.blueComponent,
                                          onTap: () {},
                                        ),
                                        SizedBox(width: 4),
                                        ActionCircleAdmin(
                                          icon: Icons.delete,
                                          color: AppColors.redComponent,
                                          onTap: () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ], ////b
                              ), /////b
                        ),
                        SizedBox(height: 10),

                        //nomor level
                        Text(
                          "Level 1",
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
