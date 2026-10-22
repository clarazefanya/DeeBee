// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_model_firebase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChapterModelFirebase _$ChapterModelFirebaseFromJson(
  Map<String, dynamic> json,
) => ChapterModelFirebase(
  id: json['id'] as String? ?? '',
  order: (json['order'] as num?)?.toInt() ?? 0,
  chapterTitle: json['chapterTitle'] as String? ?? '',
  shortDesc: json['shortDesc'] as String? ?? '',
  longDesc: json['longDesc'] as String? ?? '',
  moduleId: json['moduleId'] as String? ?? '',
);

Map<String, dynamic> _$ChapterModelFirebaseToJson(
  ChapterModelFirebase instance,
) => <String, dynamic>{
  'id': instance.id,
  'order': instance.order,
  'chapterTitle': instance.chapterTitle,
  'shortDesc': instance.shortDesc,
  'longDesc': instance.longDesc,
  'moduleId': instance.moduleId,
};
