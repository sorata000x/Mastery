import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/firestore.dart';
import 'package:skillborn/skills/skill_body/explore/categories/category_button.dart';
import 'package:skillborn/skills/skill_body/explore/explore.dart';
import 'package:skillborn/skills/skill_body/explore/explore_state.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ExploreState>(context);

    return Container(
      padding: EdgeInsets.only(left: 14),
      height: 36,
      child: (ListView.builder(
          itemCount: state.allCategories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
                child: CategoryButton(
              title: state.allCategories[index],
              onPressed: () => {state.setSelected(index)},
              isSelected: state.selected == index,
            ));
          })),
    );
  }
}
