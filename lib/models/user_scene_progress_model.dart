class UserSceneProgressModel {
  final int? id;
  final int userId;
  final int sceneId;
  final bool isCompleted;
  final int earnedXp;
  final String? completedAt;

  UserSceneProgressModel({
    this.id,
    required this.userId,
    required this.sceneId,
    required this.isCompleted,
    required this.earnedXp,
    this.completedAt,
  });

  factory UserSceneProgressModel.fromMap(Map<String, dynamic> map) {
    return UserSceneProgressModel(
      id: map['id'],
      userId: map['user_id'],
      sceneId: map['scene_id'],
      isCompleted: map['is_completed'] == 1,
      earnedXp: map['earned_xp'],
      completedAt: map['completed_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'scene_id': sceneId,
      'is_completed': isCompleted ? 1 : 0,
      'earned_xp': earnedXp,
      'completed_at': completedAt,
    };
  }
}
