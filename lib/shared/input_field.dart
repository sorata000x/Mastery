import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final int minLines;
  final int maxLines;
  final double height;
  final ValueChanged<String>? onChanged;

  const InputField({
    super.key,
    required this.label,
    this.minLines = 1,
    this.maxLines = 1,
    this.height = 45,
    this.onChanged = null,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4, 4, 8, 4),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            height: height,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: const Color.fromRGBO(45, 45, 45, 1),
            ),
            child: TextField(
              minLines: minLines,
              maxLines: maxLines,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
