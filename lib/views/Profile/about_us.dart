import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DeebeeAppbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
        child: Center(
          child: ListView(
            children: [
              //logo
              Image.asset(
                "assets/images/logodb-transparan.png",
                height: 128,
                width: 128,
              ),

              //nama app
              Text(
                "DeeBee",
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),

              Text(
                "DeeBee adalah sebuah aplikasi belajar interaktif untuk mempelajari konsep database. Aplikasi ini menyediakan tantangan SQL yang dikemas dalam alur cerita yang menarik, sehingga proses belajar menjadi lebih interaktif dan menyenangkan. Pembelajaran dimulai dari materi dasar dan disusun secara bertahap, materi dikemas dalam bentuk level/chapter di mana setiap level berfokus pada topik SQL tertentu. Dalam aplikasi, user berperan sebagai karyawan toko kelontong bernama DeeBee,  yang akan dipandu oleh karyawan senior (mentor) disana.",
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),
              Text("Dibuat Oleh: Clara Zefanya Putri Junaidi"),
              SizedBox(height: 20),
              Text("Versi Aplikasi: 1.0.0"),
            ],
          ),
        ),
      ),
    );
  }
}
