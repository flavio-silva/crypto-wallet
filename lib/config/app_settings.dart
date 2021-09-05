import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  late SharedPreferences _prefs;
  Map<String, String> _settings = {
    'locale': 'pt_BR',
    'currencySymbol': 'R\$',
  };

  UnmodifiableMapView<String, String> get settings =>
      UnmodifiableMapView(_settings);

  AppSettings() {
    _startSettings();
  }

  _startSettings() async {
    await _startPreferences();
    _readSettings();
  }

  _startPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  _readSettings() {
    _settings = {
      'locale': _prefs.getString('locale') ?? 'pt_BR',
      'currencySymbol': _prefs.getString('currencySymbol') ?? 'R\$',
    };

    notifyListeners();
  }

  setSettings({required String locale, required String currencySymbol}) async {
    await _prefs.setString('locale', locale);
    await _prefs.setString('currencySymbol', currencySymbol);

    _readSettings();
  }
}
