import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DeebeeAppbar(isGameplay: false),
      body: ListView(
        children: [
          Stack(
            children: [
              //background kotak kuning
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryHoney.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),

              //komponen profile
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    //nametag outer
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      color: AppColors.primaryHoney,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      //card
                      child: Padding(
                        // padding: const EdgeInsets.symmetric(
                        //   vertical: 25,
                        //   horizontal: 8,
                        // ),
                        padding: const EdgeInsets.only(
                          top: 30,
                          bottom: 8,
                          left: 8,
                          right: 8,
                        ),
                        child: Container(
                          // padding: EdgeInsets.all(16),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 25,
                          ),
                          // margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              //row logo dan tulisan deebee
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/logodb-transparan.png",
                                    width: 40,
                                    height: 40,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "DeeBee",
                                    style: TextStyle(
                                      fontFamily: 'Fredoka',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 28,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),

                              //avatar
                              Container(
                                // padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primaryHoney,
                                    width: 5,
                                  ),
                                  color: Colors.white,
                                ),
                                child: const CircleAvatar(
                                  radius: 50,
                                  backgroundImage: AssetImage(
                                    "assets/images/User Avatar.png",
                                  ),
                                ),
                              ),
                              SizedBox(height: 24),

                              //nama user
                              Text(
                                "USER NAME",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 32),

                              //row email
                              Row(
                                children: [
                                  Icon(Icons.email_outlined),
                                  SizedBox(width: 8),
                                  Text(
                                    "Email",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Spacer(),
                                  Text("username@gmail.com"),
                                ],
                              ),
                              SizedBox(height: 12),

                              //row bergabung
                              Row(
                                children: [
                                  Icon(Icons.calendar_month_outlined),
                                  SizedBox(width: 8),
                                  Text(
                                    "Bergabung",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Spacer(),
                                  Text("12 Mei 2026"),
                                ],
                              ),
                              SizedBox(height: 40),

                              //capsule XP
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryHoney,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Text(
                                  "1000 XP",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),

                    //3 kotak statistik
                    Row(
                      children: [
                        //progress
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 26,
                            ),
                            // padding: EdgeInsets.all(26),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.borderCream),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryHoney.withValues(
                                      alpha: 0.20,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: const Color(0xFF7C5800),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text("Progres", style: TextStyle(fontSize: 13)),
                                SizedBox(height: 8),
                                Text(
                                  "32%",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),

                        //level selesai
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 26,
                            ),
                            // padding: EdgeInsets.all(26),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.borderCream),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.statusCompleted.withValues(
                                      alpha: 0.20,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: AppColors.statusCompleted,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Level\nSelesai",
                                  style: TextStyle(fontSize: 13),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "42",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),

                        //chapter
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 26,
                            ),
                            // padding: EdgeInsets.all(26),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.borderCream),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(
                                      0xFF00D7FE,
                                    ).withValues(alpha: 0.20),
                                  ),
                                  child: Icon(
                                    Icons.menu_book_outlined,
                                    color: Color(0xFF00687B),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text("Chapter", style: TextStyle(fontSize: 13)),
                                SizedBox(height: 8),
                                Text(
                                  "4",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    //settings, feedback, about us

                    //data management

                    //button logout
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
