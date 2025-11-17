import 'package:flutter/material.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  static final Color _lightPrimaryColor = Colors.blue;
  static final Color _lightBackgroundColor = const Color(0xFFE0E0E0);
  static final Color _lightAccentColor = Colors.blue.shade400;
  static final Color _lightTextColor = Colors.black87;
  static final Color _lightHintTextColor = Colors.grey.shade600;
  static final Color _lightCardColor = const Color(0xFFE0E0E0);

  static final Color _darkPrimaryColor = Colors.blue.shade700;
  static final Color _darkBackgroundColor = const Color(0xFF212121);
  static final Color _darkAccentColor = Colors.blue.shade700;
  static final Color _darkTextColor = Colors.white;
  static final Color _darkHintTextColor = Colors.grey.shade500;
  static final Color _darkCardColor = const Color(0xFF303030);


  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light, // Explicitly set brightness
    scaffoldBackgroundColor: _lightBackgroundColor,
    primaryColor: _lightPrimaryColor,
    colorScheme: ColorScheme.light(
      primary: _lightPrimaryColor,
      secondary: _lightAccentColor,
      background: _lightBackgroundColor,
      surface: _lightCardColor,
      onBackground: _lightTextColor,
      error: Colors.red, // Define error color for light theme
    ),
    appBarTheme: AppBarTheme(
      color: _lightBackgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: _lightTextColor),
      titleTextStyle: TextStyle(
        color: _lightTextColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: _lightTextColor),
      bodyMedium: TextStyle(color: _lightTextColor),
      // Corrected: Button text should be visible on light buttons
      labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), 
      headlineSmall: TextStyle(color: _lightHintTextColor, fontSize: 16, fontWeight: FontWeight.w500)
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark, // Explicitly set brightness
    scaffoldBackgroundColor: _darkBackgroundColor,
    primaryColor: _darkPrimaryColor,
    colorScheme: ColorScheme.dark(
      primary: _darkPrimaryColor,
      secondary: _darkAccentColor,
      background: _darkBackgroundColor,
      surface: _darkCardColor,
      onBackground: _darkTextColor,
      error: Colors.red.shade300, // Define error color for dark theme
    ),
    appBarTheme: AppBarTheme(
      color: _darkBackgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: _darkTextColor),
      titleTextStyle: TextStyle(
        color: _darkTextColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: _darkTextColor),
      bodyMedium: TextStyle(color: _darkTextColor),
      labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: _darkHintTextColor, fontSize: 16, fontWeight: FontWeight.w500)
    ),
  );
}

