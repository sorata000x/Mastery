import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/api/api.dart';
import 'package:skillborn/assistant/assistant_drawer.dart';
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    var messages = state.currentConversation?.messages != null
        ? state.currentConversation!.messages
        : [
            {
              'sender': 'user',
              'text': 'test',
            }
          ];

    void _sendMessage() async {
      if (_controller.text.isNotEmpty) {
        var input = _controller.text;
        _controller.clear();
        var currentConversation = state.currentConversation;
        currentConversation ??= state.addConversation('');
        state.addMessage('user', input, currentConversation.id);
        var messages = [
          {"role": "system", "content": "You are a helpful assistant."},
          ...currentConversation.messages,
          {"role": "user", "content": input}
        ];
        var response = await callChatGPT(messages);
        if (response == null) return;
        state.addMessage('assistant', response, currentConversation.id);
        messages = [
          {
            "role": "system",
            "content":
                "Give short title for conversation from user input: ${input}"
          },
        ];
        response = await callChatGPT(messages);
        if (response == null) return;
        state.setConversationTitle(currentConversation.id, response);
      }
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.penToSquare),
            onPressed: () {
              state.currentConversation = null;
            },
          ),
        ],
      ),
      drawer: AssistantDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage = message['role'] == 'user';
                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color:
                          isUserMessage ? Colors.grey[800] : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message['content'] ?? '',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
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
                      fillColor: Colors.grey[800],
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
