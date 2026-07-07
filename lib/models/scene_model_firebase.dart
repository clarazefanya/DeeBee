import 'package:json_annotation/json_annotation.dart';

part 'scene_model_firebase.g.dart';

@JsonSerializable()
class SceneModelFirebase {
  @JsonKey(defaultValue: '')
  final String id;

  @JsonKey(defaultValue: '')
  final String levelId;

  @JsonKey(defaultValue: null)
  final String? bgImageId;

  @JsonKey(defaultValue: null)
  final String? charImageId;

  @JsonKey(defaultValue: null)
  final String? charName;

  @JsonKey(defaultValue: null)
  final String? charDialog;

  @JsonKey(defaultValue: '')
  final String sceneType;

  @JsonKey(defaultValue: null)
  final String? optionalSentence;

  @JsonKey(defaultValue: null)
  final String? question;

  @JsonKey(defaultValue: null)
  final String? optionA;

  @JsonKey(defaultValue: null)
  final String? optionB;

  @JsonKey(defaultValue: null)
  final String? optionC;

  @JsonKey(defaultValue: null)
  final String? answerKeyMultipleChoice;

  @JsonKey(defaultValue: null)
  final String? answerKey;

  @JsonKey(defaultValue: 0)
  final int rewardXp;

  SceneModelFirebase({
    required this.id,
    required this.levelId,
    this.bgImageId,
    this.charImageId,
    this.charName,
    this.charDialog,
    required this.sceneType,
    this.optionalSentence,
    this.question,
    this.optionA,
    this.optionB,
    this.optionC,
    this.answerKeyMultipleChoice,
    this.answerKey,
    required this.rewardXp,
  });

  factory SceneModelFirebase.fromJson(Map<String, dynamic> json) =>
      _$SceneModelFirebaseFromJson(json);

  factory SceneModelFirebase.fromMap(Map<String, dynamic> map) =>
      SceneModelFirebase.fromJson(map);

  Map<String, dynamic> toJson() => _$SceneModelFirebaseToJson(this);

  Map<String, dynamic> toMap() => toJson();
}
