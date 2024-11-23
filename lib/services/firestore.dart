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
    debugPrint("(firestore.dart) GET EXP");
    var ref = _db.collection('users').doc(user);
    var snapshot = await ref.get();
    var exp = snapshot.get('exp');
    return exp;
  }

  Future setExp(int newExp) {
    debugPrint("(firestore.dart) SET EXP");

    var ref = _db.collection('users').doc(user);

    return ref.update({
      'exp': newExp,
    });
  }

  // User - Karma

  Future<int> getKarma() async {
    debugPrint("(firestore.dart) GET KARMA");
    var ref = _db.collection('users').doc(user);
    var snapshot = await ref.get();
    var karma = snapshot.get('karma');
    return karma;
  }

  Future setKarma(int newKarma) {
    debugPrint("(firestore.dart) SET KARMA");

    var ref = _db.collection('users').doc(user);

    return ref.update({'karma': newKarma});
  }

  // User - Task

  Future<List<Task>> getTasks() async {
    debugPrint("(firestore.dart) GET TASK");
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
    debugPrint("(firestore.dart) SET TASK");

    CollectionReference tasks = _db
        .collection('users') // User collection
        .doc(user) // Specific user document
        .collection('tasks'); // Tasks subcollection

    // Set data with a custom ID
    return tasks
        .doc(task.id)
        .set(task.toJson())
        .then((value) => debugPrint("(firestore.dart) Task Set"))
        .catchError((error) => debugPrint("(firestore.dart) Failed to set task: $error"));
  }

  Future setTasks(List<Task> newTasks) async {
    debugPrint("(firestore.dart) SET TASKS");
    CollectionReference tasks =
        _db.collection('users').doc(user).collection('tasks');
    try {
      // Replace all tasks with new tasks
      for (var task in newTasks) {
        await tasks
            .doc(task.id)
            .set(task.toJson())
            .then((value) => debugPrint("(firestore.dart) Task Set"))
            .catchError((error) => debugPrint("(firestore.dart) Failed to set task: $error"));
      }
      debugPrint("(firestore.dart) Tasks collection successfully replaced.");
    } catch (e) {
      debugPrint("(firestore.dart) Error replacing tasks collection: $e");
    }
  }

  Future<void> deleteTask(String taskId) async {
    debugPrint("(firestore.dart) DELETE TASK");
    CollectionReference tasks =
        _db.collection('users').doc(user).collection('tasks');
    await tasks.doc(taskId).delete();
  }

  // User - List

  Future<List<TaskList>> getLists() async {
    debugPrint("(firestore.dart) GET LISTS");
    var ref = _db.collection('users').doc(user).collection('lists');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var lists = data.map((d) => TaskList.fromJson(d));
    return lists.toList();
  }

  Future setList(TaskList list) {
    debugPrint("(firestore.dart) SET LIST");

    CollectionReference lists =
        _db.collection('users').doc(user).collection('lists');

    return lists
        .doc(list.id)
        .set(list.toJson())
        .then((value) => debugPrint("(firestore.dart) List Set"))
        .catchError((error) => debugPrint("(firestore.dart) Failed to set list: $error"));
  }

  Future setLists(List<TaskList> newLists) async {
    debugPrint("(firestore.dart) SET LISTS");
    CollectionReference lists =
        _db.collection('users').doc(user).collection('lists');
    try {
      // Replace all tasks with new tasks
      for (var list in newLists) {
        await lists
            .doc(list.id)
            .set(list.toJson())
            .then((value) => debugPrint("(firestore.dart) List Set"))
            .catchError((error) => debugPrint("(firestore.dart) Failed to set list: $error"));
      }
      debugPrint("(firestore.dart) Lists collection successfully replaced.");
    } catch (e) {
      debugPrint("(firestore.dart) Error replacing lists collection: $e");
    }
  }

  Future<void> deleteList(String listId) async {
    debugPrint("(firestore.dart) DELETE LIST");
    CollectionReference lists =
        _db.collection('users').doc(user).collection('lists');
    await lists.doc(listId).delete();
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
        .then((value) => debugPrint("(firestore.dart) Skill Set"))
        .catchError((error) => debugPrint("(firestore.dart) Failed to set skill: $error"));
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
            .then((value) => debugPrint("(firestore.dart) Skill Set"))
            .catchError((error) => debugPrint("(firestore.dart) Failed to set skill: $error"));
      }
      debugPrint("(firestore.dart) Skills collection successfully replaced.");
    } catch (e) {
      debugPrint("(firestore.dart) Error replacing skills collection: $e");
    }
  }

  // User - Path

  Future<List<SkillPath>> getPaths() async {
    debugPrint("(firestore.dart) GET PATHS");
    var ref = _db.collection('users').doc(user).collection('paths');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var paths = data.map((d) => SkillPath.fromJson(d));
    return paths.toList();
  }

  Future setPath(SkillPath path) {
    debugPrint("(firestore.dart) SET PATH");

    CollectionReference paths =
        _db.collection('users').doc(user).collection('paths');

    return paths
        .doc(path.id)
        .set(path.toJson())
        .then((value) => debugPrint("(firestore.dart) Path Set"))
        .catchError((error) => debugPrint("(firestore.dart) Failed to set path: $error"));
  }

  Future setPaths(List<SkillPath> newPaths) async {
    debugPrint("(firestore.dart) SET PATHS");
    CollectionReference paths =
        _db.collection('users').doc(user).collection('paths');
    try {
      for (var path in newPaths) {
        await paths
            .doc(path.id)
            .set(path.toJson())
            .then((value) => debugPrint("(firestore.dart) Path Set"))
            .catchError((error) => debugPrint("(firestore.dart) Failed to set path: $error"));
      }
      debugPrint("(firestore.dart) Paths collection successfully replaced.");
    } catch (e) {
      debugPrint("(firestore.dart) Error replacing paths collection: $e");
    }
  }

  Future<void> deletePath(String pathId) async {
    debugPrint("(firestore.dart) DELETE PATH");
    CollectionReference paths =
        _db.collection('users').doc(user).collection('paths');
    await paths.doc(pathId).delete();
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
        .then((value) => debugPrint("(firestore.dart) Created Skills Set"))
        .catchError((error) => debugPrint("(firestore.dart) Failed to set created skill: $error"));
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
        .then((value) => debugPrint("(firestore.dart) Global Skills Set"))
        .catchError((error) => debugPrint("(firestore.dart) Failed to set global skill: $error"));
  }

  // User - Messages

  Future<void> addMessage(String conversationId, Message message) async {
    debugPrint("(firestore.dart) ADD MESSAGE");
    var ref = _db
        .collection('conversations')
        .doc(conversationId)
        .collection('messages');
    await ref.add(message.toJson());
  }

  Future<void> deleteMessage(String messageId, String conversationId) async {
    debugPrint("(firestore.dart) DELETE MESSAGE");
    var ref = _db
        .collection('conversations')
        .doc(conversationId)
        .collection('messages');
    await ref.doc(messageId).delete();
  }

  // User - Conversations

  Future<List<Conversation>> getConversations() async {
    debugPrint("(firestore.dart) GET CONVERSATIONS");
    var ref = _db
        .collection('users')
        .doc(user)
        .collection('conversations')
        .orderBy('timeStamp');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var conversations = data.map((d) => Conversation.fromJson(d));
    return conversations.toList();
  }

  Future setConversation(Conversation conversation) {
    debugPrint("(firestore.dart) SET CONVERSATION");

    var ref = _db.collection('users').doc(user).collection('conversations');

    // Set data with a custom ID
    return ref
        .doc(conversation.id)
        .set(conversation.toJson())
        .then((value) => debugPrint("(firestore.dart) Message Set"))
        .catchError((error) => debugPrint("(firestore.dart) Failed to set message: $error"));
  }

  Future<void> deleteConversation(String id) async {
    debugPrint("(firestore.dart) DELETE CONVERSATION");
    var ref = _db.collection('users').doc(user).collection('conversations');
    await ref.doc(id).delete();
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
        .then((value) => debugPrint("(firestore.dart) Task-Skills Set"))
        .catchError((error) => debugPrint("(firestore.dart) Failed to set Task-Skills: $error"));
  }

  // Functions

  Future<List<dynamic>> getFunctions() async {
    var ref = _db.collection('global').doc('functions'); // User collection
    var snapshot = await ref.get();
    var data = snapshot.data();
    if (data == null) return [];
    List<dynamic> functions = data['functions'];
    return functions;
  }

  Future updateFunction() {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference functions = db.collection('global'); // User collection
    return functions.doc('functions').set({'functions': funcs});
  }

  // Categories

  Future<List<String>> getCategories() async {
    var ref = _db.collection('global').doc('categories'); // User collection
    var snapshot = await ref.get();
    var categories = snapshot.get('categories');
    return categories;
  }
}

const funcs = [
  {
    "name": "createPlan",
    "parameters": {
      "type": "object",
      "description": "Start action to create plan for user",
      "properties": {
        "exp": {
          "types": "number",
          "description": "A integer of experience point",
        }
      }
    }
  },
  {
    "name": "planQuestions",
    "parameters": {
      "type": "object",
      "description": """
        Ask questions to tailor the plan to the user.
        """,
      "properties": {
        "questions": {
          "types": "list",
          "items": {
            "type": "object",
            "description": """
              The question need to:
                - Define the goal
                - Make goal clear and specific
                - Set time constrain
              Example:
              {
                prompt: "What does financial freedom mean to you personally?",
                options: [
                  "Having enough savings, investments, and passive income to cover my living expenses without depending on a job.",
                  "Being debt-free and not worrying about monthly bills.",
                  "Having the freedom to make choices based on my interests rather than financial needs."
                ]
              }
            """,
            "properties": {
              "prompt": {"type": "string"},
              "options": {
                "type": "list",
                "items": {"type": "string"}
              }
            }
          }
        }
      }
    }
  },
  {
    "name": "generateTaskExperience",
    "parameters": {
      "type": "object",
      "description": "Give user experience point from completing task",
      "properties": {
        "exp": {
          "types": "number",
          "description": "A integer of experience point",
        }
      }
    }
  },
  {
    "name": "generateSkillExpFromTask",
    "parameters": {
      "type": "object",
      "description":
          "Experience points for skills from completed task. 0 exp if skill not relevant to the task. Example exps: [10, 30, 50, 100, 0]",
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
              "category": {
                "type": "string",
                "description": """
                  Choose one from the following list:[ 
                  'Core', 'Professional', 'Social', 'Stoic', 'Other'
                  ]
                """
              }
            }
          },
          "description": """
            For the completed task, give a list of skills name, description, effect, 
            cultivation, type, category that user gained. Skills should be broad and practical. 
            Return empty if user's task doesn't associate with any skill. 
            Example skill: { 
              “name”: "Skill Name", 
              "description": “Explain what the skill does”, 
              “effect”: “The benefits”, 
              “cultivation”: “The methods”, 
              "type": "other",
              “category”: “Other”, 
            }
          """,
        }
      },
      "required": ["skills"]
    }
  }
];
