//banner 1 (selamat datang di deebee)
import 'package:deebee_user/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget banner1() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 5),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: AppColors.primaryHoney.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      // mainAxisAlignment: MainAxisAlignment.end,
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Image.asset("assets/images/logodb-transparan.png", height: 80),
        ),
        Expanded(
          child: Text(
            "Selamat datang di DeeBee!",
            style: TextStyle(
              color: AppColors.borderBrown,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Image.asset(
            "assets/images/logodb2-transparan.png",
            height: 80,
          ),
        ),
      ],
    ),
  );
}

//banner 2 (meet the owner)
Widget banner2() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 5),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Meet\n✨The Owner✨",
                style: TextStyle(
                  color: AppColors.primaryHoney,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "Adi & Bian",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(child: Image.asset("assets/images/banners/banner2.png")),
      ],
    ),
  );
}

//banner 3 (ketemu bug?)
Widget banner3() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 5),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: AppColors.primaryHoney.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Ketemu bug atau punya saran?\nSampaikan disini",
                style: TextStyle(
                  color: AppColors.borderBrown,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryHoney,
                ),
                onPressed: () async {
                  final Uri url = Uri.parse(
                    'https://docs.google.com/forms/d/e/1FAIpQLSd7dQMkufeVxIkxeFmj_bK6Pz7wGx2lKJ-yDIztApQfYPXqeg/viewform?usp=sharing&ouid=101347985935852050031',
                  );

                  if (!await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw Exception('Could not launch $url');
                  }
                },
                child: Text("Klik disini"),
              ),
            ],
          ),
        ),
        Expanded(
          child: Image.asset(
            "assets/images/logodb-transparan.png",
            height: 120,
            width: 120,
          ),
        ),
      ],
    ),
  );
}
