import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skillcraft/services/firestore.dart';
import 'package:skillcraft/services/models.dart';

// Generate skill messages

final Map<String, dynamic> skillProperties = {
  "skills": {
    "type": "array",
    "items": {
      "type": "object",
      "properties": {
        "skill": {
          "type": "string",
          "description": "Skill name",
        },
        "exp": {"type": "number", "description": "Skill experience point"},
        "probability": {"type": "number", "description": "Probability of getting the skill (0-1)"}
      }
    },
    "description": "List of skills names and exps associate with task.",
  }
};

final Map<String, dynamic> parameters = {
  "type": "object",
  "properties": skillProperties,
  "required": ["skills"]
};

final List<Map<String, dynamic>> functions = [
  {"name": "parseSkills", "parameters": parameters}
];

Future<List<Map<String, dynamic>>> getTaskCompletionMessages(
    futureSkills, taskName) async {
  return [
    {"role": "user", "content": "Task: $taskName."}
  ];
}

Future<String?> callChatGPT(state, futureMessages, functions) async {
  final messages = await futureMessages;
  final String apiKey =
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
    final Map<String, dynamic> responseData = json.decode(response.body);
    print('Response body: ${response.body}');
    return await handleResponse(state, responseData);
  } else {
    print('Request failed with status: ${response.statusCode}.');
    print('Response body: ${response.body}');
  }
}

String? handleResponse(state, Map<String, dynamic> responseData) {
  final List<dynamic> choices = responseData['choices'];
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
        return skills;
      }
    } else {
      // Handle regular assistant messages
      final String content = message['content'];
      print('Assistant: $content');
    }
  }
}

// Deprecate

Set<String> generateSkillMessage(
    state, newSkill, levelUpSkillNames, levelUpSkillEXPs) {
  var messages = Set<String>();

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
    int cap = (100 * (skill.level ^ 2)).toInt();
    int newLevel = skill.level;
    while (newExp > cap) {
      newExp -= cap;
      newLevel++;
      cap = 100 * (newLevel ^ 2);
    }
    state.setSkill(skill.id, name, newExp, newLevel);
    messages.add("$name + $exp");
  }

  return messages;
}
