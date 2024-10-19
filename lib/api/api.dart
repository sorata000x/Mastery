import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:skillborn/services/models.dart';
import 'package:uuid/uuid.dart';

// Usages

/// Generate skill exp with OpenAI API
Future<List<Map>?> generateSkillExpFromTask(context, task) async {
  final state = Provider.of<MainState>(context, listen: false);
  var messages = [
    {
      "role": "system",
      "content": "Response language: ${WidgetsBinding.instance.window.locale}"
    },
    {
      "role": "user",
      "content": "Task: ${task.title}, Skills: ${state.skills.toString()}"
    }
  ];
  var functions = state.functions
      .where((f) => f["name"] == "generateSkillExpFromTask")
      .toList();
  var result = await callChatGPT(context, messages, functions);
  if (result == null) return null;
  print(json.decode(result));
  List<int> exps =
      (json.decode(result) as List<dynamic>).map((e) => e as int).toList();
  List<Map> skillExps = [];
  for (var i = 0; i < exps.length; i++) {
    if (exps[i] > 0) {
      skillExps.add({"skillId": state.skills[i].id, "exp": exps[i]});
    }
  }
  state.setTask(Task(
    id: task.id,
    title: task.title,
    note: task.note,
    skillExps: skillExps,
    index: task.index,
    isCompleted: task.isCompleted,
  ));
  return skillExps;
}

/// Generate skill exp with OpenAI API
/// Call when new skills added
Future generateSkillExpForTasks(context, skill) async {
  final state = Provider.of<MainState>(context, listen: false);
  var messages = [
    {
      "role": "system",
      "content": "Response language: ${WidgetsBinding.instance.window.locale}"
    },
    {
      "role": "user",
      "content": "Skill: $skill, Tasks: ${state.tasks.map((t) => t.title)}"
    }
  ];
  var functions = state.functions
      .where((f) => f["name"] == "generateSkillExpForTasks")
      .toList();
  var result = await callChatGPT(context, messages, functions);
  if (result == null) return null;
  print(json.decode(result));
  List<int> exps =
      (json.decode(result) as List<dynamic>).map((e) => e as int).toList();
  for (var i = 0; i < exps.length; i++) {
    if (exps[i] > 0) {
      var skillExps = state.tasks[i].skillExps ?? [];
      state.setTask(Task(
          id: state.tasks[i].id,
          title: state.tasks[i].title,
          note: state.tasks[i].note,
          skillExps: [
            ...skillExps,
            {"skillId": skill.id, "exp": exps[i]}
          ],
          index: state.tasks[i].index,
          isCompleted: state.tasks[i].isCompleted));
    }
  }
}

/// Generate task tags and info with OpenAI API
Future<Set<String>?> generateNewSkills(context, taskTitle) async {
  final state = Provider.of<MainState>(context, listen: false);
  var messages = [
    {
      "role": "system",
      "content": "Response language: ${WidgetsBinding.instance.window.locale}"
    },
    {"role": "user", "content": "Task: $taskTitle"}
  ];
  var functions =
      state.functions.where((f) => f["name"] == "generateNewSkills").toList();
  var result = await callChatGPT(context, messages, functions);
  print("RESULT: $result");
  if (result == null) return null;
  var decodedResult = List<Map<String, dynamic>>.from(json.decode(result));
  var skills = [];
  Set<String> globalTaskSkillsSet = {};
  var globalTaskSkills =
      await FirestoreService().getGlobalTaskSkills(taskTitle) ?? {};
  for (var item in decodedResult) {
    var id = Uuid().v4();
    var skill = Skill(
      id: id,
      name: item["name"] ?? "Unknown",
      description: item["description"] ?? "",
      effect: item["effect"] ?? "",
      cultivation: item["cultivation"] ?? "",
      type: item["type"] ?? "other",
      category: item["category"] ?? "Other",
      author: "Skillborn GPT",
      rank: "Common",
    );
    // Add to global skills
    FirestoreService().setGlobalSkill(skill);
    // Add the new instance of task-skills to database
    globalTaskSkills.add(skill.id);
    skills.add(skill);
  }
  FirestoreService().setGlobalTaskSkills(taskTitle, globalTaskSkills);
  return globalTaskSkills;
}

// API Calls

Future<String?> callChatGPT(state, futureMessages, functions) async {
  try {
    final messages = await futureMessages;
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('callOpenAI');
    final result = await callable.call(<String, dynamic>{
      'messages': messages,
      'functions': functions,
    });
    final responseData = result.data;

    // Print the response data for debugging
    print('Response data: $responseData');

    return handleResponse(state, responseData);
  } catch (e) {
    if (e is FirebaseFunctionsException) {
      print('Firebase Functions error: ${e.code} - ${e.message}');
      print('Error details: ${e.details}');
    } else {
      print('Unexpected error: $e');
    }
    return null;
  }
}

String? handleResponse(state, Map<String, dynamic> responseData) {
  final List<dynamic> choices = responseData['choices'];
  print(responseData['choices'].runtimeType);
  print(choices.isNotEmpty);
  print(responseData['usage']);
  if (choices.isNotEmpty) {
    final Map<String, dynamic> message =
        Map<String, dynamic>.from(choices[0]['message']);
    if (message.containsKey('function_call')) {
      final Map<String, dynamic> functionCall =
          Map<String, dynamic>.from(message['function_call']);
      final String functionName = functionCall['name'];
      final Map<String, dynamic> arguments =
          Map<String, dynamic>.from(json.decode(functionCall['arguments']));
      print("functionName: $functionName");
      // Execute the corresponding function
      if (functionName == "generateNewSkills") {
        String skills = jsonEncode(arguments["skills"]);
        print(skills);
        return skills;
      } else if (functionName == "generateSkillEXP") {
        String exps = jsonEncode(arguments['exps']);
        print("EXP: $exps");
        return exps;
      }
    } else {
      // Handle regular assistant messages
      final String content = message['content'];
      print('Assistant: $content');
    }
  }
  return null;
}

// Hugging Face

Future<Map<String, dynamic>> rateSimilarity(
    String source_sentence, List<String> sentences) async {
  final String apiUrl =
      "https://api-inference.huggingface.co/models/sentence-transformers/roberta-base-nli-stsb-mean-tokens";
  final String apiToken = "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";

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Bearer $apiToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'inputs': {
        'source_sentence': source_sentence,
        'sentences': sentences,
      }
    }),
  );

  if (response.statusCode == 200) {
    // If the call to the API was successful, parse the JSON response
    return json.decode(response.body);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load similarity scores');
  }
}

// Deprecate

Set<String> generateSkillMessage(
    state, newSkill, levelUpSkillNames, levelUpSkillEXPs) {
  var messages = <String>{};

  if (!newSkill.isEmpty && !state.containSkillTitle(newSkill)) {
    state.addSkill(newSkill);
    messages.add("New Skill Acquired: $newSkill");
  }

  for (var i = 0; i < levelUpSkillNames.length; i++) {
    var name = levelUpSkillNames[i];
    int exp = levelUpSkillEXPs[i];
    var skill = state.getSkillByTitle(name);
    if (skill == null) return {"ERROR: Cannot find skill $name"};
    int newExp = skill.exp + exp;
    int cap = (100 * (skill.level * skill.level)).toInt();
    int newLevel = skill.level;
    while (newExp > cap) {
      newExp -= cap;
      newLevel++;
      cap = (100 * (newLevel * newLevel)).toInt();
    }
    state.setSkill(skill.id, name, newExp, newLevel);
    messages.add("$name + $exp");
  }

  return messages;
}
