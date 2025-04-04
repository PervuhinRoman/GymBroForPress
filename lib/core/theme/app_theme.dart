import 'package:flutter/material.dart';
import 'package:gymbro/core/theme/app_colors.dart';
import 'package:gymbro/core/theme/text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.greenPrimary,
        secondary: AppColors.greenSecondary,
        surface: AppColors.background,
        error: AppColors.constantError,
        onPrimary: Colors.white,
        onSecondary: AppColors.primaryText,
        onSurface: AppColors.primaryText,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.greenPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.robotoBold.copyWith(fontSize: 32),
        displayMedium: AppTextStyles.robotoBold.copyWith(fontSize: 28),
        displaySmall: AppTextStyles.robotoBold.copyWith(fontSize: 24),
        headlineLarge: AppTextStyles.robotoSemiBold.copyWith(fontSize: 22),
        headlineMedium: AppTextStyles.robotoSemiBold.copyWith(fontSize: 20),
        headlineSmall: AppTextStyles.robotoSemiBold.copyWith(fontSize: 18),
        titleLarge: AppTextStyles.robotoMedium.copyWith(fontSize: 18),
        titleMedium: AppTextStyles.robotoMedium.copyWith(fontSize: 16),
        titleSmall: AppTextStyles.robotoMedium.copyWith(fontSize: 14),
        bodyLarge: AppTextStyles.robotoRegular.copyWith(fontSize: 16),
        bodyMedium: AppTextStyles.robotoRegular.copyWith(fontSize: 14),
        bodySmall: AppTextStyles.robotoRegular.copyWith(fontSize: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greenPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.violetPrimary,
        secondary: AppColors.violetSecondary,
        surface: const Color(0xFF2C2C2C),
        error: AppColors.constantError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.violetPrimary, 
        // backgroundColor: Color(0xFF2C2C2C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.robotoBold.copyWith(
          fontSize: 32,
          color: Colors.white,
        ),
        displayMedium: AppTextStyles.robotoBold.copyWith(
          fontSize: 28,
          color: Colors.white,
        ),
        displaySmall: AppTextStyles.robotoBold.copyWith(
          fontSize: 24,
          color: Colors.white,
        ),
        headlineLarge: AppTextStyles.robotoSemiBold.copyWith(
          fontSize: 22,
          color: Colors.white,
        ),
        headlineMedium: AppTextStyles.robotoSemiBold.copyWith(
          fontSize: 20,
          color: Colors.white,
        ),
        headlineSmall: AppTextStyles.robotoSemiBold.copyWith(
          fontSize: 18,
          color: Colors.white,
        ),
        titleLarge: AppTextStyles.robotoMedium.copyWith(
          fontSize: 18,
          color: Colors.white,
        ),
        titleMedium: AppTextStyles.robotoMedium.copyWith(
          fontSize: 16,
          color: Colors.white,
        ),
        titleSmall: AppTextStyles.robotoMedium.copyWith(
          fontSize: 14,
          color: Colors.white,
        ),
        bodyLarge: AppTextStyles.robotoRegular.copyWith(
          fontSize: 16,
          color: Colors.white,
        ),
        bodyMedium: AppTextStyles.robotoRegular.copyWith(
          fontSize: 14,
          color: Colors.white,
        ),
        bodySmall: AppTextStyles.robotoRegular.copyWith(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.violetPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF2C2C2C),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
