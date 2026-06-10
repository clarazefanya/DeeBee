import 'dart:convert';

class UserModel {
  final int? id;
  final String name;
  final String email;
  final String password;
  final int avatarIndex;
  final String role;
  final bool isActive;
  final String createdAt;
  final int? lastLevelId;
  final int xp;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.avatarIndex,
    required this.role,
    required this.isActive,
    required this.createdAt,
    this.lastLevelId,
    required this.xp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'avatar_index': avatarIndex,
      'xp': xp,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      avatarIndex: map['avatar_index'] as int,
      role: map['role'] as String,
      isActive: (map['is_active'] as int) == 1,
      createdAt: map['created_at'] as String,
      lastLevelId: map['last_level_id'] != null
          ? map['last_level_id'] as int
          : null,
      xp: map['xp'] != null ? map['xp'] as int : 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
