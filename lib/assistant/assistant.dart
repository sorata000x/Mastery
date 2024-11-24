import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/api/api.dart';
import 'package:skillborn/assistant/message_block.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:uuid/uuid.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  var agents = {
    "default": {
      "role": "system",
      "content": """
        You are a helpful assistant.
        If user want to create a quest line, call function startCreatingQuestLine.
        Else respond user with messages.
      """
    },
    "ql_introduction": {
      "role": "system",
      "content": """
        Your job is build the introduction to let the user know you are going to ask them questions (do not actually ask the questions). 
        Keep it concise and professional.
        Example:
        Let's start to create a quest line for you.
        First I will need to ask some questions.
        """
    },
    "ql_outline": {
      "role": "system",
      "content": """
        Your job is to create the outline of the quest line for the goal.
        Example
        1. Prepare Core Application Materials
        2. Self-Assessment and Career Planning
        3. Search and Apply for Jobs
        4. Network Effectively
        5. Increase Your Interview Opportunities
        6. Increase Your Hiring Opportunities
        7. Post-Interview Reflection and Continuous Improvement
        Do you want to change anything?
        Call `displayOutline`
        """
    },
    "ql_tasks": {
      "role": "system",
      "content": """
        Your job is to create a list of actionable tasks from the outline.
        Call `createTasks`
        """
    }
  };

  var qlPreliminary = [
    "What is your goal?",
    "Is there any detailed you would like you share about the goal? ",
    """"
    How detailed would you like this process to be? (Must Ask)
    - [Just the basics (few questions)]
    - [Moderate detail (some questions)]
    - [Very detailed]
    """
  ];

  var qlBasic = [
    "Clear Objective: Understand precisely what the user wants to achieve. The goal should be specific, measurable, achievable, relevant, and time-bound (SMART).",
  ];

  var qlVDetailed = [
    "Clear Objective: Understand precisely what the user wants to achieve. The goal should be specific, measurable, achievable, relevant, and time-bound (SMART).",
    "Success Criteria: Determine how success will be measured and what the end result should look like.",
    "Starting Point: Identify the customer's current state in relation to their goal, including existing skills, knowledge, and resources.",
    "Strengths and Weaknesses: Assess areas where the customer excels or may need additional support.",
    "Financial Resources: Know the budget or financial constraints the customer has.",
    "Time Availability: Understand how much time the customer can commit.",
    "Tools and Equipment: Identify any tools, technology, or equipment available to the customer.",
    "Time Constraints: Be aware of any deadlines or time-sensitive aspects.",
    "Legal or Regulatory Restrictions: Understand any compliance issues that may affect the action plan.",
    "Physical or Logistical Limitations: Consider any geographic, health, or logistical factors that could impact task execution.",
    "Personal Preferences: Acknowledge any preferred methods or approaches the customer has.",
    "Motivation Factors: Understand what motivates the customer to tailor tasks that keep them engaged.",
    "Existing Skills: Identify what the customer already knows and can do.",
    "Skill Gaps: Recognize areas where training or development is needed.",
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);

    Future callAgent(agent) async {
      void displayOutline(outline) {
        state.addMessage(
            'assistant', outline.map((e) => e.toString()).join('\n'));
        callAgent({
          "role": "system",
          "content": """
            Your job is to create a list of actionable tasks from the outline:
            $outline
            Example: 
            - Update your resume to reflect your most recent experiences and achievements.
            - Tailor your resume for specific industries or roles you’re targeting.
            - Write a generic cover letter template that can be customized for each job application.
            - Identify your skills, strengths, and areas for improvement.
            - Determine your career goals (short-term and long-term).
            - List industries, companies, or roles that align with your interests and skills.
            - etc
            Call function `displayTasks`
          """
        });
      }

      void displayTasks(tasks) {
        state.addMessage(
            'assistant', tasks.map((e) => e.toString()).join('\n'));
      }

      var messages = [
        state.conversation.map((m) => m.content).join('\n'),
        {
          "role": "system",
          "content":
              "Quest line is basically a plan, its for real life not for game or story."
        },
        {
          "role": "system",
          "content":
              "You are part of assistant team to help the user to create a quest line."
        },
        agent.toString()
      ];

      var result = await callChatGPT(messages, functions: [
        {
          "name": "displayOutline",
          "description": "Outline of the quest line to achieve the goal",
          "parameters": {
            "type": "object",
            "required": ["outline"],
            "properties": {
              "outline": {
                "type": "array",
                "description": "List of stages",
                "items": {
                  "type": "string",
                  "description": "A stage in the outline"
                }
              }
            },
            "additionalProperties": false
          }
        },
        {
          "name": "displayTasks",
          "description": "Tasks of quest line to achieve the goal",
          "parameters": {
            "type": "object",
            "required": ["tasks"],
            "properties": {
              "tasks": {
                "type": "array",
                "description": "List of task",
                "items": {"type": "string"}
              }
            },
            "additionalProperties": false
          }
        }
      ]);
      if (result == null) return;
      var functionCall;
      try {
        functionCall = jsonDecode(result);
      } catch (e) {
        functionCall = null;
      }
      if (functionCall != null && functionCall['name'] == 'displayOutline') {
        displayOutline(jsonDecode(functionCall['arguments'])['outline']);
      } else if (functionCall != null &&
          functionCall['name'] == 'displayTasks') {
        displayTasks(jsonDecode(functionCall['arguments'])['tasks']);
      } else {
        state.addMessage('assistant', result);
      }
    }

    void startCreatingQuestLine() {
      var newAgentQueue = [
        agents['ql_introduction']!,
        ...qlPreliminary.map((d) => {
              "role": "system",
              "content": """
            Ask this specific question if user haven't say or answer it yet:
            $d
            example: 
            What motivate you?
            - Exciting adventure and challenges
          """
            }),
        ...qlBasic.map((d) => {
              "role": "system",
              "content": """
            Identify the following element by asking one question (follow by options) based on user goal.
            $d
          """
            }),
        agents['ql_outline']!
      ];
      state.setAgentQueue(newAgentQueue.map((a) => Agent.fromJson(a)).toList());
      callAgent(state.agentQueue.removeAt(0));
    }

    void _sendMessage() async {
      if (_controller.text.isNotEmpty) {
        var input = _controller.text;
        _controller.clear();
        state.addMessage('user', input);

        // Instruction
        List messages;
        String? result;

        if (state.agentQueue.isNotEmpty) {
          callAgent(state.agentQueue.removeAt(0));
          return;
        }

        messages = [
          agents['default'],
          ...state.conversation.map((m) => m.toJson()),
          {"role": "user", "content": input}
        ];
        result = await callChatGPT(messages, functions: [
          {
            "name": "startCreatingQuestLine",
            "description":
                "Start creating a quest line for user to achieve their goal",
            "parameters": {
              "type": "object",
              "properties": {},
              "additionalProperties": false
            }
          }
        ]);
        if (result == null) return;
        var decoded;
        try {
          decoded = jsonDecode(result);
        } catch (e) {
          decoded = null;
        }
        if (decoded != null && decoded['name'] == "startCreatingQuestLine") {
          startCreatingQuestLine();
        } else {
          state.addMessage('assistant', result);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.conversation.length,
              itemBuilder: (context, index) {
                final message = state.conversation[index];
                final isUserMessage = message.role == 'user';
                if (isUserMessage) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: MessageBlock(message: message),
                  );
                }
                if (!message.content.startsWith('[System Message]')) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: MessageBlock(message: message),
                  );
                }
                return MessageBlock(message: message);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.primaryContainer,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: (value) => {_sendMessage()},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
