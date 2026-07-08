// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_model_firebase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleModelFirebase _$ModuleModelFirebaseFromJson(Map<String, dynamic> json) =>
    ModuleModelFirebase(
      id: json['id'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      moduleName: json['moduleName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isPublished: json['isPublished'] as bool? ?? false,
    );

Map<String, dynamic> _$ModuleModelFirebaseToJson(
  ModuleModelFirebase instance,
) => <String, dynamic>{
  'id': instance.id,
  'order': instance.order,
  'moduleName': instance.moduleName,
  'description': instance.description,
  'isPublished': instance.isPublished,
};
