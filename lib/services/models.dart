import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

// flutter pub run build_runner build

@JsonSerializable()
class Task {
  String id;
  String title;
  int index;
  bool isCompleted;
  Task(
      {this.id = '',
      this.title = '',
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
  int exp;
  int level;
  String type;
  Skill(
      {this.id = '',
      this.index = 0,
      this.title = '',
      this.exp = 0,
      this.level = 1,
      this.type = ''});
  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
  Map<String, dynamic> toJson() => _$SkillToJson(this);
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
