import 'package:json_annotation/json_annotation.dart';

part 'module_model_firebase.g.dart';

@JsonSerializable()
class ModuleModelFirebase {
  @JsonKey(defaultValue: '')
  final String id;

  @JsonKey(defaultValue: '')
  final String moduleName;

  @JsonKey(defaultValue: '')
  final String description;

  @JsonKey(defaultValue: false)
  final bool isPublished;

  ModuleModelFirebase({
    required this.id,
    required this.moduleName,
    required this.description,
    required this.isPublished,
  });

  factory ModuleModelFirebase.fromJson(Map<String, dynamic> json) =>
      _$ModuleModelFirebaseFromJson(json);

  factory ModuleModelFirebase.fromMap(Map<String, dynamic> map) =>
      ModuleModelFirebase.fromJson(map);

  Map<String, dynamic> toJson() => _$ModuleModelFirebaseToJson(this);

  Map<String, dynamic> toMap() => toJson();
}
