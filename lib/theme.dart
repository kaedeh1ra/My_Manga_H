import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Все цвета для приложения уже прописаны здесь!!!
abstract class AppColors {
  static const backgroundLight = Color(0xFFEAE6DA);
  static const secondary = Color(0xFFAC91F7);
  static const accent = Color(0xFFC9F946);
  static const textDark = Color(0xFF53585A);
  static const textLigth = Color(0xFFF5F5F5);
  static const textFaded = Color(0xFF9899A5);
  static const iconLight = Color(0xFFB1B4C0);
  static const iconDark = Color(0xFFB1B3C1);
  static const textHighlight = secondary;
  static const cardLight = Color(0xFF121212);
  static const cardDark = Color(0xFF303334);
}

abstract class _LightColors {
  static const background = AppColors.backgroundLight;
  static const card = AppColors.cardLight;
}

abstract class _DarkColors {
  static const background = Color(0xFF121212);
  static const card = AppColors.cardDark;
}

/// Reference to the application theme.
abstract class AppTheme {
  static const accentColor = AppColors.accent;
  static final visualDensity = VisualDensity.adaptivePlatformDensity;

  /// Light theme and its settings.
  static ThemeData light() => ThemeData(
        brightness: Brightness.light,
        colorScheme:
            ColorScheme.light().copyWith(background: _LightColors.background),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.accent, // Цвет фона AppBar
          // foregroundColor: Colors.white, // Цвет текста и иконок AppBar
          // elevation: 4, // Тень AppBar
          // centerTitle: true, // Центрирование заголовка
          // titleTextStyle: TextStyle(
          //   fontSize: 20,
          //   fontWeight: FontWeight.bold,
          // ), // Стиль текста заголовка
          // iconTheme: IconThemeData(
          //   color: Colors.white, // Цвет иконок в AppBar
          // ),
          // // ... другие свойства AppBarTheme
        ),
        hintColor: accentColor,
        visualDensity: visualDensity,
        textTheme:
            GoogleFonts.mulishTextTheme().apply(bodyColor: AppColors.textDark),
        scaffoldBackgroundColor: _LightColors.background,
        cardColor: _LightColors.card,
        primaryTextTheme: const TextTheme(
          titleLarge: TextStyle(color: AppColors.textDark),
        ),
        iconTheme: const IconThemeData(color: AppColors.iconDark),
      );

  /// Dark theme and its settings.
  static ThemeData dark() => ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(backgroundColor: AppColors.secondary),
        hintColor: accentColor,
        visualDensity: visualDensity,
        colorScheme:
            ColorScheme.dark().copyWith(background: _DarkColors.background),
        textTheme:
            GoogleFonts.mulishTextTheme().apply(bodyColor: AppColors.textLigth),
        scaffoldBackgroundColor: _DarkColors.background,
        cardColor: _DarkColors.card,
        primaryTextTheme: const TextTheme(
          titleLarge: TextStyle(color: AppColors.textLigth),
        ),
        iconTheme: const IconThemeData(color: AppColors.iconLight),
      );
}
