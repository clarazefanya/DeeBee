import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:flutter/material.dart';

class Gameplay extends StatefulWidget {
  const Gameplay({super.key});

  @override
  State<Gameplay> createState() => _GameplayState();
}

class _GameplayState extends State<Gameplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DeebeeAppbar(leading: IconAppbarGameplay()),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //row level dan reward XP
            Row(
              children: [
                //text level
                Text(
                  "Level 1",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                //capsule reward XP
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  margin: EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryCream,
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(color: AppColors.borderLightBrown),
                  ),
                  child: Text(
                    "Reward: 20 XP",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            //area ilustrasi (stack bg dan char)
            Stack(children: []),

            //area dialog

            //area soal/intraction
          ],
        ),
      ),
    );
  }
}
