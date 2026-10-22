import 'package:deebee_user/database/repository/firebase/scene_repository_firebase.dart';
import 'package:deebee_user/database/repository/firebase/user_repository_firebase.dart';
import 'package:deebee_user/database/repository/firebase/user_scene_progress_repository_firebase.dart';
import 'package:deebee_user/models/scene_model_firebase.dart';
import 'package:deebee_user/models/user_scene_progress_model_firebase.dart';

class GameplayProgressService {
  final UserRepositoryFirebase userRepository;
  final UserSceneProgressRepositoryFirebase progressRepository;
  final SceneRepositoryFirebase sceneRepository;

  GameplayProgressService({
    required this.userRepository,
    required this.progressRepository,
    required this.sceneRepository,
  });

  Future<void> completeScene({
    required String userUid,
    required SceneModelFirebase scene,
  }) async {
    print('=== COMPLETE SCENE START ===');
    print('userUid: $userUid');
    print('sceneId: ${scene.id}');
    print('rewardXp: ${scene.rewardXp}');

    // Data user sebelum update
    final beforeUser = await userRepository.getUserByUid(userUid);
    print('USER BEFORE:');
    print('xp = ${beforeUser?.xp}');
    print('lastSceneId = ${beforeUser?.lastSceneId}');
    print('lastLevelId = ${beforeUser?.lastLevelId}');

    // cek scene apakah sudah pernah selesai
    final existing = await progressRepository.getProgressByUserAndScene(
      userUid,
      scene.id,
    );
    if (existing != null) {
      print('Scene sudah pernah diselesaikan, skip.');
      print('=== COMPLETE SCENE END ===');
      return;
    }

    // buat model dan insert progress
    final progress = UserSceneProgressModelFirebase(
      id: '',
      userId: userUid,
      sceneId: scene.id,
      isCompleted: true,
      earnedXp: scene.rewardXp,
      completedAt: DateTime.now(),
    );
    await progressRepository.createProgress(progress);
    print('Progress berhasil disimpan.');

    // tambah xp
    await userRepository.addXp(userUid, scene.rewardXp);
    print('XP berhasil ditambah.');

    // update lastSceneId
    await userRepository.updateLastSceneId(userUid, scene.id);
    print('last_scene_id berhasil diupdate.');

    // == UPDATE LAST LEVEL (lastLevelId) ==
    // 1. Ambil semua scene dalam level
    final scenesInLevel = await sceneRepository.getScenesByLevel(scene.levelId);
    // 2. cari scene terakhir
    if (scenesInLevel.isNotEmpty) {
      final lastScene = scenesInLevel.last;
      // 3. Jika scene sekarang adalah scene terakhir level, update last level
      if (scene.id == lastScene.id) {
        await userRepository.updateLastLevelId(userUid, scene.levelId);
        print('last_level_id berhasil diupdate.');
      }
    }
    // Data user sesudah update
    final afterUser = await userRepository.getUserByUid(userUid);
    print('USER AFTER:');
    print('xp = ${afterUser?.xp}');
    print('lastSceneId = ${afterUser?.lastSceneId}');
    print('lastLevelId = ${afterUser?.lastLevelId}');
    print('=== COMPLETE SCENE END ===');
  }
}

//helper utk dipanggil oleh tombol Lanjut/Jawab di scene
Future<void> saveSceneProgress({
  required String userUid,
  required SceneModelFirebase scene,
  bool isIntro = false,
}) async {
  //jika isIntro true, jgn simpan progress
  if (isIntro) return;

  //jika isIntro false, simpan progress
  final gameplayProgressService = GameplayProgressService(
    userRepository: UserRepositoryFirebase(),
    progressRepository: UserSceneProgressRepositoryFirebase(),
    sceneRepository: SceneRepositoryFirebase(),
  );

  await gameplayProgressService.completeScene(userUid: userUid, scene: scene);
}
