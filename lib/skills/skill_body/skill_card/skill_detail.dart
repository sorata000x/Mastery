import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/skills/skill_body/skill_card/skill_summary.dart';

class SkillDetail extends StatefulWidget {
  final UserSkill skill;

  const SkillDetail({super.key, required this.skill});

  @override
  State<SkillDetail> createState() => _SkillDetailState();
}

class _SkillDetailState extends State<SkillDetail> {
  var isEditing = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.skill.description; // Set initial value
  }

  @override
  Widget build(BuildContext context) {
    var cap = 100 * (widget.skill.level * widget.skill.level);
    var percentage = widget.skill.exp / (cap == 0 ? 1 : cap);
    final state = Provider.of<MainState>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Material(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SkillSummary(skill: widget.skill),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              if (isEditing) {
                                state.setSkill(widget.skill.id,
                                    description: _controller.text);
                              }
                              setState(() {
                                isEditing = !isEditing;
                              });
                            },
                            icon: isEditing
                                ? Icon(Icons.check)
                                : Icon(Icons.edit))
                      ],
                    ),
                    isEditing
                        ? TextField(
                            maxLines: null,
                            //keyboardType: TextInputType.multiline,
                            controller: _controller,
                            onChanged: (value) {
                              _controller.text = value;
                            },
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero, 
                              hintText: "Enter desceiption",
                            ),
                          )
                        : Text(
                          _controller.text,
                          style: TextStyle(
                              fontSize: 16,
                            ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
