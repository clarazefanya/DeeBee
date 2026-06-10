import 'dart:async';

import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/models/home_mode_model.dart';
import 'package:deebee_user/views/Home/chapter_select.dart';
import 'package:deebee_user/views/Home/home.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key, required this.mode});

  final HomeMode mode;

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  //test var admin
  bool isPublished = false;

  //variable dots carousel
  final PageController pageControl = PageController();
  Timer? timer;
  int currentPage = 0;

  //auto slide carousel
  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      if (!pageControl.hasClients) return;
      currentPage++;

      if (currentPage > 2) {
        currentPage = 0;
      }

      pageControl.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    pageControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // CAROUSEL
        SizedBox(
          height: 180,

          child: PageView(
            controller: pageControl,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            //banner
            children: [
              banner(color: Colors.orange, text: "Selamat datang di DeeBee!"),
              banner(color: Colors.blue, text: "Belajar SQL lebih seru 🚀"),
              banner(
                color: Colors.green,
                text: "Kumpulkan XP sebanyak mungkin!",
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        //dots carousel
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: currentPage == index
                    ? AppColors.primaryHoney
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(999),
              ),
            );
          }),
        ),

        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PROGRESS BAR PERJALANAN BELAJARMU
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        //column main text dan subtext
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Perjalanan Belajarmu",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            Text(
                              "Progress belajar SQL",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Spacer(),
                        Text(
                          "32%",
                          style: TextStyle(
                            color: AppColors.primaryHoney,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
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

              // MODUL
              Text(
                "Modul",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              SizedBox(height: 12),

              //button create modul utk admin
              if (widget.mode == HomeMode.admin) ...[
                ButtonCreateAdmin(text: "Buat Modul Baru", onPressed: () {}),
                SizedBox(height: 12),
              ], //...[ ] artinya memasukkan beberapa widget sekaligus ke dalam list children.

              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 2,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (BuildContext context, int index) {
                  //start card module
                  // var test layout card
                  String isStatus = "c";

                  return Stack(
                    children: [
                      //card
                      InkWell(
                        onTap: () {
                          if (widget.mode == HomeMode.admin) {
                            context.push(ChapterSelect(mode: HomeMode.admin));
                          } else {
                            context.push(ChapterSelect(mode: HomeMode.user));
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //icon box
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isStatus == "c"
                                        ? AppColors.statusCompleted
                                        : isStatus == "i"
                                        ? AppColors.statusInProgress
                                        : AppColors.statusLocked,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    isStatus == "c"
                                        ? Icons.check_circle_outline
                                        : isStatus == "i"
                                        ? Icons.play_arrow
                                        : Icons.lock_outline,
                                    color: isStatus == "c"
                                        ? AppColors.statusCompletedIcon
                                        : AppColors.primaryBlack,
                                  ),
                                ),
                                SizedBox(width: 16),

                                //right side
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //title
                                      Text(
                                        "DDL (Data Definiton Language)",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 6),

                                      //desc
                                      Text(
                                        "Pelajari struktur database dengan CREATE, ALTER, DROP tables.",
                                      ),
                                      SizedBox(height: 12),

                                      //progress bar
                                      Row(
                                        children: [
                                          Expanded(
                                            child: LinearProgressIndicator(
                                              value: isStatus == "c"
                                                  ? 1.00
                                                  : isStatus == "i"
                                                  ? 0.5
                                                  : 0.00,
                                              minHeight: 12,
                                              backgroundColor: const Color(
                                                0xFFF9ECDB,
                                              ),
                                              color: isStatus == "c"
                                                  ? AppColors.statusCompleted
                                                        .withValues(alpha: 0.5)
                                                  : AppColors.statusInProgress
                                                        .withValues(alpha: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                            ),
                                          ),
                                          SizedBox(width: 8),

                                          Text(
                                            isStatus == "c"
                                                ? "100%"
                                                : isStatus == "i"
                                                ? "50%"
                                                : "0%",
                                          ),
                                        ],
                                      ),

                                      //row edit delete publish utk admin
                                      if (widget.mode == HomeMode.admin) ...[
                                        SizedBox(height: 6),
                                        Row(
                                          children: [
                                            ButtonActionAdmin(
                                              text: isPublished
                                                  ? "Unpublish"
                                                  : "Publish",
                                              bgColor: isPublished
                                                  ? Colors.transparent
                                                  : AppColors.primaryCream,
                                              onPressed: () {
                                                setState(() {
                                                  isPublished = !isPublished;
                                                });
                                              },
                                            ),
                                            SizedBox(width: 5),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                      //stack locked
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
                //end card module
              ),
            ],
          ),
        ),
      ],
    );
  }
}
