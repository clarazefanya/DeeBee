class ChapterModel {
  final int? id;
  final String chapterTitle;
  final String shortDesc;
  final String longDesc;
  final int moduleId;

  ChapterModel({
    this.id,
    required this.chapterTitle,
    required this.shortDesc,
    required this.longDesc,
    required this.moduleId,
  });

  factory ChapterModel.fromMap(Map<String, dynamic> map) {
    return ChapterModel(
      id: map['id'],
      chapterTitle: map['chapter_title'],
      shortDesc: map['short_desc'],
      longDesc: map['long_desc'],
      moduleId: map['module_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chapter_title': chapterTitle,
      'short_desc': shortDesc,
      'long_desc': longDesc,
      'module_id': moduleId,
    };
  }
}
