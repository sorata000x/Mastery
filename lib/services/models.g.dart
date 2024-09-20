// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      index: (json['index'] as num?)?.toInt() ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'index': instance.index,
      'isCompleted': instance.isCompleted,
    };

Skill _$SkillFromJson(Map<String, dynamic> json) => Skill(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      exp: (json['exp'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      type: json['type'] as String? ?? '',
    );

Map<String, dynamic> _$SkillToJson(Skill instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'exp': instance.exp,
      'level': instance.level,
      'type': instance.type,
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
