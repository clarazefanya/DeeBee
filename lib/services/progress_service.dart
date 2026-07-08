import 'package:deebee_user/database/repository/firebase/chapter_repository_firebase.dart';
import 'package:deebee_user/database/repository/firebase/level_repository_firebase.dart';
import 'package:deebee_user/database/repository/firebase/module_repository_firebase.dart';
import 'package:deebee_user/database/repository/firebase/scene_repository_firebase.dart';
import 'package:deebee_user/database/repository/firebase/user_repository_firebase.dart';
import 'package:deebee_user/database/repository/firebase/user_scene_progress_repository_firebase.dart';
import 'package:deebee_user/models/enums/progress_status.dart';

class ProgressService {
  final ModuleRepositoryFirebase _moduleRepo = ModuleRepositoryFirebase();
  final ChapterRepositoryFirebase _chapterRepo = ChapterRepositoryFirebase();
  final LevelRepositoryFirebase _levelRepo = LevelRepositoryFirebase();
  final SceneRepositoryFirebase _sceneRepo = SceneRepositoryFirebase();
  final UserSceneProgressRepositoryFirebase _progressRepo =
      UserSceneProgressRepositoryFirebase();
  final UserRepositoryFirebase _userRepo = UserRepositoryFirebase();

  /// cek apakah suatu level sdh complete
  Future<bool> isLevelCompleted(String userUid, String levelId) async {
    final scenes = await _sceneRepo.getScenesByLevel(levelId);

    if (scenes.isEmpty) {
      return false;
    }

    for (final scene in scenes) {
      final completed = await _progressRepo.isSceneCompleted(userUid, scene.id);

      if (!completed) {
        return false;
      }
    }

    return true;
  }

  /// helper cek role admin
  /// jika admin = semua status modul, chapter, level jadi inprogress tdk ada yg locked
  Future<bool> isAdmin(String userUid) async {
    final user = await _userRepo.getUserByUid(userUid);

    return user?.role.toLowerCase() == 'admin';
  }

  /// dapatkan status level
  Future<ProgressStatus> getLevelStatus(String userUid, String levelId) async {
    final currentLevel = await _levelRepo.getLevelById(levelId);

    if (currentLevel == null) {
      return ProgressStatus.locked;
    }

    // kalau level ini sudah selesai
    if (await isLevelCompleted(userUid, levelId)) {
      return ProgressStatus.completed;
    }

    // admin boleh akses semua level
    if (await isAdmin(userUid)) {
      return ProgressStatus.inProgress;
    }

    // intro selalu terbuka
    if (currentLevel.levelType == 'intro') {
      return ProgressStatus.inProgress;
    }

    final allLevels = await _levelRepo.getLevelsByChapter(
      currentLevel.chapterId,
    );

    final gameplayLevels = allLevels
        .where((e) => e.levelType == 'gameplay')
        .toList();

    final gameplayIndex = gameplayLevels.indexWhere((e) => e.id == levelId);

    if (gameplayIndex == -1) {
      return ProgressStatus.locked;
    }

    // gameplay pertama selalu terbuka
    if (gameplayIndex == 0) {
      return ProgressStatus.inProgress;
    }

    final previousGameplay = gameplayLevels[gameplayIndex - 1];

    final previousCompleted = await isLevelCompleted(
      userUid,
      previousGameplay.id,
    );

    if (previousCompleted) {
      return ProgressStatus.inProgress;
    }

    return ProgressStatus.locked;
  }

  /// dapatkan nilai progress bar chapter
  Future<double> getChapterProgress(String userUid, String chapterId) async {
    final allLevels = await _levelRepo.getLevelsByChapter(chapterId);

    final gameplayLevels = allLevels
        .where((e) => e.levelType == 'gameplay')
        .toList();

    if (gameplayLevels.isEmpty) {
      return 0;
    }

    int completedCount = 0;

    for (final level in gameplayLevels) {
      final completed = await isLevelCompleted(userUid, level.id);

      if (completed) {
        completedCount++;
      }
    }

    return completedCount / gameplayLevels.length;
  }

  /// dapatkan status chapter
  Future<ProgressStatus> getChapterStatus(
    String userUid,
    String chapterId,
  ) async {
    final currentChapter = await _chapterRepo.getChapterById(chapterId);

    if (currentChapter == null) {
      return ProgressStatus.locked;
    }

    final progress = await getChapterProgress(userUid, chapterId);

    // chapter selesai
    if (progress >= 1.0) {
      return ProgressStatus.completed;
    }

    // admin bisa akses semua chapter
    if (await isAdmin(userUid)) {
      return ProgressStatus.inProgress;
    }

    final chapters = await _chapterRepo.getChaptersByModule(
      currentChapter.moduleId,
    );

    final chapterIndex = chapters.indexWhere((e) => e.id == chapterId);

    if (chapterIndex == -1) {
      return ProgressStatus.locked;
    }

    // chapter pertama selalu terbuka
    if (chapterIndex == 0) {
      return ProgressStatus.inProgress;
    }

    final previousChapter = chapters[chapterIndex - 1];

    final previousProgress = await getChapterProgress(
      userUid,
      previousChapter.id,
    );

    if (previousProgress >= 1.0) {
      return ProgressStatus.inProgress;
    }

    return ProgressStatus.locked;
  }

  /// dapatkan nilai progress bar modul
  Future<double> getModuleProgress(String userUid, String moduleId) async {
    final chapters = await _chapterRepo.getChaptersByModule(moduleId);

    if (chapters.isEmpty) {
      return 0;
    }

    int completedCount = 0;

    for (final chapter in chapters) {
      final progress = await getChapterProgress(userUid, chapter.id);

      if (progress >= 1.0) {
        completedCount++;
      }
    }

    return completedCount / chapters.length;
  }

  /// dapatkan status modul
  Future<ProgressStatus> getModuleStatus(
    String userUid,
    String moduleId,
  ) async {
    final currentModule = await _moduleRepo.getModuleById(moduleId);

    if (currentModule == null) {
      return ProgressStatus.locked;
    }

    final progress = await getModuleProgress(userUid, moduleId);

    // module selesai
    if (progress >= 1.0) {
      return ProgressStatus.completed;
    }

    // admin bisa akses semua module
    if (await isAdmin(userUid)) {
      return ProgressStatus.inProgress;
    }

    final modules = await _moduleRepo.getPublishedModules();

    final moduleIndex = modules.indexWhere((e) => e.id == moduleId);

    if (moduleIndex == -1) {
      return ProgressStatus.locked;
    }

    // module pertama selalu terbuka
    if (moduleIndex == 0) {
      return ProgressStatus.inProgress;
    }

    final previousModule = modules[moduleIndex - 1];

    final previousProgress = await getModuleProgress(
      userUid,
      previousModule.id,
    );

    if (previousProgress >= 1.0) {
      return ProgressStatus.inProgress;
    }

    return ProgressStatus.locked;
  }

  /// dapatkan nilai progress bar keseluruhan
  Future<double> getOverallProgress(String userUid) async {
    final modules = await _moduleRepo.getPublishedModules();

    if (modules.isEmpty) {
      return 0;
    }

    int completedCount = 0;

    for (final module in modules) {
      final progress = await getModuleProgress(userUid, module.id);

      if (progress >= 1.0) {
        completedCount++;
      }
    }

    return completedCount / modules.length;
  }
}
