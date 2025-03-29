import 'package:flutter/material.dart';
import 'package:gymbro/core/theme/app_colors.dart';

class AppTextStyles {
  static const String _fontFamily = 'Roboto';
  
  static const TextStyle robotoRegular = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
  );

  static const TextStyle robotoMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );
  
  static const TextStyle robotoSemiBold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static const TextStyle robotoBold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  );  
  
}