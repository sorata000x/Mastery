// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      note: json['note'] as String? ?? '',
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
      index: (json['index'] as num?)?.toInt() ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'note': instance.note,
      'skills': instance.skills,
      'index': instance.index,
      'isCompleted': instance.isCompleted,
    };

Skill _$SkillFromJson(Map<String, dynamic> json) => Skill(
      id: json['id'] as String? ?? '',
      index: (json['index'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      effect: json['effect'] as String? ?? '',
      cultivation: json['cultivation'] as String? ?? '',
      type: json['type'] as String? ?? 'other',
      category: json['category'] as String? ?? '',
      author: json['author'] as String? ?? 'Unknown',
      rank: json['rank'] as String? ?? 'Common',
      exp: (json['exp'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$SkillToJson(Skill instance) => <String, dynamic>{
      'id': instance.id,
      'index': instance.index,
      'title': instance.title,
      'description': instance.description,
      'effect': instance.effect,
      'cultivation': instance.cultivation,
      'type': instance.type,
      'category': instance.category,
      'author': instance.author,
      'rank': instance.rank,
      'exp': instance.exp,
      'level': instance.level,
    };

GlobalSkill _$GlobalSkillFromJson(Map<String, dynamic> json) => GlobalSkill(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Undefined',
      description: json['description'] as String? ?? '',
      effect: json['effect'] as String? ?? '',
      cultivation: json['cultivation'] as String? ?? '',
      type: json['type'] as String? ?? '',
      category: json['category'] as String? ?? '',
      author: json['author'] as String? ?? 'unknown',
      rank: json['rank'] as String? ?? 'Unranked',
    );

Map<String, dynamic> _$GlobalSkillToJson(GlobalSkill instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'effect': instance.effect,
      'cultivation': instance.cultivation,
      'type': instance.type,
      'category': instance.category,
      'author': instance.author,
      'rank': instance.rank,
    };

TaskSkills _$TaskSkillsFromJson(Map<String, dynamic> json) => TaskSkills(
      title: json['title'] as String? ?? '',
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$TaskSkillsToJson(TaskSkills instance) =>
    <String, dynamic>{
      'title': instance.title,
      'skills': instance.skills,
    };
