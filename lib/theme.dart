import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var appTheme = ThemeData(
    fontFamily: GoogleFonts.nunito().fontFamily,
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Colors.black87,
    ),
    brightness: Brightness.dark,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
        ),
        foregroundColor: Colors.white, // Set the text color
      )
    ),
    buttonTheme: const ButtonThemeData(),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 18),
      bodyMedium: TextStyle(fontSize: 16),
      headlineLarge: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: Colors.grey,
      ),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.dark,  // Set brightness here
      primary: Colors.white,
      onPrimary: Colors.white,
      secondary: const Color.fromARGB(255, 50, 50, 50),
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.black,
      onSurface: Colors.white,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.grey; // Checkbox is checked
        }
        return Colors.transparent; // Checkbox is unchecked
      }),
      checkColor: MaterialStateProperty.all(Colors.white), // Check mark color
      side: BorderSide(color: Colors.grey), // The border color for the checkbox
    ),
);
