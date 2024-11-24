// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String? ?? '',
      list: json['list'] as String? ?? '',
      title: json['title'] as String? ?? '',
      note: json['note'] as String? ?? '',
      skillExps: (json['skillExps'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      karma: (json['karma'] as num?)?.toInt(),
      index: (json['index'] as num?)?.toInt() ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'list': instance.list,
      'title': instance.title,
      'note': instance.note,
      'skillExps': instance.skillExps,
      'karma': instance.karma,
      'index': instance.index,
      'isCompleted': instance.isCompleted,
    };

Skill _$SkillFromJson(Map<String, dynamic> json) => Skill(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      path: json['path'] as String? ?? '',
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
      'path': instance.path,
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
      path: json['path'] as String? ?? '',
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
      'path': instance.path,
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

TaskList _$TaskListFromJson(Map<String, dynamic> json) => TaskList(
      id: json['id'] as String? ?? '',
      index: (json['index'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
    );

Map<String, dynamic> _$TaskListToJson(TaskList instance) => <String, dynamic>{
      'id': instance.id,
      'index': instance.index,
      'title': instance.title,
    };

SkillPath _$SkillPathFromJson(Map<String, dynamic> json) => SkillPath(
      id: json['id'] as String? ?? '',
      index: (json['index'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
    );

Map<String, dynamic> _$SkillPathToJson(SkillPath instance) => <String, dynamic>{
      'id': instance.id,
      'index': instance.index,
      'title': instance.title,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      timeStamp: json['timeStamp'] as String? ?? '',
      role: json['role'] as String? ?? '',
      content: json['content'] as String? ?? '',
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'timeStamp': instance.timeStamp,
      'role': instance.role,
      'content': instance.content,
    };

Conversation _$ConversationFromJson(Map<String, dynamic> json) => Conversation(
      id: json['id'] as String? ?? '',
      timeStamp: json['timeStamp'] as String? ?? '',
      title: json['title'] as String? ?? '',
      agentQueue: (json['agentQueue'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          const [],
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timeStamp': instance.timeStamp,
      'title': instance.title,
      'agentQueue': instance.agentQueue,
      'messages': instance.messages,
    };

Agent _$AgentFromJson(Map<String, dynamic> json) => Agent(
      id: json['id'] as String? ?? '',
      role: json['role'] as String? ?? '',
      content: json['content'] as String? ?? '',
    );

Map<String, dynamic> _$AgentToJson(Agent instance) => <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'content': instance.content,
    };
