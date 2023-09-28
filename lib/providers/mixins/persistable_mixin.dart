import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

mixin Persistable {
  Future<Map<String, dynamic>?> loadFromStorage(String storageKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? json = prefs.getString(storageKey);
    if (json != null) {
      return jsonDecode(json) as Map<String, dynamic>;
    }
    return null;
  }

  Future<bool> persistJSON(String storageKey, Map<String, dynamic> json) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String stringifiedJson = jsonEncode(json);
    return prefs.setString(storageKey, stringifiedJson);
  }
}
