import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

// flutter pub run build_runner build

@JsonSerializable()
class Task {
  String id;
  String title;
  bool isCompleted;
  Task({this.id = '', this.title = '', this.isCompleted = false});
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

@JsonSerializable()
class Skill {
  String id;
  String title;
  int exp;
  int level;
  Skill({this.id = '', this.title = '', this.exp = 0, this.level = 1});
  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
  Map<String, dynamic> toJson() => _$SkillToJson(this);
}

@JsonSerializable()
class Report {
  String uid;
  Map tasks;

  Report({this.uid = '', this.tasks = const {}});
  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
