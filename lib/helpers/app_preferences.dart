import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static const String _profileImagePathKey = 'profile_image_path';

  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
  }

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_seen') ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', value);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('logged_in') ?? false;
  }

  static Future<void> setProfileImagePath(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == null || value.trim().isEmpty) {
      await prefs.remove(_profileImagePathKey);
      return;
    }

    await prefs.setString(_profileImagePathKey, value);
  }

  static Future<String?> getProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileImagePathKey);
  }
}
