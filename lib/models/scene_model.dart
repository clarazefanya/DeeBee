class SceneModel {
  final int? id;
  final int levelId;

  final int? bgImageId;
  final int? charImageId;

  final String? charName;
  final String? charDialog;

  final String sceneType;

  final String? optionalSentence;

  final String? question;

  final String? optionA;
  final String? optionB;
  final String? optionC;

  final String? answerKeyMultipleChoice;

  final String? answerKey;

  final int rewardXp;

  SceneModel({
    this.id,
    required this.levelId,
    this.bgImageId,
    this.charImageId,
    this.charName,
    this.charDialog,
    required this.sceneType,
    this.optionalSentence,
    this.question,
    this.optionA,
    this.optionB,
    this.optionC,
    this.answerKeyMultipleChoice,
    this.answerKey,
    this.rewardXp = 0,
  });

  factory SceneModel.fromMap(Map<String, dynamic> map) {
    return SceneModel(
      id: map['id'],
      levelId: map['level_id'],

      bgImageId: map['bg_image_id'],
      charImageId: map['char_image_id'],

      charName: map['char_name'],
      charDialog: map['char_dialog'],

      sceneType: map['scene_type'],

      optionalSentence: map['optional_sentence'],

      question: map['question'],

      optionA: map['option_a'],
      optionB: map['option_b'],
      optionC: map['option_c'],

      answerKeyMultipleChoice: map['answer_key_multiple_choice'],

      answerKey: map['answer_key'],

      rewardXp: map['reward_xp'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level_id': levelId,

      'bg_image_id': bgImageId,
      'char_image_id': charImageId,

      'char_name': charName,
      'char_dialog': charDialog,

      'scene_type': sceneType,

      'optional_sentence': optionalSentence,

      'question': question,

      'option_a': optionA,
      'option_b': optionB,
      'option_c': optionC,

      'answer_key_multiple_choice': answerKeyMultipleChoice,

      'answer_key': answerKey,

      'reward_xp': rewardXp,
    };
  }
}
