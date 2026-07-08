import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deebee_user/database/repository/firebase/level_repository_firebase.dart';
import 'package:deebee_user/database/repository/firebase/scene_repository_firebase.dart';
import 'package:deebee_user/models/chapter_model_firebase.dart';
import 'package:deebee_user/models/enums/type_enum_model.dart';

class ChapterRepositoryFirebase {
  final _chapterRef = FirebaseFirestore.instance.collection('chapters');

  // utk delete on cascade
  final _levelRepo = LevelRepositoryFirebase();
  final _sceneRepo = SceneRepositoryFirebase();

  // READ (Future)
  Future<List<ChapterModelFirebase>> getChaptersByModule(
    String moduleId,
  ) async {
    final snapshot = await _chapterRef
        .where('moduleId', isEqualTo: moduleId)
        .orderBy('order')
        .get();

    return snapshot.docs
        .map((doc) => ChapterModelFirebase.fromMap(doc.data()))
        .toList();
  }

  // READ (Stream)
  Stream<List<ChapterModelFirebase>> streamChapterByModule(String moduleId) {
    return _chapterRef
        .where('moduleId', isEqualTo: moduleId)
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChapterModelFirebase.fromMap(doc.data()))
              .toList(),
        );
  }

  // READ ONE
  Future<ChapterModelFirebase?> getChapterById(String chapterId) async {
    final doc = await _chapterRef.doc(chapterId).get();

    if (!doc.exists) return null;

    return ChapterModelFirebase.fromMap(doc.data()!);
  }

  // CREATE
  Future<void> createChapter({
    required String chapterTitle,
    required String shortDesc,
    required String longDesc,
    required String moduleId,
  }) async {
    final id = _chapterRef.doc().id;

    final snapshot = await _chapterRef
        .where('moduleId', isEqualTo: moduleId)
        .get();

    final nextOrder = snapshot.size;

    final chapter = ChapterModelFirebase(
      id: id,
      chapterTitle: chapterTitle,
      shortDesc: shortDesc,
      longDesc: longDesc,
      moduleId: moduleId,
      order: nextOrder,
    );

    // buat chapter
    await _chapterRef.doc(id).set(chapter.toMap());

    // otomatis buat level intro
    await _levelRepo.createLevel(chapterId: id, levelType: LevelType.intro);
  }

  // UPDATE
  Future<void> updateChapter({
    required String chapterId,
    required String chapterTitle,
    required String shortDesc,
    required String longDesc,
  }) async {
    await _chapterRef.doc(chapterId).update({
      'chapterTitle': chapterTitle,
      'shortDesc': shortDesc,
      'longDesc': longDesc,
    });
  }

  // DELETE
  Future<void> deleteChapter(String chapterId) async {
    await _chapterRef.doc(chapterId).delete();
  }

  // DELETE ON CASCADE CHAPTER
  Future<void> deleteChapterCascade(String chapterId) async {
    final levels = await _levelRepo.getLevelsByChapter(chapterId);

    for (final level in levels) {
      final scenes = await _sceneRepo.getScenesByLevel(level.id);

      for (final scene in scenes) {
        await _sceneRepo.deleteScene(scene.id);
      }

      await _levelRepo.deleteLevel(level.id);
    }

    await deleteChapter(chapterId);
  }
}
