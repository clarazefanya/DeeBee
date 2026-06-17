import 'package:deebee_user/database/repository/scene_repository.dart';
import 'package:deebee_user/database/repository/user_repository.dart';
import 'package:deebee_user/database/repository/user_scene_progress_repository.dart';
import 'package:deebee_user/models/scene_model.dart';
import 'package:deebee_user/models/user_scene_progress_model.dart';

class ProgressService {
  final UserRepository userRepository;
  final UserSceneProgressRepository progressRepository;
  final SceneRepository sceneRepository;

  ProgressService({
    required this.userRepository,
    required this.progressRepository,
    required this.sceneRepository,
  });

  Future<void> completeScene({
    required int userId,
    required SceneModel scene,
  }) async {
    print('=== COMPLETE SCENE START ===');
    print('userId: $userId');
    print('sceneId: ${scene.id}');
    print('rewardXp: ${scene.rewardXp}');

    // Data user sebelum update
    final beforeUser = await userRepository.getUserById(userId);
    print('USER BEFORE:');
    print('xp = ${beforeUser?.xp}');
    print('lastSceneId = ${beforeUser?.lastSceneId}');
    print('lastLevelId = ${beforeUser?.lastLevelId}');

    // cek scene apakah sudah pernah selesai
    final existing = await progressRepository.getProgressByUserAndScene(
      userId,
      scene.id!,
    );
    if (existing != null) {
      print('Scene sudah pernah diselesaikan, skip.');
      print('=== COMPLETE SCENE END ===');
      return;
    }

    // buat model dan insert progress
    final progress = UserSceneProgressModel(
      userId: userId,
      sceneId: scene.id!,
      isCompleted: true,
      earnedXp: scene.rewardXp,
      completedAt: DateTime.now().toIso8601String(),
    );

    await progressRepository.createProgress(progress);
    print('Progress berhasil disimpan.');

    // tambah xp
    await userRepository.addXp(userId, scene.rewardXp);
    print('XP berhasil ditambah.');

    // update last scene (last_scene_id)
    await userRepository.updateLastSceneId(userId, scene.id!);
    print('last_scene_id berhasil diupdate.');

    // == UPDATE LAST LEVEL (last_level_id) ==
    // 1. Ambil semua scene dalam level
    final scenesInLevel = await sceneRepository.getScenesByLevel(scene.levelId);
    // 2. cari scene terakhir
    final lastScene = scenesInLevel.last;
    // 3. Jika scene sekarang adalah scene terakhir level, update last level
    if (scene.id == lastScene.id) {
      await userRepository.updateLastLevelId(userId, scene.levelId);
      print('last_level_id berhasil diupdate.');
    }
    // Data user sesudah update
    final afterUser = await userRepository.getUserById(userId);
    print('USER AFTER:');
    print('xp = ${afterUser?.xp}');
    print('lastSceneId = ${afterUser?.lastSceneId}');
    print('lastLevelId = ${afterUser?.lastLevelId}');
    print('=== COMPLETE SCENE END ===');
  }
}

//helper utk dipanggil oleh tombol Lanjut/Jawab di scene
Future<void> saveSceneProgress({
  required int userId,
  required SceneModel scene,
  bool isIntro = false,
}) async {
  //jika isIntro true, jgn simpan progress
  if (isIntro) return;

  //jika isIntro false, simpan progress
  final progressService = ProgressService(
    userRepository: UserRepository(),
    progressRepository: UserSceneProgressRepository(),
    sceneRepository: SceneRepository(),
  );

  await progressService.completeScene(userId: userId, scene: scene);
}
