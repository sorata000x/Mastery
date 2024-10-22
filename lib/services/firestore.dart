import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skillborn/services/models.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? _user = FirebaseAuth.instance.currentUser?.uid;

  String? get user => _user;

  FirestoreService() {
    // Update user whenever user changes
    FirebaseAuth.instance.authStateChanges().listen((User? currentUser) {
      _user = currentUser?.uid;
    });
    updateFunction();
  }

  // User

  void updateUser() {
    _user = FirebaseAuth.instance.currentUser?.uid;
  }

  // User - Exp

  Future<int> getExp() async {
    print("GET EXP");
    var ref = _db
        .collection('users')
        .doc(user);
    var snapshot = await ref.get();
    var exp = snapshot.get('exp');
    return exp;
  }

  Future setExp(int newExp) {
    print("SET EXP");

    var ref = _db
        .collection('users')
        .doc(user);

    return ref.update({
      'exp': newExp,
    });
  }

  // User - Karma

  Future<int> getKarma() async {
    print("GET KARMA");
    var ref = _db
        .collection('users')
        .doc(user);
    var snapshot = await ref.get();
    var karma = snapshot.get('karma');
    return karma;
  }

  Future setKarma(int newKarma) {
    print("SET KARMA");

    var ref = _db
        .collection('users')
        .doc(user);

    return ref.update({
      'karma': newKarma
    });
  }

  // User - Task

  Future<List<Task>> getTasks() async {
    print("GET TASK");
    var ref = _db
        .collection('users') // User collection
        .doc(user) // Specific user document
        .collection('tasks'); // Tasks subcollection
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var tasks = data.map((d) => Task.fromJson(d));
    return tasks.toList();
  }

  Future setTask(Task task) {
    print("SET TASK");

    CollectionReference tasks = _db
        .collection('users') // User collection
        .doc(user) // Specific user document
        .collection('tasks'); // Tasks subcollection

    // Set data with a custom ID
    return tasks
        .doc(task.id)
        .set(task.toJson())
        .then((value) => print("Task Set"))
        .catchError((error) => print("Failed to set task: $error"));
  }

  Future setTasks(List<Task> newTasks) async {
    print("SET TASKS");
    CollectionReference tasks =
        _db.collection('users').doc(user).collection('tasks');
    try {
      // Replace all tasks with new tasks
      for (var task in newTasks) {
        await tasks
            .doc(task.id)
            .set(task.toJson())
            .then((value) => print("Task Set"))
            .catchError((error) => print("Failed to set task: $error"));
      }
      print("Tasks collection successfully replaced.");
    } catch (e) {
      print("Error replacing tasks collection: $e");
    }
  }

  Future<void> deleteTask(String taskId) async {
    print("DELETE TASK");
    CollectionReference tasks =
        _db.collection('users').doc(user).collection('tasks');
    await tasks.doc(taskId).delete();
  }

  // User - Skills

  Future<List<UserSkill>> getSkills() async {
    var ref = _db.collection('users').doc(user).collection('skills');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var skills = data.map((d) => UserSkill.fromJson(d));
    return skills.toList();
  }

  Future setSkill(UserSkill skill) {
    CollectionReference skills =
        _db.collection('users').doc(user).collection('skills');

    return skills
        .doc(skill.id)
        .set(skill.toJson())
        .then((value) => print("Skill Set"))
        .catchError((error) => print("Failed to set skill: $error"));
  }

  Future setSkills(List<UserSkill> newSkills) async {
    CollectionReference skills =
        _db.collection('users').doc(user).collection('skills');
    try {
      // Replace all skills with new skills
      for (var skill in newSkills) {
        await skills
            .doc(skill.id)
            .set(skill.toJson())
            .then((value) => print("Skill Set"))
            .catchError((error) => print("Failed to set skill: $error"));
      }
      print("Skills collection successfully replaced.");
    } catch (e) {
      print("Error replacing skills collection: $e");
    }
  }

  // User - Created Skills

  Future<List<Skill>?> getCreatedSkills() async {
    var ref = _db.collection('users').doc(user).collection('created-skills');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var createdSkills = data.map((d) => Skill.fromJson(d));
    return createdSkills.toList();
  }

  Future setCreatedSkills(Skill createdSkill) {
    CollectionReference createdSkills =
        _db.collection('users').doc(user).collection('created-skills');

    // Set data with a custom ID
    return createdSkills
        .doc(createdSkill.id)
        .set(createdSkill.toJson())
        .then((value) => print("Created Skills Set"))
        .catchError((error) => print("Failed to set created skill: $error"));
  }

  /* Global */

  /* Global - Skills */

  Future<List<Skill>?> getGlobalSkills() async {
    var ref = _db.collection('global-skills');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var globalSkillList = data.map((d) => Skill.fromJson(d));
    return globalSkillList.toList();
  }

  Future setGlobalSkill(Skill createdSkill) {
    CollectionReference globalSkills = _db.collection('global-skills');

    // Set data with a custom ID
    return globalSkills
        .doc(createdSkill.id)
        .set(createdSkill.toJson())
        .then((value) => print("Global Skills Set"))
        .catchError((error) => print("Failed to set global skill: $error"));
  }

  /* Global - TaskSkill */

  // Data: {taskTitle, skillsId}
  // Purpose: Get new skills for task

  /// Get skill ids from global task-skills
  Future<Set<String>?> getGlobalTaskSkills(String taskTitle) async {
    var ref = _db.collection('task-skills').doc(taskTitle);
    var snapshot = await ref.get();
    var data = snapshot.data();

    if (data == null) return null;
    Set<String> skillsId = {};
    for (var d in data['skillsId']) {
      skillsId.add(d as String);
    }

    return skillsId;
  }

  Future setGlobalTaskSkills(String taskTitle, Set<String> skillsId) {
    CollectionReference taskSkills = _db.collection('task-skills');

    return taskSkills
        .doc(taskTitle)
        .set({'skillsId': skillsId})
        .then((value) => print("Task-Skills Set"))
        .catchError((error) => print("Failed to set Task-Skills: $error"));
  }

  // Functions

  Future<List<dynamic>> getFunctions() async {
    var ref = _db.collection('global').doc('functions'); // User collection
    var snapshot = await ref.get();
    var data = snapshot.data();
    print("DATA: $data");
    if (data == null) return [];
    List<dynamic> functions = data['functions'];
    print("FUNCTIONS: ${functions.toString()}");
    return functions;
  }

  Future updateFunction() {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference functions = db.collection('global'); // User collection
    return functions.doc('functions').set({'functions': funcs});
  }
}

const funcs = [
  {
    "name": "generateTaskExperience",
    "parameters": {
      "type": "object",
      "description":
          "Give user experience point from completing task",
      "properties": {
        "exp": {
          "types": "number",
          "description":
              "A integer of experience point",
        }
      }
    }
  },
  {
    "name": "generateSkillExpFromTask",
    "parameters": {
      "type": "object",
      "description":
          "Experience for skills from completed task. 0 exp if skill not highly relevant to the task. Example exps: [10, 30, 50, 100, 0]",
      "properties": {
        "exps": {
          "types": "array",
          "description":
              "A list of experience points for skills that leveled up from completing the task",
          "items": {
            "type": "number",
          }
        }
      }
    }
  },
  {
    "name": "generateSkillExpForTasks",
    "parameters": {
      "type": "object",
      "description":
          "Skill experience for a list of tasks. 0 exp if skill not highly relevant to the task. Example exps: [10, 30, 50, 100, 0]",
      "properties": {
        "exps": {
          "types": "array",
          "description":
              "A list of experience points for a skill from a list of tasks",
          "items": {
            "type": "number",
          }
        }
      }
    }
  },
  {
    "name": "generateNewSkills",
    "parameters": {
      "type": "object",
      "properties": {
        "skills": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "name": {
                "type": "string",
                "description": "Descriptive skill name",
              },
              "description": {
                "type": "string",
                "description":
                    "General skill description. Tone: appealing and desirable."
              },
              "effect": {
                "type": "string",
                "description":
                    "Bullet points of benefit of the skill to the user",
              },
              "cultivation": {
                "type": "string",
                "description":
                    "Bullet points of methods to cultivate the skill",
              },
              "type": {
                "type": "string",
                "description": """
                  Choose one from the following list:[ 
                  'energy', 'endurance', 'run-walk', 'cycling', 'swim', 'sports', 'strength', 'stretching'
                  'clean', 'cook',
                  'thinking', 'memory', 'focus', 'learning', 'emotion', 'creativity', 'problem-solving', 
                  'mental', 
                  'sleep', 'food',
                  'social',
                  'software', 'hardware', 
                  'design',
                  'other'
                  ]
                """
              },
            }
          },
          "description": """
            For the completed task, give a list of skills name, description, effect, 
            cultivation, type that user gained. Skills should be broad and practical. 
            Return empty if user's task doesn't associate with any skill. 
            Example skill: { 
              “name”: "Skill Name", 
              "description": “Explain what the skill does”, 
              “effect”: “The benefits”, 
              “cultivation”: “The methods”, 
              “category”: “Other”, 
              "type": "other" 
            }
          """,
        }
      },
      "required": ["skills"]
    }
  }
];
