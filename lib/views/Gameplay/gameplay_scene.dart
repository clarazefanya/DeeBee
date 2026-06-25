import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/repository/asset_scene_repository.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/models/asset_scene_model.dart';
import 'package:deebee_user/models/enums/gameplay_enum_model.dart';
import 'package:deebee_user/models/scene_model.dart';
import 'package:deebee_user/views/Gameplay/dialog_interaction.dart';
import 'package:deebee_user/views/Gameplay/multiple_choice_interaction.dart';
import 'package:deebee_user/views/Gameplay/sql_input_interaction.dart';
import 'package:deebee_user/views/Gameplay/word_arrangement_interaction.dart';
import 'package:flutter/material.dart';

class Gameplay extends StatefulWidget {
  const Gameplay({
    super.key,
    required this.namaLevel,
    required this.levelId,
    required this.scenes,
    this.isIntro = false,
  });

  // final GameplayType gameplayType;
  final String namaLevel;
  final int levelId;
  final List<SceneModel> scenes;
  final bool isIntro;

  @override
  State<Gameplay> createState() => _GameplayState();
}

class _GameplayState extends State<Gameplay> {
  // //test var gameplaytype
  // GameplayType? gameplayType;

  // @override
  // void initState() {
  //   super.initState();
  //   gameplayType = widget.gameplayType;
  // }

  // Melacak scene keberapa yang sedang aktif
  int _currentIndex = 0;

  // Mengambil data scene aktif saat ini
  SceneModel get _currentScene => widget.scenes[_currentIndex];

  // Mendapatkan tipe gameplay berdasarkan data di database
  GameplayType get _currentGameplayType =>
      GameplayType.fromString(_currentScene.sceneType);

  // Fungsi untuk berpindah ke scene berikutnya (dipanggil dari widget interaksi nanti)
  void nextScene() {
    if (_currentIndex < widget.scenes.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // Jika scene sudah habis, level selesai!
      _showLevelCompletedDialog();
    }
  }

  void _showLevelCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Halaman Selesai!'),
        content: const Text(
          'Selamat! Kamu telah menyelesaikan seluruh scene di level ini.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop(); // Keluar dialog
              context.pop(true); // Kembali ke LevelSelect
            },
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }

  //untuk refresh halaman biar XP di appbar terupdate
  void refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DeebeeAppbar(leading: IconAppbarGameplay()),
      body: _currentGameplayType == GameplayType.sqlInput
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
          RowLevel(
            namaLevel: widget.namaLevel,
            currentScene: _currentIndex + 1,
            totalScenes: widget.scenes.length,
            rewardXp: _currentScene.rewardXp,
          ),
          SizedBox(height: 16),

          //area ilustrasi (stack background dan char)
          IllustrationSection(
            bgImageId: _currentScene.bgImageId,
            charImageId: _currentScene.charImageId,
          ),
          SizedBox(height: 10),

          //area dialog
          DialogSection(
            charName: _currentScene.charName ?? '-',
            charDialog: _currentScene.charDialog ?? '',
          ),
          SizedBox(height: 10),

          //area soal/interaction conditional
          Expanded(child: _interactionArea()),
        ],
      ),
    );
  }

  ///build SQL layout
  Widget _buildSqlLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //row level, current scene, reward XP
            RowLevel(
              namaLevel: widget.namaLevel,
              currentScene: _currentIndex + 1,
              totalScenes: widget.scenes.length,
              rewardXp: _currentScene.rewardXp,
            ),
            SizedBox(height: 16),

            //area ilustrasi (stack background dan char)
            IllustrationSection(
              bgImageId: _currentScene.bgImageId,
              charImageId: _currentScene.charImageId,
            ),
            SizedBox(height: 10),

            //area dialog
            DialogSection(
              charName: _currentScene.charName ?? '-',
              charDialog: _currentScene.charDialog ?? '',
            ),
            SizedBox(height: 10),

            //area soal/interaction input SQL
            _interactionArea(),
          ],
        ),
      ),
    );
  }

  ///Area interaksi
  Widget _interactionArea() {
    switch (_currentGameplayType) {
      case GameplayType.dialog:
        return DialogInteraction(
          // Melempar data scene yang sedang aktif dari DB
          scene: _currentScene,
          // Melempar fungsi untuk memicu scene berikutnya
          onNext: nextScene,
          // Melempar flag isIntro
          isIntro: widget.isIntro,
        );
      case GameplayType.multipleChoice:
        return MultipleChoiceInteraction(
          scene: _currentScene,
          onNext: nextScene,
          //untuk trigger refresh 1 hlmn gameplay
          onRefresh: refreshPage,
        );
      case GameplayType.wordArrangement:
        return WordArrangementInteraction(
          scene: _currentScene,
          onNext: nextScene,
          onRefresh: refreshPage,
        );
      case GameplayType.sqlInput:
        return SqlInputInteraction(
          scene: _currentScene,
          onNext: nextScene,
          onRefresh: refreshPage,
        );
    }
  }
}
//end of class

/// row level, current scene, reward XP
class RowLevel extends StatelessWidget {
  final String namaLevel;
  final int currentScene;
  final int totalScenes;
  final int rewardXp;

  const RowLevel({
    super.key,
    required this.namaLevel,
    required this.currentScene,
    required this.totalScenes,
    required this.rewardXp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //text level
        Text(
          namaLevel,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.borderBrown,
          ),
        ),
        Spacer(),

        //[current scene]/[jumlah scene]
        Text(
          "$currentScene/$totalScenes",
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
            "Hadiah: $rewardXp XP",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

/// area dialog
class DialogSection extends StatelessWidget {
  final String charName;
  final String charDialog;

  const DialogSection({
    super.key,
    required this.charName,
    required this.charDialog,
  });

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
            charName,
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
                charDialog,
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
  final int? bgImageId;
  final int? charImageId;

  const IllustrationSection({super.key, this.bgImageId, this.charImageId});

  @override
  Widget build(BuildContext context) {
    final assetRepo = AssetSceneRepository();
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
              child: bgImageId == null
                  ? const SizedBox.shrink()
                  : FutureBuilder<AssetSceneModel?>(
                      // Pastikan Anda punya fungsi ambil asset tunggal berdasarkan id di repo asset Anda
                      future: assetRepo.getAssetAssetById(bgImageId!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data?.image != null) {
                          return Image.memory(
                            snapshot.data!.image,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
            ),
          ),

          //char png
          //ender Character PNG dari DB BLOB
          if (charImageId != null)
            Positioned(
              bottom: 2,
              child: FutureBuilder<AssetSceneModel?>(
                future: assetRepo.getAssetAssetById(charImageId!),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data?.image != null) {
                    return Image.memory(
                      snapshot.data!.image,
                      width: 320,
                      height: 170,
                      fit: BoxFit.contain,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
        ],
      ),
    );
  }
}
