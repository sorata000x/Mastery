import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';

class UserRank extends StatelessWidget {
  const UserRank({super.key});

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);

    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 1),
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'lib/assets/icons/ranks/beginner.svg',
                    colorFilter: const ColorFilter.mode(
                      Colors.white, // Replace with your desired color
                      BlendMode
                          .srcIn, // This blend mode ensures the color is applied to the SVG
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    value: mainState.exp / mainState.getMaxExp(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 5),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mainState.getRank(),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 4,
              ),
              Text("${mainState.getMaxExp() - mainState.exp} more exp to reach ${mainState.getNextRank()}")
            ],
          ))
        ],
      ),
    );
  }
}
