import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/models/dummy_models.dart';
import 'package:deebee_user/views/Gameplay/dialog_interaction.dart';
import 'package:deebee_user/views/Gameplay/multiple_choice_interaction.dart';
import 'package:deebee_user/views/Gameplay/sql_input_interaction.dart';
import 'package:deebee_user/views/Gameplay/word_arrangement_interaction.dart';
import 'package:flutter/material.dart';

class Gameplay extends StatefulWidget {
  const Gameplay({super.key, required this.gameplayType});

  final GameplayType gameplayType;

  @override
  State<Gameplay> createState() => _GameplayState();
}

class _GameplayState extends State<Gameplay> {
  //test var gameplaytype
  GameplayType? gameplayType;

  @override
  void initState() {
    super.initState();
    gameplayType = widget.gameplayType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DeebeeAppbar(leading: IconAppbarGameplay()),
      body: gameplayType == GameplayType.sqlInput
          ? _buildSqlLayout()
          : _buildNormalLayout(),
    );
  }

  ///build normal layout
  Widget _buildNormalLayout() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          //row level, current scene, reward XP
          RowLevel(),
          SizedBox(height: 16),

          //area ilustrasi (stack background dan char)
          IllustrationSection(),
          SizedBox(height: 10),

          //area dialog
          DialogSection(),
          SizedBox(height: 10),

          //area soal/interaction conditional
          Expanded(child: _interactionArea()),
        ],
      ),
    );
  }

  ///build SQL layout
  Widget _buildSqlLayout() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              //row level, current scene, reward XP
              RowLevel(),
              SizedBox(height: 16),

              //area ilustrasi (stack background dan char)
              IllustrationSection(),
              SizedBox(height: 10),

              //area dialog
              DialogSection(),
              SizedBox(height: 10),

              //area soal/interaction input SQL
              _interactionArea(),
            ],
          ),
        ),
      ),
    );
  }

  ///Area interaksi
  Widget _interactionArea() {
    switch (gameplayType) {
      case GameplayType.dialog:
        return const DialogInteraction();
      case GameplayType.multipleChoice:
        return const MultipleChoiceInteraction();
      case GameplayType.wordArrangement:
        return const WordArrangementInteraction();
      case GameplayType.sqlInput:
        return const SqlInputInteraction();
      default:
        return const SizedBox.shrink();
    }
  }
}
//end of class

/// row level, current scene, reward XP
class RowLevel extends StatelessWidget {
  const RowLevel({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //text level
        Text(
          "Level 1",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.borderBrown,
          ),
        ),
        Spacer(),

        //[current scene]/[jumlah scene]
        Text(
          "1/5",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.borderBrown,
          ),
        ),
        SizedBox(width: 10),

        //capsule reward XP
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryCream,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: AppColors.borderLightBrown),
          ),
          child: Text(
            "Hadiah: 20 XP",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

/// area dialog
class DialogSection extends StatelessWidget {
  const DialogSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primaryHoney),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Adi",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.borderBrown,
            ),
          ),
          SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                "Biasanya orang-orang yang ingin bisa menguasai database mencari pekerjaan yang berkelas di kantoran seperti data analyst, tidak ada yang mau mendaftar ke pekerjaan rendahan seperti pegawai toko ini.",
                style: TextStyle(fontSize: 13, color: AppColors.primaryBlack),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// area ilustrasi (stack background dan char)
class IllustrationSection extends StatelessWidget {
  const IllustrationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      //Membatasi lebar maksimal container
      constraints: const BoxConstraints(maxWidth: 480),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          //container background
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey, //Placeholder warna sebelum gambar load
              border: Border.all(color: AppColors.primaryHoney, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              //cliprrect agar semua komponen di dalamnya terpotong sesuai radius
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/toko-deebee.jpg',
                fit: BoxFit.cover, //gambar menutupi seluruh container
                alignment: Alignment.center,
              ),
            ),
          ),

          //char png
          Positioned(
            bottom: 2,
            child: Image.asset(
              'assets/images/avatars/user-avatars-1.jpg',
              width: 320,
              height: 170,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
