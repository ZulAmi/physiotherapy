import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en', 'US');

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'en';
    final countryCode = prefs.getString('countryCode') ?? 'US';

    setLocale(Locale(languageCode, countryCode));
  }

  Future<void> setLocale(Locale locale) async {
    if (_currentLocale == locale) return;

    _currentLocale = locale;

    // Save to preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    await prefs.setString('countryCode', locale.countryCode ?? '');

    notifyListeners();
  }

  bool get isEnglish => _currentLocale.languageCode == 'en';

  // Helper method for language switching
  Future<void> toggleLanguage() async {
    if (isEnglish) {
      await setLocale(const Locale('ja', 'JP'));
    } else {
      await setLocale(const Locale('en', 'US'));
    }
  }
}
