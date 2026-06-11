class ModuleModel {
  final int? id;
  final String moduleName;
  final String description;
  final bool isPublished;

  ModuleModel({
    this.id,
    required this.moduleName,
    required this.description,
    required this.isPublished,
  });

  factory ModuleModel.fromMap(Map<String, dynamic> map) {
    return ModuleModel(
      id: map['id'],
      moduleName: map['module_name'],
      description: map['description'],
      isPublished: map['is_published'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'module_name': moduleName,
      'description': description,
      'is_published': isPublished ? 1 : 0,
    };
  }
}
