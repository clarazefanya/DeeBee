// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_model_firebase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LevelModelFirebase _$LevelModelFirebaseFromJson(Map<String, dynamic> json) =>
    LevelModelFirebase(
      id: json['id'] as String? ?? '',
      levelType: json['levelType'] as String? ?? '',
      note: json['note'] as String?,
      chapterId: json['chapterId'] as String? ?? '',
    );

Map<String, dynamic> _$LevelModelFirebaseToJson(LevelModelFirebase instance) =>
    <String, dynamic>{
      'id': instance.id,
      'levelType': instance.levelType,
      'note': instance.note,
      'chapterId': instance.chapterId,
    };
