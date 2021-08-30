import 'package:shared_preferences/shared_preferences.dart';

int isDarkMode;
Future<int> isDark() async {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  final SharedPreferences prefsData = await prefs;
  isDarkMode = prefsData.getInt('isDarkMode') == null
      ? 0
      : prefsData.getInt('isDarkMode');
  return isDarkMode;
}
