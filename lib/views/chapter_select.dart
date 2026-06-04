import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/views/level_select.dart';
import 'package:flutter/material.dart';

class ChapterSelect extends StatefulWidget {
  const ChapterSelect({super.key});

  @override
  State<ChapterSelect> createState() => _ChapterSelectState();
}

class _ChapterSelectState extends State<ChapterSelect> {
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
              children: [
                //button back dan row nama modul yg dipilih
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
                        "DML (Data Manipulation Language)",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                //listview chapter
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (BuildContext context, int index) {
                    //start card chapter
                    // var test layout card
                    String isStatus = "i";

                    return Stack(
                      children: [
                        //card
                        InkWell(
                          onTap: () {
                            context.push(LevelSelect());
                          },
                          child: Card(
                            color: Colors.white,
                            margin: EdgeInsets.zero,
                            elevation: isStatus == "l" ? 0 : 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: AppColors.borderCream),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //row status bar dan chapter brp
                                  Row(
                                    children: [
                                      //status bar
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            9999,
                                          ),
                                          color: isStatus == "c"
                                              ? AppColors.statusCompleted
                                                    .withValues(alpha: 0.5)
                                              : isStatus == "i"
                                              ? AppColors.statusInProgress
                                                    .withValues(alpha: 0.5)
                                              : AppColors.statusLocked
                                                    .withValues(alpha: 0.5),
                                        ),
                                        child: Text(
                                          isStatus == "c"
                                              ? "COMPLETED"
                                              : isStatus == "i"
                                              ? "IN PROGRESS"
                                              : "LOCKED",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: isStatus == "c"
                                                ? AppColors.statusCompleted
                                                : isStatus == "i"
                                                ? AppColors.statusInProgress
                                                : AppColors.primaryBlack,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),

                                      //chapter brp
                                      Text(
                                        "Chapter 1",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),

                                  //nama chapter
                                  Text(
                                    "SELECT: Menampilkan Data",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // SizedBox(height: 6),

                                  //desc chapter
                                  Text(
                                    "Belajar mengambil data dari tabel.",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 16),

                                  //row progress dan angka progress
                                  Row(
                                    children: [
                                      Text(
                                        "Progress",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Spacer(),
                                      Text(
                                        isStatus == "c"
                                            ? "100%"
                                            : isStatus == "i"
                                            ? "50%"
                                            : "0%",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),

                                  //progress bar
                                  LinearProgressIndicator(
                                    value: isStatus == "c"
                                        ? 1.00
                                        : isStatus == "i"
                                        ? 0.50
                                        : 0.00,
                                    minHeight: 12,
                                    backgroundColor: const Color(0xFFF9ECDB),
                                    color: isStatus == "c"
                                        ? AppColors.statusCompleted.withValues(
                                            alpha: 0.5,
                                          )
                                        : AppColors.statusInProgress.withValues(
                                            alpha: 0.5,
                                          ),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //overlay locked
                        if (isStatus == "l")
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primaryCream.withValues(
                                  alpha: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                  //end card chapter
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
