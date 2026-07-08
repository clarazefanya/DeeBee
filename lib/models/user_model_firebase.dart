import 'package:deebee_user/utils/firestore_date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model_firebase.g.dart';

@JsonSerializable()
class UserModelFirebase {
  @JsonKey(defaultValue: '')
  final String uid;

  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: '')
  final String email;

  @JsonKey(defaultValue: 0)
  final int avatarIndex;

  @JsonKey(defaultValue: '')
  final String role;

  @JsonKey(defaultValue: true)
  final bool isActive;

  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime createdAt;

  @JsonKey(defaultValue: null)
  final String? lastLevelId;

  @JsonKey(defaultValue: null)
  final String? lastSceneId;

  @JsonKey(defaultValue: 0)
  final int xp;

  UserModelFirebase({
    required this.uid,
    required this.name,
    required this.email,
    required this.avatarIndex,
    required this.role,
    required this.isActive,
    required this.createdAt,
    this.lastLevelId,
    this.lastSceneId,
    required this.xp,
  });

  factory UserModelFirebase.fromJson(Map<String, dynamic> json) =>
      _$UserModelFirebaseFromJson(json);

  factory UserModelFirebase.fromMap(Map<String, dynamic> map) =>
      UserModelFirebase.fromJson(map);

  Map<String, dynamic> toJson() => _$UserModelFirebaseToJson(this);

  Map<String, dynamic> toMap() => toJson();
}
