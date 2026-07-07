// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_model_firebase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SceneModelFirebase _$SceneModelFirebaseFromJson(Map<String, dynamic> json) =>
    SceneModelFirebase(
      id: json['id'] as String? ?? '',
      levelId: json['levelId'] as String? ?? '',
      bgImageId: json['bgImageId'] as String?,
      charImageId: json['charImageId'] as String?,
      charName: json['charName'] as String?,
      charDialog: json['charDialog'] as String?,
      sceneType: json['sceneType'] as String? ?? '',
      optionalSentence: json['optionalSentence'] as String?,
      question: json['question'] as String?,
      optionA: json['optionA'] as String?,
      optionB: json['optionB'] as String?,
      optionC: json['optionC'] as String?,
      answerKeyMultipleChoice: json['answerKeyMultipleChoice'] as String?,
      answerKey: json['answerKey'] as String?,
      rewardXp: (json['rewardXp'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SceneModelFirebaseToJson(SceneModelFirebase instance) =>
    <String, dynamic>{
      'id': instance.id,
      'levelId': instance.levelId,
      'bgImageId': instance.bgImageId,
      'charImageId': instance.charImageId,
      'charName': instance.charName,
      'charDialog': instance.charDialog,
      'sceneType': instance.sceneType,
      'optionalSentence': instance.optionalSentence,
      'question': instance.question,
      'optionA': instance.optionA,
      'optionB': instance.optionB,
      'optionC': instance.optionC,
      'answerKeyMultipleChoice': instance.answerKeyMultipleChoice,
      'answerKey': instance.answerKey,
      'rewardXp': instance.rewardXp,
    };
