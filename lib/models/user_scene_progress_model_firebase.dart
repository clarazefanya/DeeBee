import 'package:deebee_user/utils/firestore_date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_scene_progress_model_firebase.g.dart';

@JsonSerializable()
class UserSceneProgressModelFirebase {
  @JsonKey(defaultValue: '')
  final String id;

  @JsonKey(defaultValue: '')
  final String userId;

  @JsonKey(defaultValue: '')
  final String sceneId;

  @JsonKey(defaultValue: false)
  final bool isCompleted;

  @JsonKey(defaultValue: 0)
  final int earnedXp;

  @JsonKey(
    fromJson: dateTimeFromJson,
    toJson: dateTimeToJson,
    defaultValue: null,
  )
  final DateTime completedAt;

  UserSceneProgressModelFirebase({
    required this.id,
    required this.userId,
    required this.sceneId,
    required this.isCompleted,
    required this.earnedXp,
    required this.completedAt,
  });

  factory UserSceneProgressModelFirebase.fromJson(Map<String, dynamic> json) =>
      _$UserSceneProgressModelFirebaseFromJson(json);

  factory UserSceneProgressModelFirebase.fromMap(Map<String, dynamic> map) =>
      UserSceneProgressModelFirebase.fromJson(map);

  Map<String, dynamic> toJson() => _$UserSceneProgressModelFirebaseToJson(this);

  Map<String, dynamic> toMap() => toJson();
}
