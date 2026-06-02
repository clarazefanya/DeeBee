import 'dart:async';

import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //variable dots carousel
  final PageController pageControl = PageController();
  late Timer timer;
  int currentPage = 0;

  //auto slide carousel
  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
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
    timer.cancel();
    pageControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DeebeeAppbar(isGameplay: false),
      body: ListView(
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

                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.white,
                      margin: EdgeInsets.zero,
                      elevation: 0,
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
                                color: AppColors.primaryCream,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.play_arrow),
                            ),
                            SizedBox(width: 16),

                            //right side
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //status
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryCream,
                                      borderRadius: BorderRadius.circular(9999),
                                    ),
                                    child: Text("IN PROGRESS"),
                                  ),

                                  //title
                                  Text(
                                    "DML (Data Manipulation Language)",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 6),

                                  //desc
                                  Text(
                                    "Pelajari cara mengelola data dengan SELECT, INSERT, UPDATE.",
                                  ),
                                  SizedBox(height: 12),

                                  //progress bar
                                  Row(
                                    children: [
                                      Expanded(
                                        child: LinearProgressIndicator(
                                          value: 0.60,
                                          minHeight: 12,
                                          backgroundColor: const Color(
                                            0xFFF9ECDB,
                                          ),
                                          color: AppColors.primaryHoney,
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),

                                      Text("60%"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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

Widget banner({required Color color, required String text}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
    ),

    alignment: Alignment.center,

    child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
