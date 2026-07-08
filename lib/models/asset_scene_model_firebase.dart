import 'package:json_annotation/json_annotation.dart';

part 'asset_scene_model_firebase.g.dart';

@JsonSerializable()
class AssetSceneModelFirebase {
  @JsonKey(defaultValue: '')
  final String id;

  @JsonKey(defaultValue: '')
  final String imageName;

  @JsonKey(defaultValue: '')
  final String imageBase64;

  @JsonKey(defaultValue: '')
  final String category;

  AssetSceneModelFirebase({
    required this.id,
    required this.imageName,
    required this.imageBase64,
    required this.category,
  });

  factory AssetSceneModelFirebase.fromJson(Map<String, dynamic> json) =>
      _$AssetSceneModelFirebaseFromJson(json);

  factory AssetSceneModelFirebase.fromMap(Map<String, dynamic> map) =>
      AssetSceneModelFirebase.fromJson(map);

  Map<String, dynamic> toJson() => _$AssetSceneModelFirebaseToJson(this);

  Map<String, dynamic> toMap() => toJson();
}
