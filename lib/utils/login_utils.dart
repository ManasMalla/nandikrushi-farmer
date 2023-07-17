import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension LoginUtils on BuildContext {
  Future<bool> get isReturningUser async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    log(sharedPreferences.getString('userID') ?? "");
    return sharedPreferences.getString('userID') != null &&
        (sharedPreferences.getString('userID')?.isNotEmpty ?? false);
  }

  Future<bool> setAsReturningUser(String uId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString('userID', uId);
  }
}

String capitalize(String str) {
  return str
      .split(' ')
      .map((word) => word.length > 1
          ? word.substring(0, 1).toUpperCase() + word.substring(1)
          : word.toUpperCase())
      .join(' ');
}
