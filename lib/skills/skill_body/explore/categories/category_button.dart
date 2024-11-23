import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isSelected;

  const CategoryButton(
      {super.key, required this.title, required this.onPressed, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextButton(
        onPressed: onPressed,
        child: Text(title),
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? Colors.white : const Color.fromARGB(255, 40, 40, 40), // Set background color
          foregroundColor: isSelected ? Colors.black : Colors.white,
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          padding: EdgeInsets.fromLTRB(16, 6, 16, 6), // Set padding
          minimumSize: Size(0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0), // Set border radius
          ),
        ),
      ),
    );
  }
}
