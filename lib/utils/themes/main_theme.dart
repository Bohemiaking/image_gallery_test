import 'package:flutter/material.dart';

// here to manage theme of application
class AppMainTheme {
  static ThemeData get themeData => ThemeData(
      useMaterial3: false,
      cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(5)),
          color: Colors.grey.shade200,
          elevation: 0,
          margin: const EdgeInsets.all(0)),
      searchBarTheme: SearchBarThemeData(
          hintStyle:
              WidgetStatePropertyAll(TextStyle(color: Colors.grey.shade600))));
}
