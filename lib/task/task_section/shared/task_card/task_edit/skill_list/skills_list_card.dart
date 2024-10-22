import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';

class SkillsListCard extends StatelessWidget {
  final Task task;
  final Skill skill;

  const SkillsListCard({super.key, required this.task, required this.skill});

  void showDeleteSkillOptions(context) async {
    final state = Provider.of<MainState>(context, listen: false);
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
              "Do you want to remove the skill\n '${skill.name}' from link?"),
          actions: <Widget>[
            Row(
              children: <Widget>[
                // Expanded for No button to take half width
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('No'),
                  ),
                ),
                // Expanded for Yes button to take half width
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        state.setTask(Task(
                          id: task.id,
                          title: task.title,
                          note: task.note,
                          skillExps: [
                            ...?task.skillExps
                                ?.where((s) => s['skillId'] != skill.id)
                          ],
                          index: task.index,
                          isCompleted: task.isCompleted,
                        ));
                      });
                    },
                    child: Text('Remove'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(45, 45, 45, 1),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: GestureDetector(
        onTap: () => showDeleteSkillOptions(context),
        child: Row(children: [
          const Icon(
            FontAwesomeIcons.bolt,
            size: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 14),
          Text(skill.name),
        ]),
      ),
    );
  }
}
