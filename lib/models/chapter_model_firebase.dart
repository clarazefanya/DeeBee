import 'package:json_annotation/json_annotation.dart';

part 'chapter_model_firebase.g.dart';

@JsonSerializable()
class ChapterModelFirebase {
  @JsonKey(defaultValue: '')
  final String id;

  @JsonKey(defaultValue: '')
  final String chapterTitle;

  @JsonKey(defaultValue: '')
  final String shortDesc;

  @JsonKey(defaultValue: '')
  final String longDesc;

  @JsonKey(defaultValue: '')
  final String moduleId;

  ChapterModelFirebase({
    required this.id,
    required this.chapterTitle,
    required this.shortDesc,
    required this.longDesc,
    required this.moduleId,
  });

  factory ChapterModelFirebase.fromJson(Map<String, dynamic> json) =>
      _$ChapterModelFirebaseFromJson(json);

  factory ChapterModelFirebase.fromMap(Map<String, dynamic> map) =>
      ChapterModelFirebase.fromJson(map);

  Map<String, dynamic> toJson() => _$ChapterModelFirebaseToJson(this);

  Map<String, dynamic> toMap() => toJson();
}
