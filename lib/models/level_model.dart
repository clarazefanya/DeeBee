class LevelModel {
  final int? id;
  final String levelType;
  final String? note;
  final int chapterId;

  LevelModel({
    this.id,
    required this.levelType,
    this.note,
    required this.chapterId,
  });

  factory LevelModel.fromMap(Map<String, dynamic> map) {
    return LevelModel(
      id: map['id'],
      levelType: map['level_type'],
      note: map['note'],
      chapterId: map['chapter_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level_type': levelType,
      'note': note,
      'chapter_id': chapterId,
    };
  }
}
