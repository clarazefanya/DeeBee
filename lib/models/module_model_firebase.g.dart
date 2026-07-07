// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_model_firebase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleModelFirebase _$ModuleModelFirebaseFromJson(Map<String, dynamic> json) =>
    ModuleModelFirebase(
      id: json['id'] as String? ?? '',
      moduleName: json['moduleName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isPublished: json['isPublished'] as bool? ?? false,
    );

Map<String, dynamic> _$ModuleModelFirebaseToJson(
  ModuleModelFirebase instance,
) => <String, dynamic>{
  'id': instance.id,
  'moduleName': instance.moduleName,
  'description': instance.description,
  'isPublished': instance.isPublished,
};
