import 'dart:convert';
import 'dart:io';

class FixtureLoader {
  const FixtureLoader._();

  static String loadText(String path) {
    return File(path).readAsStringSync();
  }

  static Map<String, dynamic> loadJsonObject(String path) {
    return jsonDecode(loadText(path)) as Map<String, dynamic>;
  }
}
