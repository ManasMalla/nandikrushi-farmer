import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension DarkMode on BuildContext {
  bool get isDarkMode =>
      MediaQuery.of(this).platformBrightness == Brightness.dark;
}

Future<MapEntry<String, Color>> getAppTheme() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var appTheme = sharedPreferences.getString('user_app_theme') ??
      jsonEncode({"": const Color(0xFF006838).value});
  var decodedJson = Map<String, int>.from(jsonDecode(appTheme));
  MapEntry<String, Color> decodedJSON = {
    decodedJson.keys.first.toString(): Color(decodedJson.values.first)
  }.entries.first;
  return decodedJSON;
}

Future<MapEntry<String, String>> getAppLanguage() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var appLanguage = sharedPreferences.getString('user_app_language') ??
      jsonEncode({"english": "English".toUpperCase()});
  return jsonDecode(appLanguage);
}

Future<void> setAppTheme(MapEntry<String, Color> _) async {
  Map<String, int> entry = {_.key: _.value.value};
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setString(
    "user_app_theme",
    jsonEncode(
      entry,
    ),
  );
}

Future<void> setUserLanguage(MapEntry<String, int> _) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setString(
    "user_app_language",
    jsonEncode(
      Map.fromEntries([_]),
    ),
  );
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

num calculateContrast(Color backgroundColor, Color foregroundColor) {
  final backgroundLuminance = backgroundColor.computeLuminance();
  final foregroundLuminance = foregroundColor.computeLuminance();

  final lighterColorLuminance = backgroundLuminance > foregroundLuminance
      ? backgroundLuminance
      : foregroundLuminance;
  final darkerColorLuminance = backgroundLuminance < foregroundLuminance
      ? backgroundLuminance
      : foregroundLuminance;

  final opacityUnawareContrast =
      (lighterColorLuminance + 0.05) / (darkerColorLuminance + 0.05);
  return opacityUnawareContrast *
      foregroundColor.opacity *
      backgroundColor.opacity;
}
