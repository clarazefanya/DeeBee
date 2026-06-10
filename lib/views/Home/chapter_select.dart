import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/models/home_mode_model.dart';
import 'package:deebee_user/views/Home/level_select.dart';
import 'package:flutter/material.dart';

class ChapterSelect extends StatefulWidget {
  const ChapterSelect({super.key, required this.mode});

  final HomeMode mode;

  @override
  State<ChapterSelect> createState() => _ChapterSelectState();
}

class _ChapterSelectState extends State<ChapterSelect> {
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

                //button create chapter utk admin
                if (widget.mode == HomeMode.admin) ...[
                  ButtonCreateAdmin(
                    text: "Buat Chapter Baru",
                    onPressed: () {},
                  ),
                  SizedBox(height: 24),
                ],

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
                            if (widget.mode == HomeMode.admin) {
                              context.push(LevelSelect(mode: HomeMode.admin));
                            } else {
                              context.push(LevelSelect(mode: HomeMode.user));
                            }
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
                                      //chapter brp
                                      Text(
                                        "Chapter 1",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 8),

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
                                                    .withValues(alpha: 0.3)
                                              : isStatus == "i"
                                              ? AppColors.statusInProgress
                                                    .withValues(alpha: 0.3)
                                              : AppColors.statusLocked,
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

                                  //row edit delete utk admin
                                  if (widget.mode == HomeMode.admin) ...[
                                    SizedBox(height: 6),
                                    Row(
                                      children: [
                                        ButtonActionAdmin(
                                          text: "Edit",
                                          bgColor: AppColors.blueComponent,
                                          onPressed: () {},
                                        ),
                                        SizedBox(width: 5),
                                        ButtonActionAdmin(
                                          text: "Delete",
                                          bgColor: AppColors.redComponent,
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ], //if
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
