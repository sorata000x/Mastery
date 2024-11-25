import 'package:flutter/material.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/skills/skill_icon.dart';

class SkillSummary extends StatefulWidget {
  final UserSkill skill;

  const SkillSummary({super.key, required this.skill});

  @override
  State<SkillSummary> createState() => _SkillSummaryState();
}

class _SkillSummaryState extends State<SkillSummary> {
  var _showDescription = false;
  @override
  Widget build(BuildContext context) {
    var cap = 100 * (widget.skill.level * widget.skill.level);
    var percentage = widget.skill.exp / (cap == 0 ? 1 : cap);

    return Material(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300), // Animation duration
                curve: Curves.easeInOut, // Animation curve
        padding: const EdgeInsets.fromLTRB(10, 4, 20, 4),
        child: Column(children: [
          GestureDetector(
            onTap: () => {
              setState(() {
                _showDescription = !_showDescription;
              })
            },
            child: Row(
              children: [
                SkillIcon(type: widget.skill.type),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(widget.skill.name,
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Text(
                            "LV ${widget.skill.level}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3, bottom: 4),
                        child: LinearProgressIndicator(
                          color: Colors.blueGrey,
                          value: percentage,
                          minHeight: 5,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_showDescription)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.skill.description != ''
                  ? widget.skill.description
                  : '(No Description)'),
            )
        ]),
      ),
    );
  }
}
