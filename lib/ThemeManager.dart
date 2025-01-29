import 'package:flutter/material.dart';

import 'AppColors.dart';

class ThemeManager {
  static ThemeData get lightTheme => ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.scaffoldBackgroundLight,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.appBarBackgroundLight,
          foregroundColor: AppColors.buttonTextColor,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: AppColors.buttonTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: AppColors.buttonTextColor,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          hintStyle: TextStyle(color: AppColors.hintTextLight),
          labelStyle: TextStyle(color: AppColors.textPrimaryLight),
          filled: true,
          fillColor: AppColors.cardBackgroundLight,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.buttonTextColor,
            elevation: 4,
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
        cardTheme: CardTheme(
          color: AppColors.cardBackgroundLight,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(8),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: 14,
          ),
          titleLarge: TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: AppColors.iconColorLight,
          size: 24,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.buttonTextColor,
          elevation: 6,
        ),
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          checkColor: WidgetStateProperty.all(AppColors.buttonTextColor),
          fillColor: WidgetStateProperty.all(AppColors.primary),
        ),
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.all(AppColors.primary),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: AppColors.primary,
          inactiveTrackColor: AppColors.primaryLight,
          thumbColor: AppColors.primary,
          overlayColor: AppColors.primaryLight.withAlpha(51),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.hintTextLight,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData.dark().copyWith(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.scaffoldBackgroundDark,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.iconColorDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          hintStyle: TextStyle(color: AppColors.hintTextDark),
          labelStyle: TextStyle(color: AppColors.textPrimaryDark),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.buttonTextColor,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            inherit: true, // Ensure consistency
            color: AppColors.textPrimaryDark,
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            inherit: true, // Ensure consistency
            color: AppColors.textSecondaryDark,
            fontSize: 14,
          ),
          titleLarge: TextStyle(
            inherit: true, // Ensure consistency
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.appBarBackgroundDark,
          foregroundColor: AppColors.buttonTextColor,
          elevation: 0,
        ),
        cardColor: AppColors.cardBackgroundDark,
        iconTheme: IconThemeData(
          color: AppColors.iconColorDark,
        ),
      );
}
