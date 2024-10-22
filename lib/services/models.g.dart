// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      note: json['note'] as String? ?? '',
      skillExps: (json['skillExps'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      index: (json['index'] as num?)?.toInt() ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'note': instance.note,
      'skillExps': instance.skillExps,
      'index': instance.index,
      'isCompleted': instance.isCompleted,
    };

Skill _$SkillFromJson(Map<String, dynamic> json) => Skill(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      description: json['description'] as String? ?? '',
      effect: json['effect'] as String? ?? '',
      cultivation: json['cultivation'] as String? ?? '',
      type: json['type'] as String? ?? 'other',
      category: json['category'] as String? ?? '',
      author: json['author'] as String? ?? 'Unknown',
      rank: json['rank'] as String? ?? 'Common',
    );

Map<String, dynamic> _$SkillToJson(Skill instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'effect': instance.effect,
      'cultivation': instance.cultivation,
      'type': instance.type,
      'category': instance.category,
      'author': instance.author,
      'rank': instance.rank,
    };

UserSkill _$UserSkillFromJson(Map<String, dynamic> json) => UserSkill(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      description: json['description'] as String? ?? '',
      effect: json['effect'] as String? ?? '',
      cultivation: json['cultivation'] as String? ?? '',
      type: json['type'] as String? ?? 'other',
      category: json['category'] as String? ?? '',
      author: json['author'] as String? ?? 'Unknown',
      rank: json['rank'] as String? ?? 'Common',
      index: (json['index'] as num?)?.toInt() ?? 0,
      exp: (json['exp'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$UserSkillToJson(UserSkill instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'effect': instance.effect,
      'cultivation': instance.cultivation,
      'type': instance.type,
      'category': instance.category,
      'author': instance.author,
      'rank': instance.rank,
      'index': instance.index,
      'exp': instance.exp,
      'level': instance.level,
    };

TaskSkills _$TaskSkillsFromJson(Map<String, dynamic> json) => TaskSkills(
      title: json['title'] as String? ?? '',
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TaskSkillsToJson(TaskSkills instance) =>
    <String, dynamic>{
      'title': instance.title,
      'skills': instance.skills,
    };

SkillExp _$SkillExpFromJson(Map<String, dynamic> json) => SkillExp(
      skillId: json['skillId'] as String? ?? '',
      exp: (json['exp'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SkillExpToJson(SkillExp instance) => <String, dynamic>{
      'skillId': instance.skillId,
      'exp': instance.exp,
    };

APIFunction _$APIFunctionFromJson(Map<String, dynamic> json) => APIFunction(
      name: json['name'] as String? ?? '',
      parameter: json['parameter'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$APIFunctionToJson(APIFunction instance) =>
    <String, dynamic>{
      'name': instance.name,
      'parameter': instance.parameter,
    };
