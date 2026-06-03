import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/views/home.dart';
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
      appBar: DeebeeAppbar(isGameplay: false),
      body: ListView(
        children: [
          Column(
            children: [
              //row nama chapter dan button back
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.pop(Home());
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  Text(
                    "DML (Data Manipulation Language)",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              //listview chapter
              ListView.separated(
                itemCount: 4,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (BuildContext context, int index) {
                  //start card chapter
                  // var test layout card
                  String isStatus = "c";

                  return Stack(
                    children: [
                      //card
                      InkWell(
                        onTap: () {
                          // context.push(ChapterSelect());
                        },
                        child: Card(
                          color: Colors.white,
                          margin: EdgeInsets.zero,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: AppColors.borderCream),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                //row status bar dan chapter brp
                                Row(
                                  children: [
                                    //status bar
                                    Container(
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
                                            : AppColors.statusLocked.withValues(
                                                alpha: 0.5,
                                              ),
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
                                        fontSize: 12,
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
                                SizedBox(height: 8),

                                //desc chapter
                                Text(
                                  "Belajar mengambil data dari tabel.",
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 8),

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
        ],
      ),
    );
  }
}
