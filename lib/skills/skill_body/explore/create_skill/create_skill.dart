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
  String? _path;
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
          path: _path ?? '',
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
        rank: 'Common',
        index: 0,
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
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text('Path'),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 50, 50, 50),
                        borderRadius: BorderRadius.circular(6)
                      ),
                      child: DropdownButton<String>(
                        dropdownColor: Theme.of(context).colorScheme.tertiary,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        value: _path,
                        hint: Text("Select a Path"),
                        items: state.paths.map((SkillPath path) {
                          print('path.id: ${path.id}');
                          return DropdownMenuItem<String>(
                            value: path.id,
                            child: Text(path.title),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _path = newValue ?? '';
                          });
                        },
                      ),
                    ),
                  ],
                ),
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
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(60, 30, 60, 30),
            child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
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
                      style: TextStyle(fontSize: 16,),
                    )),
          )
        ],
      ),
    );
  }
}
