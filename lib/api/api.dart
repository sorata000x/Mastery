import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skillborn/services/firestore.dart';

// Generate skill messages

Future<List<Map<String, dynamic>>> getTaskCompletionMessages(
    futureSkills, taskName) async {
  return [
    {
      "role": "system",
      "content": "Translate skill names and description to task's language"
    },
    {"role": "user", "content": "Task: $taskName"}
  ];
}

Future<String?> callChatGPT(state, futureMessages, functions) async {
  final messages = await futureMessages;
  const String apiKey =
      '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'; // Replace with your API key
  final Uri url = Uri.parse('https://api.openai.com/v1/chat/completions');

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  final Map<String, dynamic> body = {
    "model": "gpt-4o-mini", // Use "gpt-4-0613" if you have access
    "messages": messages,
    "functions": functions,
    "function_call": {"name": "parseSkills"},
  };

  final http.Response response = await http.post(
    url,
    headers: headers,
    body: json.encode(body),
  );

  if (response.statusCode == 200) {
    final decodedResponse =
        utf8.decode(response.bodyBytes); // handle different languages
    final Map<String, dynamic> responseData = json.decode(decodedResponse);
    print('Response body: ${utf8.decode(response.bodyBytes)}');
    return handleResponse(state, responseData);
  } else {
    print('Request failed with status: ${response.statusCode}.');
    print('Response body: ${response.body}');
  }
  return null;
}

String? handleResponse(state, Map<String, dynamic> responseData) {
  final List<dynamic> choices = responseData['choices'];
  print(responseData['usage']);
  if (choices.isNotEmpty) {
    final Map<String, dynamic> message = choices[0]['message'];
    if (message.containsKey('function_call')) {
      final Map<String, dynamic> functionCall = message['function_call'];
      final String functionName = functionCall['name'];
      final Map<String, dynamic> arguments =
          json.decode(functionCall['arguments']);

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
