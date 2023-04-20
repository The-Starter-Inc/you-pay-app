import 'package:flutter/material.dart';
import 'color_theme.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: AppColor.primaryColor,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                fontFamily: 'Pyidaungsu',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18),
            backgroundColor: AppColor.primaryColor,
            foregroundColor: Colors.black),
        unselectedWidgetColor: Colors.black54,
        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(selectedItemColor: Colors.black),
        fontFamily: 'Pyidaungsu',
        textTheme: ThemeData.light().textTheme,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(primary: AppColor.primaryColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black))),
        cardTheme: ThemeData.light().cardTheme,
        iconTheme: ThemeData.light().iconTheme,
        buttonBarTheme: ThemeData.light().buttonBarTheme,
        inputDecorationTheme: ThemeData.light().inputDecorationTheme,
        popupMenuTheme: ThemeData.light().popupMenuTheme,
        switchTheme: ThemeData.light().switchTheme,
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all(AppColor.primaryColor))),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColor.secondaryColor),
                foregroundColor:
                    MaterialStateProperty.all<Color>(AppColor.secondaryColor),
                textStyle: MaterialStateProperty.all(
                    const TextStyle(color: Colors.black)))),
        hintColor: Colors.grey,
        canvasColor: Colors.white,
        buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            buttonColor: AppColor.primaryColor));
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.grey.shade900,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
          titleTextStyle: const TextStyle(
              fontFamily: 'Pyidaungsu',
              fontWeight: FontWeight.bold,
              fontSize: 18),
          backgroundColor: Colors.grey.shade900),
      unselectedWidgetColor: Colors.grey.shade500,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.white,
      ),
      fontFamily: 'Pyidaungsu',
      colorScheme:
          ColorScheme.fromSwatch().copyWith(primary: Colors.grey.shade900),
      elevatedButtonTheme: ThemeData.dark().elevatedButtonTheme,
      textTheme: ThemeData.dark().textTheme,
      cardTheme: ThemeData.dark().cardTheme,
      iconTheme: ThemeData.dark().iconTheme,
      buttonBarTheme: ThemeData.dark().buttonBarTheme,
      inputDecorationTheme: ThemeData.dark().inputDecorationTheme,
      popupMenuTheme: ThemeData.dark().popupMenuTheme,
      switchTheme: ThemeData.dark().switchTheme,
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              backgroundColor: Colors.grey.shade900,
              foregroundColor: Colors.white)),
      hintColor: Colors.grey,
      cardColor: Colors.grey.shade900,
      canvasColor: Colors.black,
      buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.grey.shade700),
      dialogBackgroundColor: Colors.grey.shade900
    );
  }
}
