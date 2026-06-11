import 'dart:typed_data';

class AssetSceneModel {
  final int? id;
  final String imageName;
  final Uint8List image;
  final String category;

  AssetSceneModel({
    this.id,
    required this.imageName,
    required this.image,
    required this.category,
  });

  factory AssetSceneModel.fromMap(Map<String, dynamic> map) {
    return AssetSceneModel(
      id: map['id'],
      imageName: map['image_name'],
      image: map['image'],
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image_name': imageName,
      'image': image,
      'category': category,
    };
  }
}
