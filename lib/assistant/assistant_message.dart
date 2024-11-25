import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';

class AssistantMessage extends StatelessWidget {
  final Message message;
  final bool isLast;

  const AssistantMessage(
      {super.key, required this.message, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    var functions = {
      'startTutorial': () {
        state.addMessage('user', 'Tutorial');
        state.addMessage('assistant',
            "When you complete a task, you will receive experience points for relevant skills and Karma — the currency you can use to buy or create new skills.\n\nSince you don’t have any skills yet, you will have 1000 Karma to start with, so you can get some skills.\n\nTo buy or create skills, you can either go to Explore Skills or ask me to recommend skills.");
        state.setOptions([
          Option(text: 'What is Karma?', function: 'explainKarma'),
          Option(text: "What are Skills?", function: 'explainSkills'),
          Option(
              text: "What are Lists and Paths?", function: 'explainListsPaths')
        ]);
      },
      'explainKarma': () {
        state.addMessage('user', 'What is Karma?');
        state.addMessage('assistant',
            "Karma originally means the effect cause by the action of a person, in Mastery it is proportional to the tasks you completed and the skills you have.\n\nThe more skills you have that are relevant to the task and the more advanced they are, you gets more Karma when you complete your tasks. So you would not only want to get more skills but also complete tasks that are relevant to the skills you have.");
        state.setOptions([
          ...state.options.where((option) => option.function != 'explainKarma')
        ]);
      },
      'explainSkills': () {
        state.addMessage('user', 'What are Skills?');
        state.addMessage('assistant',
            "Skills in Mastery allow you to track your real life skills, as the more you practice something the better you will be, the more relevant tasks you completed the more advanced your skills will become. ");
        state.setOptions([
          ...state.options.where((option) => option.function != 'explainSkills')
        ]);
      },
      'explainListsPaths': () {
        state.addMessage('user', 'What are Lists and Paths?');
        state.addMessage('assistant',
            "List let you categorize different tasks, the task created under the list will belong to the list. you can create the list you want from the 三 icon on the top left corner of the task page or simply ask me to do it for you.\n\nPath is a focused, disciplined pursuit of mastery. It is a collection of skills that center around the theme that you choose.\n\nFor instance, the Path of Engineering might includes the skills: Mathematic Mastery, Programming, Problem-Solving.\n\nThere is no rule to what skill you can add to a Path, a skill can belong to multiple path or no path at all. It’s up to you to decide and create your own Paths.");
        state.setOptions([
          ...state.options
              .where((option) => option.function != 'explainListsPaths')
        ]);
      }
    };

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            message.content,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 20,
          ),
          if (isLast)
            ...state.options.map((option) => Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        180, 96, 125, 139), // Background color
                    foregroundColor: Colors.white, // Text color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12), // Padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  onPressed: () => {
                        if (functions[option.function] != null)
                          functions[option.function]!()
                      },
                  child: Text(option.text)),
            ))
        ],
      ),
    );
  }
}
