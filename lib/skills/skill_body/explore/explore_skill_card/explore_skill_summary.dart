import 'package:flutter/material.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/skills/skill_icon.dart';

class ExploreSkillSummary extends StatelessWidget {
  final Skill globalSkill;

  const ExploreSkillSummary({super.key, required this.globalSkill});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                SkillIcon(type: globalSkill.type),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        globalSkill.name,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        globalSkill.description,
                        style: TextStyle(fontSize: 14),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        ),
                      Text(
                        "by ${globalSkill.author}",
                        style: TextStyle(fontSize: 14, color: Colors.grey),),
                    ],
                  ),
                ),
              ],
            ),
          ),
          /*
          Positioned(
            bottom: 0,
            left: 0,
            child: CustomPaint(
              size: Size(24, 24), // Define the size of the triangle
              painter: TrianglePainter(), // Call the custom painter
            ),
          )
          */
        ],
      ),
    );
  }
}


// CustomPainter to draw the triangle
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(120, 211, 160, 32) // Set triangle color
      ..style = PaintingStyle.fill;
    double radius = 6.0;

    Path path = Path();
    // Start at the top-left corner (0, 0)
  path.moveTo(0, 0);
  
  // Draw line to the bottom-left corner with a rounded corner
  path.lineTo(0, size.height - radius); 
  path.arcToPoint(
    Offset(radius, size.height), // The next point after the arc
    radius: Radius.circular(radius), // The radius of the arc
    clockwise: false,
  );

  // Draw line to the bottom-right corner
  path.lineTo(size.width, size.height);
  
  // Draw line back to the top-left corner to complete the triangle
  path.lineTo(0, 0);

  // Close the path
  path.close();

    canvas.drawPath(path, paint); // Draw the triangle
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}