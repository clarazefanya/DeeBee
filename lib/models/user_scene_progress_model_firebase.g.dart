// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_scene_progress_model_firebase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSceneProgressModelFirebase _$UserSceneProgressModelFirebaseFromJson(
  Map<String, dynamic> json,
) => UserSceneProgressModelFirebase(
  id: json['id'] as String? ?? '',
  userId: json['userId'] as String? ?? '',
  sceneId: json['sceneId'] as String? ?? '',
  isCompleted: json['isCompleted'] as bool? ?? false,
  earnedXp: (json['earnedXp'] as num?)?.toInt() ?? 0,
  completedAt: dateTimeFromJson(json['completedAt']),
);

Map<String, dynamic> _$UserSceneProgressModelFirebaseToJson(
  UserSceneProgressModelFirebase instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'sceneId': instance.sceneId,
  'isCompleted': instance.isCompleted,
  'earnedXp': instance.earnedXp,
  'completedAt': dateTimeToJson(instance.completedAt),
};
