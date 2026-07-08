// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_model_firebase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LevelModelFirebase _$LevelModelFirebaseFromJson(Map<String, dynamic> json) =>
    LevelModelFirebase(
      id: json['id'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      levelType: json['levelType'] as String? ?? '',
      note: json['note'] as String?,
      chapterId: json['chapterId'] as String? ?? '',
    );

Map<String, dynamic> _$LevelModelFirebaseToJson(LevelModelFirebase instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'levelType': instance.levelType,
      'note': instance.note,
      'chapterId': instance.chapterId,
    };
