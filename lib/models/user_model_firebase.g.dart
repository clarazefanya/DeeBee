// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model_firebase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModelFirebase _$UserModelFirebaseFromJson(Map<String, dynamic> json) =>
    UserModelFirebase(
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatarIndex: (json['avatarIndex'] as num?)?.toInt() ?? 0,
      role: json['role'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      createdAt: dateTimeFromJson(json['createdAt']),
      lastLevelId: json['lastLevelId'] as String?,
      lastSceneId: json['lastSceneId'] as String?,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$UserModelFirebaseToJson(UserModelFirebase instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'avatarIndex': instance.avatarIndex,
      'role': instance.role,
      'isActive': instance.isActive,
      'createdAt': dateTimeToJson(instance.createdAt),
      'lastLevelId': instance.lastLevelId,
      'lastSceneId': instance.lastSceneId,
      'xp': instance.xp,
    };
