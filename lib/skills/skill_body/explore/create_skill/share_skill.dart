import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/skills/skill_body/explore/explore_state.dart';
import 'package:skillborn/skills/skill_icon.dart';

class ShareSkill extends StatefulWidget {
  final String type;
  final String name;
  final String author;
  final Function onSubmit;

  const ShareSkill(
      {super.key,
      required this.type,
      required this.name,
      required this.author,
      required this.onSubmit});

  @override
  State<ShareSkill> createState() => _ShareSkillState();
}

class _ShareSkillState extends State<ShareSkill> {
  bool _anonymous = false;
  bool _publishing = false;
  String _category = 'Other';

  @override
  Widget build(BuildContext context) {
    final exploreState = Provider.of<ExploreState>(context);

    return Container(
      padding: EdgeInsets.all(16),
      
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Share with",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          TextButton(
            onPressed: () => {
              setState(() => _publishing = false)
            },
            child: Row(
              children: [
                Icon(Icons.account_circle, size: 38,),
                SizedBox(width: 8),
                Text(
                  "Only Me",
                  style: TextStyle(fontSize: 18),
                ),
                Spacer(),
                Visibility(
                  visible: !_publishing, // Set to true or false to show/hide
                  child: Icon(Icons.check_circle),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => {
              setState(() => _publishing = true)
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: SvgPicture.asset(
                    height: 36,
                    width: 36,
                      'lib/assets/icons/explore.svg',
                      colorFilter: const ColorFilter.mode(
                        Color.fromARGB(255, 200, 200, 200), // Replace with your desired color
                        BlendMode
                            .srcIn, // This blend mode ensures the color is applied to the SVG
                      ),
                    ),
                ),
                SizedBox(width: 8),
                Text("Skill Store", style: TextStyle(fontSize: 18)),
                Spacer(),
                Visibility(
                  visible: _publishing, // Set to true or false to show/hide
                  child: Icon(Icons.check_circle),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
                "You will get 10% karma every time a user purchases this skill.", style: TextStyle(fontSize: 16, color: Colors.grey),),
          ),
          Offstage(
            offstage: !_publishing, // Set to true to hide, false to show
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Publish anonymously"),
                    Checkbox(
                        value: _anonymous,
                        onChanged: (value) => {
                              setState(() {
                                _anonymous = value ?? false;
                              })
                            })
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 70, 70, 70),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10), // Top left corner radius
                      topRight: Radius.circular(10), // Top right corner radius
                    ),
                  ),
                  child: Row(
                    children: [
                      SkillIcon(type: widget.type, size: 30,),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                          Text("by ${widget.author}"),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 70, 70, 70),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10), // Top left corner radius
                      bottomRight: Radius.circular(10), // Top right corner radius
                    ),
                  ),
                  child: Row(
                    children: [
                      Text("Category"),
                      Spacer(),
                      DropdownButton<String>(
                        value: _category, // Current selected value
                        hint: Text(
                            'Select an option'), // Placeholder when no value is selected
                        items: exploreState.selectableCategories
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _category = newValue ?? ""; // Update the selected value
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
          ),
          
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Center(
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(
                    onPressed: () => widget.onSubmit(_publishing, _category), child: Text('Save', style: TextStyle(fontSize: 18),)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
