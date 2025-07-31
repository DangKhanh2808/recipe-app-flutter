import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (Yellow/Gold/Brown Tones)
  static const Color primary50 = Color(0xFFFDFEE8);
  static const Color primary100 = Color(0xFFFCFFC2);
  static const Color primary200 = Color(0xFFFCFF87);
  static const Color primary300 = Color(0xFFFFFC43);
  static const Color primary400 = Color(0xFFFFEE0A);
  static const Color primary500 = Color(0xFFEFD503);
  static const Color primary600 = Color(0xFFCEA700);
  static const Color primary700 = Color(0xFFA47804);
  static const Color primary800 = Color(0xFF885D0B);
  static const Color primary900 = Color(0xFF734C10);
  static const Color primary950 = Color(0xFF432805);

  // Secondary Colors (Blue Tones)
  static const Color secondary50 = Color(0xFFE9F9FF);
  static const Color secondary100 = Color(0xFFCEF0FF);
  static const Color secondary200 = Color(0xFFA7E6FF);
  static const Color secondary300 = Color(0xFF6BDBFF);
  static const Color secondary400 = Color(0xFF26C2FF);
  static const Color secondary500 = Color(0xFF009AFF);
  static const Color secondary600 = Color(0xFF0070FF);
  static const Color secondary700 = Color(0xFF0055FF);
  static const Color secondary800 = Color(0xFF0048E6);
  static const Color secondary900 = Color(0xFF0043B3);
  static const Color secondary950 = Color(0xFF002D73);

  // Neutral Colors (Grey Tones)
  static const Color neutral50 = Color(0xFFF8F8F8);
  static const Color neutral100 = Color(0xFFF1EFEF);
  static const Color neutral200 = Color(0xFFE5E3E3);
  static const Color neutral300 = Color(0xFFD3CECE);
  static const Color neutral400 = Color(0xFFB8B1B1);
  static const Color neutral500 = Color(0xFF9E9595);
  static const Color neutral600 = Color(0xFF898080);
  static const Color neutral700 = Color(0xFF6E6767);
  static const Color neutral800 = Color(0xFF5D5757);
  static const Color neutral900 = Color(0xFF504C4C);
  static const Color neutral950 = Color(0xFF292626);

  // Material Color Schemes
  static const MaterialColor primarySwatch = MaterialColor(
    0xFFEFD503, // primary500
    <int, Color>{
      50: primary50,
      100: primary100,
      200: primary200,
      300: primary300,
      400: primary400,
      500: primary500,
      600: primary600,
      700: primary700,
      800: primary800,
      900: primary900,
    },
  );

  static const MaterialColor secondarySwatch = MaterialColor(
    0xFF009AFF, // secondary500
    <int, Color>{
      50: secondary50,
      100: secondary100,
      200: secondary200,
      300: secondary300,
      400: secondary400,
      500: secondary500,
      600: secondary600,
      700: secondary700,
      800: secondary800,
      900: secondary900,
    },
  );

  // Common Color Combinations
  static const Color background = neutral50;
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = primary500;
  static const Color info = secondary500;

  // Text Colors
  static const Color textPrimary = neutral900;
  static const Color textSecondary = neutral600;
  static const Color textTertiary = neutral400;
  static const Color textInverse = Colors.white;

  // Border Colors
  static const Color borderLight = neutral200;
  static const Color borderMedium = neutral300;
  static const Color borderDark = neutral400;

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
} 