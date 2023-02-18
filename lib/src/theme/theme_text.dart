import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/size_constant.dart';
import 'color_theme.dart';

class ThemeText {
  const ThemeText._();

  static TextTheme get robotoTextTheme => GoogleFonts.robotoTextTheme();

  static TextStyle get _whiteHeadline6 => robotoTextTheme.titleLarge!.copyWith(
        fontSize: Sizes.dimen_20,
        color: Colors.white,
      );

  static TextStyle get whiteSubtitle1 => robotoTextTheme.titleMedium!.copyWith(
        fontSize: Sizes.dimen_16,
        color: Colors.white,
      );

  static TextStyle get whiteBodyText2 => robotoTextTheme.bodyMedium!.copyWith(
        color: Colors.white,
        fontSize: Sizes.dimen_14,
        wordSpacing: 0.25,
        letterSpacing: 0.25,
        height: 1.5,
      );

  static TextStyle get blackSubtitle1 => robotoTextTheme.titleMedium!.copyWith(
      fontSize: Sizes.dimen_16,
      color: Colors.black87,
      fontWeight: FontWeight.bold);

  static TextStyle get blackBodyText2 => robotoTextTheme.bodyMedium!.copyWith(
        color: Colors.black87,
        fontSize: Sizes.dimen_14,
        wordSpacing: 0.25,
        letterSpacing: 0.25,
        height: 1.5,
      );

  static TextStyle get newsItemTitle => robotoTextTheme.titleLarge!.copyWith(
      fontSize: Sizes.dimen_16,
      color: Colors.white,
      fontWeight: FontWeight.bold);

  static TextStyle get newsItemCreditAndTime =>
      robotoTextTheme.bodyMedium!.copyWith(
        fontSize: Sizes.dimen_12,
        color: Colors.white,
      );

  static TextStyle get versionText => robotoTextTheme.bodyMedium!.copyWith(
        fontSize: Sizes.dimen_12,
        color: Colors.black26,
      );

  static TextStyle get appbarTitle => robotoTextTheme.displayLarge!.copyWith(
      fontSize: Sizes.dimen_18,
      color: AppColor.primaryColor,
      fontWeight: FontWeight.bold);

  static TextStyle get textFieldLabel => robotoTextTheme.bodyMedium!.copyWith(
        fontSize: Sizes.dimen_14,
        color: Colors.black87,
      );

  static TextStyle get title =>
      robotoTextTheme.titleLarge!.copyWith(fontSize: Sizes.dimen_20);

  static getTextTheme() => TextTheme(
        titleLarge: _whiteHeadline6,
        titleMedium: whiteSubtitle1,
        bodyMedium: whiteBodyText2,
      );
}
