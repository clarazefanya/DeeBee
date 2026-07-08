// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_scene_model_firebase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetSceneModelFirebase _$AssetSceneModelFirebaseFromJson(
  Map<String, dynamic> json,
) => AssetSceneModelFirebase(
  id: json['id'] as String? ?? '',
  imageName: json['imageName'] as String? ?? '',
  imageBase64: json['imageBase64'] as String? ?? '',
  category: json['category'] as String? ?? '',
);

Map<String, dynamic> _$AssetSceneModelFirebaseToJson(
  AssetSceneModelFirebase instance,
) => <String, dynamic>{
  'id': instance.id,
  'imageName': instance.imageName,
  'imageBase64': instance.imageBase64,
  'category': instance.category,
};
