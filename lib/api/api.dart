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
Future<List<Map>?> generateSkillExpFromTask(state, task) async {
  var messages = [
    {
      "role": "system",
      "content": """
        The user is performing a task and has defined the following skills they want to prioritize: 
        [${state.skills.map((s) => """
        {
          name: ${s.name},
          description: ${s.description},
        }
        """)}]. 
        Assign experience points (XP) to each skill based on its relevance to the task. Skills not relevant to the task must be assigned 0 XP. 
        Distribute the total XP across relevant skills.
        
        Example:
        Task: Learn Python programming
        User's Skills: Problem-Solving, Debugging, Time Management
        Relevant EXP Allocation:
        - Problem-Solving: 50
        - Debugging: 40
        - Time Management: 0

        Response language: ${WidgetsBinding.instance.window.locale}
      """
    },
    {"role": "user", "content": "Task: ${task.title}, Skills: "}
  ];
  var properties = {};
  for (var skill in state.skills) {
    properties[skill.name] = {
      "type": "number",
      "description": skill.description
    };
  }
  var functions = [
    {
      "name": "generateSkillExpFromTask",
      "parameters": {
        "type": "object",
        "description":
            "Experience points for skills from completed task. 0 exp if skill not relevant to the task. Example exps: [10, 30, 50, 100, 0]",
        "properties": properties
      }
    }
  ];
  var result = await callChatGPT(messages, functions: functions);
  if (result == null) return null;
  final Map<String, dynamic> arguments =
      Map<String, dynamic>.from(json.decode(json.decode(result)['arguments']));
  List<Map> skillExps = [];

  for(var skill in state.skills) {
    skillExps.add({"skillId": skill.id, "exp": arguments[skill.name]});
  }

  return skillExps;
}

/// Generate skill exp with OpenAI API
/// Call when new skills added
Future<List<int>?> generateSkillExpForTasks(state, skill, tasks) async {
  var messages = [
    {
      "role": "system",
      "content": "Response language: ${WidgetsBinding.instance.window.locale}"
    },
    {
      "role": "user",
      "content": """Skill: 
        {
        name: ${skill.name},
        description: ${skill.description},
        cultivation: ${skill.cultivation},
      }
      , Tasks: ${tasks.map((t) => t.title)}"""
    }
  ];
  var functions = state.functions
      .where((f) => f["name"] == "generateSkillExpForTasks")
      .toList();
  var result = await callChatGPT(messages, functions: functions);
  if (result == null) return null;
  List<int> exps =
      (json.decode(result) as List<dynamic>).map((e) => e as int).toList();
  return exps;
}

/// Generate task tags and info with OpenAI API
Future<List<Map<String, dynamic>>?> generateNewSkills(state, taskTitle) async {
  // Make API call
  var messages = [
    {
      "role": "system",
      "content": "Response language: ${WidgetsBinding.instance.window.locale}"
    },
    {"role": "user", "content": "Task: $taskTitle"}
  ];
  var functions =
      state.functions.where((f) => f["name"] == "generateNewSkills").toList();
  var result = await callChatGPT(messages, functions: functions);
  // Return null if error
  if (result == null) return null;
  // Parse result
  var decodedResult = List<Map<String, dynamic>>.from(json.decode(result));
  return decodedResult;
}

/// Generate karma with OpenAI API
Future<int?> generateTaskExperience(state, taskTitle) async {
  // Make API call
  var messages = [
    {
      "role": "system",
      "content": "Response language: ${WidgetsBinding.instance.window.locale}"
    },
    {"role": "user", "content": "Task: $taskTitle"}
  ];
  var functions = state.functions
      .where((f) => f["name"] == "generateTaskExperience")
      .toList();
  var result = await callChatGPT(messages, functions: functions);
  // Return null if error
  if (result == null) return null;
  return json.decode(result);
}

// API Calls

Future<String?> callChatGPT(futureMessages, {functions, stream = false}) async {
  try {
    final messages = await futureMessages;
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('callOpenAI');
    final result = await callable.call(<String, dynamic>{
      'messages': messages,
      'functions': functions,
      'stream': stream
    });
    final responseData = result.data;

    // Print the response data for debugging
    debugPrint('Response data: $responseData');

    return handleResponse(responseData);
  } catch (e) {
    if (e is FirebaseFunctionsException) {
      debugPrint('Firebase Functions error: ${e.code} - ${e.message}');
      debugPrint('Error details: ${e.details}');
    } else {
      debugPrint('Unexpected error: $e');
    }
    return null;
  }
}

Map<String, dynamic>? getArgumentsFromResponse(
    Map<String, dynamic> responseData) {
  final List<dynamic> choices = responseData['choices'];
  if (choices.isNotEmpty) {
    final Map<String, dynamic> message =
        Map<String, dynamic>.from(choices[0]['message']);
    if (message.containsKey('function_call')) {
      final Map<String, dynamic> functionCall =
          Map<String, dynamic>.from(message['function_call']);
      final String functionName = functionCall['name'];
      debugPrint("Getting arguments from $functionName");
      final Map<String, dynamic> arguments =
          Map<String, dynamic>.from(json.decode(functionCall['arguments']));
      try {
        return arguments;
      } catch (e) {
        return null;
      }
    }
  }
}

String? handleResponse(Map<String, dynamic> responseData) {
  final List<dynamic> choices = responseData['choices'];
  if (choices.isNotEmpty) {
    final Map<String, dynamic> message =
        Map<String, dynamic>.from(choices[0]['message']);
    if (message.containsKey('function_call')) {
      final Map<String, dynamic> functionCall =
          Map<String, dynamic>.from(message['function_call']);
      final String functionName = functionCall['name'];
      final Map<String, dynamic> arguments =
          Map<String, dynamic>.from(json.decode(functionCall['arguments']));
      // Execute the corresponding function
      if (functionName == "generateNewSkills") {
        String skills = jsonEncode(arguments["skills"]);
        return skills;
      } else if (functionName == "generateSkillExpForTasks") {
        String exps = jsonEncode(arguments['exps']);
        return exps;
      } else if (functionName == "generateTaskExperience") {
        String exp = jsonEncode(arguments['exp']);
        return exp;
      } else if (functionName.isNotEmpty) {
        return jsonEncode(functionCall);
      }
    } else {
      // Handle regular assistant messages
      final String content = message['content'];
      return content;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.addSkill(newSkill);
    });
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.setSkill(skill.id, name, newExp, newLevel);
    });
    messages.add("$name + $exp");
  }

  return messages;
}
