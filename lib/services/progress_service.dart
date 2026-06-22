import 'package:deebee_user/database/repository/chapter_repository.dart';
import 'package:deebee_user/database/repository/level_repository.dart';
import 'package:deebee_user/database/repository/module_repository.dart';
import 'package:deebee_user/database/repository/scene_repository.dart';
import 'package:deebee_user/database/repository/user_repository.dart';
import 'package:deebee_user/database/repository/user_scene_progress_repository.dart';
import 'package:deebee_user/models/enums/progress_status.dart';

class ProgressService {
  final ModuleRepository _moduleRepo = ModuleRepository();
  final ChapterRepository _chapterRepo = ChapterRepository();
  final LevelRepository _levelRepo = LevelRepository();
  final SceneRepository _sceneRepo = SceneRepository();
  final UserSceneProgressRepository _progressRepo =
      UserSceneProgressRepository();
  final UserRepository _userRepo = UserRepository();

  /// cek apakah suatu level sdh complete
  Future<bool> isLevelCompleted(int userId, int levelId) async {
    final scenes = await _sceneRepo.getScenesByLevel(levelId);

    if (scenes.isEmpty) {
      return false;
    }

    for (final scene in scenes) {
      final completed = await _progressRepo.isSceneCompleted(userId, scene.id!);

      if (!completed) {
        return false;
      }
    }

    return true;
  }

  /// helper cek role admin
  /// jika admin = semua status modul, chapter, level jadi inprogress tdk ada yg locked
  Future<bool> isAdmin(int userId) async {
    final user = await _userRepo.getUserById(userId);

    return user?.role.toLowerCase() == 'admin';
  }

  /// dapatkan status level
  Future<ProgressStatus> getLevelStatus(int userId, int levelId) async {
    final currentLevel = await _levelRepo.getLevelById(levelId);

    if (currentLevel == null) {
      return ProgressStatus.locked;
    }

    // kalau level ini sudah selesai
    if (await isLevelCompleted(userId, levelId)) {
      return ProgressStatus.completed;
    }

    // admin boleh akses semua level
    if (await isAdmin(userId)) {
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
      userId,
      previousGameplay.id!,
    );

    if (previousCompleted) {
      return ProgressStatus.inProgress;
    }

    return ProgressStatus.locked;
  }

  /// dapatkan nilai progress bar chapter
  Future<double> getChapterProgress(int userId, int chapterId) async {
    final allLevels = await _levelRepo.getLevelsByChapter(chapterId);

    final gameplayLevels = allLevels
        .where((e) => e.levelType == 'gameplay')
        .toList();

    if (gameplayLevels.isEmpty) {
      return 0;
    }

    int completedCount = 0;

    for (final level in gameplayLevels) {
      final completed = await isLevelCompleted(userId, level.id!);

      if (completed) {
        completedCount++;
      }
    }

    return completedCount / gameplayLevels.length;
  }

  /// dapatkan status chapter
  Future<ProgressStatus> getChapterStatus(int userId, int chapterId) async {
    final currentChapter = await _chapterRepo.getChapterById(chapterId);

    if (currentChapter == null) {
      return ProgressStatus.locked;
    }

    final progress = await getChapterProgress(userId, chapterId);

    // chapter selesai
    if (progress >= 1.0) {
      return ProgressStatus.completed;
    }

    // admin bisa akses semua chapter
    if (await isAdmin(userId)) {
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
      userId,
      previousChapter.id!,
    );

    if (previousProgress >= 1.0) {
      return ProgressStatus.inProgress;
    }

    return ProgressStatus.locked;
  }

  /// dapatkan nilai progress bar modul
  Future<double> getModuleProgress(int userId, int moduleId) async {
    final chapters = await _chapterRepo.getChaptersByModule(moduleId);

    if (chapters.isEmpty) {
      return 0;
    }

    int completedCount = 0;

    for (final chapter in chapters) {
      final progress = await getChapterProgress(userId, chapter.id!);

      if (progress >= 1.0) {
        completedCount++;
      }
    }

    return completedCount / chapters.length;
  }

  /// dapatkan status modul
  Future<ProgressStatus> getModuleStatus(int userId, int moduleId) async {
    final currentModule = await _moduleRepo.getModuleById(moduleId);

    if (currentModule == null) {
      return ProgressStatus.locked;
    }

    final progress = await getModuleProgress(userId, moduleId);

    // module selesai
    if (progress >= 1.0) {
      return ProgressStatus.completed;
    }

    // admin bisa akses semua module
    if (await isAdmin(userId)) {
      return ProgressStatus.inProgress;
    }

    final modules = await _moduleRepo.getModules();

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
      userId,
      previousModule.id!,
    );

    if (previousProgress >= 1.0) {
      return ProgressStatus.inProgress;
    }

    return ProgressStatus.locked;
  }

  /// dapatkan nilai progress bar keseluruhan
  Future<double> getOverallProgress(int userId) async {
    final modules = await _moduleRepo.getModules();

    if (modules.isEmpty) {
      return 0;
    }

    int completedCount = 0;

    for (final module in modules) {
      final progress = await getModuleProgress(userId, module.id!);

      if (progress >= 1.0) {
        completedCount++;
      }
    }

    return completedCount / modules.length;
  }
}
