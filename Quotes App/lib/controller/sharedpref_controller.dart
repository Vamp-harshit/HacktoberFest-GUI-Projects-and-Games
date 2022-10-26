import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefController {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return json.decode(prefs.getString(key)!);
    }
    else {
      return null;
    }
  }

  Future<bool> contains(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}