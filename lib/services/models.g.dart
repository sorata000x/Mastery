// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isCompleted': instance.isCompleted,
    };

Skill _$SkillFromJson(Map<String, dynamic> json) => Skill(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      exp: (json['exp'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$SkillToJson(Skill instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'exp': instance.exp,
      'level': instance.level,
    };

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      uid: json['uid'] as String? ?? '',
      tasks: json['tasks'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'uid': instance.uid,
      'tasks': instance.tasks,
    };
