import 'package:json_annotation/json_annotation.dart';

part 'level_model_firebase.g.dart';

@JsonSerializable()
class LevelModelFirebase {
  @JsonKey(defaultValue: '')
  final String id;

  @JsonKey(defaultValue: 0)
  final int order;

  @JsonKey(defaultValue: '')
  final String levelType;

  @JsonKey(defaultValue: null)
  final String? note;

  @JsonKey(defaultValue: '')
  final String chapterId;

  LevelModelFirebase({
    required this.id,
    required this.order,
    required this.levelType,
    this.note,
    required this.chapterId,
  });

  factory LevelModelFirebase.fromJson(Map<String, dynamic> json) =>
      _$LevelModelFirebaseFromJson(json);

  factory LevelModelFirebase.fromMap(Map<String, dynamic> map) =>
      LevelModelFirebase.fromJson(map);

  Map<String, dynamic> toJson() => _$LevelModelFirebaseToJson(this);

  Map<String, dynamic> toMap() => toJson();
}
