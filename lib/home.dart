import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DeebeeAppbar(isGameplay: false),
      body: ListView(
        children: [
          //carousel nanti pindahin kesini
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // CAROUSEL
                SizedBox(
                  height: 180,

                  child: PageView(
                    children: [
                      banner(
                        color: Colors.orange,
                        text: "Selamat datang di DeeBee!",
                      ),

                      banner(
                        color: Colors.blue,
                        text: "Belajar SQL lebih seru 🚀",
                      ),

                      banner(
                        color: Colors.green,
                        text: "Kumpulkan XP sebanyak mungkin!",
                      ),
                    ],
                  ),
                ),

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
