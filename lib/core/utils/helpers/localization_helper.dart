import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/di/injector.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', 'US');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = sl<SharedPreferences>();
    final languageCode = prefs.getString('language_code') ?? 'en';
    final countryCode = prefs.getString('country_code') ?? 'US';
    _locale = Locale(languageCode, countryCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    final prefs = sl<SharedPreferences>();
    await prefs.setString('language_code', locale.languageCode);
    await prefs.setString('country_code', locale.countryCode ?? '');
    notifyListeners();
  }
}