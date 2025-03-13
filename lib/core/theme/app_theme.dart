import 'package:flutter/material.dart';

class AppTheme {
  // Color scheme based on landing page
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color primaryDarkColor = Color(0xFF1B5E20);
  static const Color backgroundLightColor = Color(0xFFE8F5E9);
  static const Color textPrimaryColor = Color(0xFF424242);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color cardShadowColor = Colors.black26;

  // Add missing color constants
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFA000);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color accentColor = Color(0xFF00BCD4);

  // Light theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: primaryDarkColor,
      onSecondary: Colors.white,
      background: Colors.white,
      surface: Colors.white,
    ),

    // Typography
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.bold,
        color: primaryDarkColor,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: primaryDarkColor,
      ),
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: primaryDarkColor,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: primaryDarkColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: textPrimaryColor,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: textPrimaryColor,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: textSecondaryColor,
      ),
    ),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: primaryColor),
      titleTextStyle: TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),

    // Card theme
    cardTheme: CardTheme(
      elevation: 4,
      shadowColor: cardShadowColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
      ),
    ),

    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: textSecondaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      labelStyle: const TextStyle(color: textSecondaryColor),
      floatingLabelStyle: const TextStyle(color: primaryColor),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );

  // Dark theme - based on the light theme but with darker colors
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: Colors.lightGreen,
      surface: const Color(0xFF121212),
      background: const Color(0xFF121212),
    ),

    // Dark theme specific adjustments to match light theme feel
    cardTheme: CardTheme(
      elevation: 4,
      shadowColor: Colors.black45,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Keep button styles consistent with light theme
    elevatedButtonTheme: lightTheme.elevatedButtonTheme,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.lightGreen,
        side: const BorderSide(color: Colors.lightGreen),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Dark theme input decoration
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.lightGreen, width: 2),
      ),
    ),
  );
}
