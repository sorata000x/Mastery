import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skillborn/services/firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

// Generate skill messages

Future<List<Map<String, dynamic>>> getTaskCompletionMessages(
    futureSkills, taskName, language) async {
  return [
    {
      "role": "system",
      "content": "Response language: $language"
    },
    {"role": "user", "content": "Task: $taskName"}
  ];
}

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
    final Map<String, dynamic> message = Map<String, dynamic>.from(choices[0]['message']);
    if (message.containsKey('function_call')) {
      final Map<String, dynamic> functionCall = Map<String, dynamic>.from(message['function_call']);
      final String functionName = functionCall['name'];
      final Map<String, dynamic> arguments = Map<String, dynamic>.from(json.decode(functionCall['arguments']));
      // Execute the corresponding function
      if (functionName == "parseSkills") {
        String skills = jsonEncode(arguments["skills"]);
        print(skills);
        return skills;
      }
    } else {
      // Handle regular assistant messages
      final String content = message['content'];
      print('Assistant: $content');
    }
  }
  return null;
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
