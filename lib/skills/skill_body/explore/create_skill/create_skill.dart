import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/shared/input_field.dart';
import 'package:skillborn/skills/skill_body/explore/create_skill/share_skill.dart';
import 'package:skillborn/skills/skill_body/explore/explore_state.dart';
import 'package:uuid/uuid.dart';

class CreateSkill extends StatefulWidget {
  const CreateSkill({super.key});

  @override
  State<CreateSkill> createState() => _CreateSkillState();
}

class _CreateSkillState extends State<CreateSkill> {
  String _name = '';
  String _path = '';
  String _description = '';
  String _effect = '';
  String _cultivation = '';

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);

    void _submitForm(_publishing, _category) {
      final createdSkill = Skill(
          id: const Uuid().v4(),
          name: _name,
          path: _path,
          description: _description,
          effect: _effect,
          cultivation: _cultivation,
          type: 'other',
          category: _category,
          author: 'Unknown',
          rank: 'Common');
      state.setSkill(
        Uuid().v4(),
        name: _name,
        path: _path,
        description: _description,
        type: 'other',
        category: _category,
        author: 'Unknown',
        rank: 'Common'
      );
      state.addCreatedSkill(createdSkill);
      if (_publishing) {
        state.publishSkill(createdSkill);
      }
      // Complete create
      Navigator.pop(context);
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Create"),
      ),
      body: ListView(
        children: [
          IconButton(
              onPressed: () => {},
              icon: Icon(
                Icons.star,
                size: 60,
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputField(
                label: "Name",
                onChanged: (value) => {setState(() => _name = value)},
              ),
              SizedBox(
                height: 10,
              ),
              InputField(
                label: "Path",
                onChanged: (value) => {setState(() => _path = value)},
              ),
              SizedBox(
                height: 10,
              ),
              InputField(
                label: "Description",
                maxLines: 10,
                height: 149,
                onChanged: (value) => {setState(() => _description = value)},
              ),
              SizedBox(
                height: 10,
              ),
              InputField(
                label: "Effect",
                maxLines: 10,
                height: 98,
                onChanged: (value) => {setState(() => _effect = value)},
              ),
              SizedBox(
                height: 10,
              ),
              InputField(
                label: "Cultivation",
                maxLines: 10,
                height: 98,
                onChanged: (value) => {setState(() => _cultivation = value)},
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(60, 30, 60, 30),
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 100, 100, 100),
                    borderRadius: BorderRadius.circular(5)),
                child: TextButton(
                    onPressed: () => {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return ChangeNotifierProvider(
                                create: (_) => ExploreState(),
                                child: ShareSkill(
                                  type: 'other',
                                  name: _name,
                                  author: 'anonymous',
                                  onSubmit: _submitForm,
                                ),
                              );
                            },
                          )
                        },
                    child: Text(
                      "Create",
                      style: TextStyle(fontSize: 16),
                    ))),
          )
        ],
      ),
    );
  }
}
