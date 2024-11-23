import 'package:flutter/material.dart';

var appTheme = ThemeData(
    //fontFamily: GoogleFonts.nunito().fontFamily,
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Colors.black87,
    ),
    splashFactory: NoSplash.splashFactory,
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
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,  // Set brightness here
      primary: Colors.white,
      onPrimary: Colors.white,
      primaryContainer: Color.fromARGB(255, 45, 52, 60),
      secondary: Color.fromARGB(255, 26, 30, 35),
      onSecondary: Colors.white,
      tertiary: Color.fromARGB(255, 34, 39, 45),
      onTertiary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.black,
      onSurface: Colors.white,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.grey; // Checkbox is checked
        }
        return Colors.transparent; // Checkbox is unchecked
      }),
      checkColor: WidgetStateProperty.all(Colors.white), // Check mark color
      side: const BorderSide(color: Colors.grey), // The border color for the checkbox
    ),
);
