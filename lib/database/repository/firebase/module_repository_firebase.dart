import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deebee_user/database/repository/firebase/chapter_repository_firebase.dart';
import 'package:deebee_user/database/repository/firebase/level_repository_firebase.dart';
import 'package:deebee_user/database/repository/firebase/scene_repository_firebase.dart';
import 'package:deebee_user/models/module_model_firebase.dart';

class ModuleRepositoryFirebase {
  final _collection = FirebaseFirestore.instance.collection('modules');

  // untuk delete
  final _chapterRepo = ChapterRepositoryFirebase();
  final _levelRepo = LevelRepositoryFirebase();
  final _sceneRepo = SceneRepositoryFirebase();

  // READ (Published, future)
  Future<List<ModuleModelFirebase>> getPublishedModules() async {
    final snapshot = await _collection
        .where('isPublished', isEqualTo: true)
        .orderBy('order')
        .get();

    return snapshot.docs
        .map((e) => ModuleModelFirebase.fromMap(e.data()))
        .toList();
  }

  // READ (Published, stream)
  Stream<List<ModuleModelFirebase>> streamPublishedModules() {
    return _collection
        .where('isPublished', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((e) => ModuleModelFirebase.fromMap(e.data()))
              .toList(),
        );
  }

  // READ (Admin)
  Stream<List<ModuleModelFirebase>> streamAllModules() {
    return _collection
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((e) => ModuleModelFirebase.fromMap(e.data()))
              .toList(),
        );
  }

  // READ module by id
  Future<ModuleModelFirebase?> getModuleById(String moduleId) async {
    final doc = await _collection.doc(moduleId).get();
    if (!doc.exists) return null;
    return ModuleModelFirebase.fromMap(doc.data()!);
  }

  // CREATE
  Future<void> createModule({
    required String moduleName,
    required String description,
  }) async {
    final id = _collection.doc().id;

    final snapshot = await _collection.get();
    final nextOrder = snapshot.size;

    final module = ModuleModelFirebase(
      id: id,
      moduleName: moduleName,
      description: description,
      isPublished: false,
      order: nextOrder,
    );
    await _collection.doc(id).set(module.toMap());
  }

  // UPDATE
  Future<void> updateModule({
    required String moduleId,
    required String moduleName,
    required String description,
  }) async {
    await _collection.doc(moduleId).update({
      'moduleName': moduleName,
      'description': description,
    });
  }

  // DELETE
  Future<void> deleteModule(String moduleId) async {
    await _collection.doc(moduleId).delete();
  }

  // DELETE ON CASCADE MODULE
  Future<void> deleteModuleCascade(String moduleId) async {
    final chapters = await _chapterRepo.streamChapterByModule(moduleId).first;

    for (final chapter in chapters) {
      final levels = await _levelRepo.getLevelsByChapter(chapter.id);

      for (final level in levels) {
        final scenes = await _sceneRepo.getScenesByLevel(level.id);

        for (final scene in scenes) {
          await _sceneRepo.deleteScene(scene.id);
        }

        await _levelRepo.deleteLevel(level.id);
      }

      await _chapterRepo.deleteChapter(chapter.id);
    }

    await deleteModule(moduleId);
  }

  // Publish / Unpublish
  Future<void> updatePublishStatus({
    required String moduleId,
    required bool isPublished,
  }) async {
    await _collection.doc(moduleId).update({'isPublished': isPublished});
  }
}
