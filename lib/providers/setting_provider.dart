import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_voca/models/setting_model.dart';

class SettingProvider with ChangeNotifier {
  late Setting _setting;

  Setting get setting => _setting;

  SettingProvider() {
    loadSetting();
  }

  Future<void> loadSetting() async {
    final prefs = await SharedPreferences.getInstance();
    bool notificationEnabled = prefs.getBool('notificationEnabled') ?? true;
    String notificationFrequency = prefs.getString('notificationFrequency') ?? '30min';

    _setting = Setting(
      notificationEnabled: notificationEnabled,
      notificationFrequency: notificationFrequency,
    );
    notifyListeners();
  }

  Future<void> updateSetting(bool notificationEnabled, String notificationFrequency) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationEnabled', notificationEnabled);
    prefs.setString('notificationFrequency', notificationFrequency);

    _setting = Setting(notificationEnabled: notificationEnabled, notificationFrequency: notificationFrequency);
    notifyListeners();
  }
}