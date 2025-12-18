import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF2196F3),
    primaryColorDark: Color(0xFF1976D2),
    primaryColorLight: Color(0xFFBBDEFB),
    accentColor: Color(0xFF4CAF50),
    backgroundColor: Color(0xFFF5F5F5),
    scaffoldBackgroundColor: Color(0xFFF5F5F5),
    cardColor: Colors.white,
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFF2196F3),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF2196F3),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF2196F3),
    primaryColorDark: Color(0xFF1976D2),
    primaryColorLight: Color(0xFFBBDEFB),
    accentColor: Color(0xFF4CAF50),
    backgroundColor: Color(0xFF121212),
    scaffoldBackgroundColor: Color(0xFF121212),
    cardColor: Color(0xFF1E1E1E),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white70,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFF2196F3),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF2196F3),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: TextStyle(color: Colors.white70),
      hintStyle: TextStyle(color: Colors.white54),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Color(0xFF1E1E1E),
    ),
  );
}