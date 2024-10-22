import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

// flutter pub run build_runner build

@JsonSerializable()
class Task {
  String id;
  String title;
  String note;
  List<Map>? skillExps;
  int? karma;
  int index;
  bool isCompleted;
  Task(
      {this.id = '',
      this.title = '',
      this.note = '',
      this.skillExps,
      this.karma,
      this.index = 0,
      this.isCompleted = false});
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

@JsonSerializable()
class Skill {
  String id;
  String name;
  String description;
  String effect;
  String cultivation;
  String type;
  String category;
  String author;
  String rank;

  Skill({
    this.id = '',
    this.name = 'Unknown',
    this.description = '',
    this.effect = '',
    this.cultivation = '',
    this.type = 'other',
    this.category = '',
    this.author = 'Unknown',
    this.rank = 'Common',
  });
  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
  Map<String, dynamic> toJson() => _$SkillToJson(this);
}

@JsonSerializable()
class UserSkill extends Skill {
  int index;
  int exp;
  int level;
  UserSkill(
      {super.id,
      super.name,
      super.description,
      super.effect,
      super.cultivation,
      super.type,
      super.category,
      super.author,
      super.rank,
      this.index = 0,
      this.exp = 0,
      this.level = 0});

  factory UserSkill.fromSkill(Skill skill, int index, int exp, int level) {
    return UserSkill(
      id: skill.id,
      name: skill.name,
      description: skill.description,
      effect: skill.effect,
      cultivation: skill.cultivation,
      type: skill.type,
      category: skill.category,
      author: skill.author,
      rank: skill.rank,
      index: index,
      exp: exp,
      level: level,
    );
  }

  factory UserSkill.fromJson(Map<String, dynamic> json) =>
      _$UserSkillFromJson(json);
  Map<String, dynamic> toJson() => _$UserSkillToJson(this);
}

@JsonSerializable()
class TaskSkills {
  String title;
  List<String> skills;

  TaskSkills({this.title = '', this.skills = const []});
  factory TaskSkills.fromJson(Map<String, dynamic> json) =>
      _$TaskSkillsFromJson(json);
  Map<String, dynamic> toJson() => _$TaskSkillsToJson(this);
}

@JsonSerializable()
class SkillExp {
  String skillId;
  int exp;

  SkillExp({this.skillId = '', this.exp = 0});
  factory SkillExp.fromJson(Map<String, dynamic> json) =>
      _$SkillExpFromJson(json);
  Map<String, dynamic> toJson() => _$SkillExpToJson(this);
}

@JsonSerializable()
class APIFunction {
  String name;
  Map parameter;

  APIFunction({this.name = '', this.parameter = const {}});
  factory APIFunction.fromJson(Map<String, dynamic> json) =>
      _$APIFunctionFromJson(json);
  Map<String, dynamic> toJson() => _$APIFunctionToJson(this);
}
