import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

// flutter pub run build_runner build

@JsonSerializable()
class Task {
  String id;
  String title;
  String note;
  List<String>? skills;
  int index;
  bool isCompleted;
  Task(
      {this.id = '',
      this.title = '',
      this.note = '',
      this.skills,
      this.index = 0,
      this.isCompleted = false});
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

@JsonSerializable()
class Skill {
  String id;
  int index;
  String title;
  String description;
  String effect;
  String cultivation;
  String type;
  String category;
  String author;
  String rank;
  int exp;
  int level;

  Skill(
      {this.id = '',
      this.index = 0,
      this.title = '',
      this.description = '',
      this.effect = '',
      this.cultivation = '',
      this.type = 'other',
      this.category = '',
      this.author = 'Unknown',
      this.rank = 'Common',
      this.exp = 0,
      this.level = 1,
      });
  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
  Map<String, dynamic> toJson() => _$SkillToJson(this);
}

@JsonSerializable()
class GlobalSkill {
  String id;
  String title;
  String description;
  String effect;
  String cultivation;
  String type;
  String category;
  String author;
  String rank;
  GlobalSkill({
    this.id = '',
    this.title = 'Undefined',
    this.description = '',
    this.effect = '',
    this.cultivation = '',
    this.type = '',
    this.category = '',
    this.author = 'unknown',
    this.rank = 'Unranked',
  });
  factory GlobalSkill.fromJson(Map<String, dynamic> json) =>
      _$GlobalSkillFromJson(json);
  Map<String, dynamic> toJson() => _$GlobalSkillToJson(this);
}

@JsonSerializable()
class TaskSkills {
  String title;
  List<Map<String, dynamic>> skills;

  TaskSkills({this.title = '', List<Map<String, dynamic>>? skills})
      : skills = skills ?? [];
  factory TaskSkills.fromJson(Map<String, dynamic> json) =>
      _$TaskSkillsFromJson(json);
  Map<String, dynamic> toJson() => _$TaskSkillsToJson(this);
}
