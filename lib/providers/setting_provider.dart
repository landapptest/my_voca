import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_voca/models/setting_model.dart';
import 'package:my_voca/providers/word_provider.dart';
import 'package:my_voca/providers/notification_provider.dart';

class SettingProvider with ChangeNotifier {
  late Setting _setting;
  final NotificationService _notificationService = NotificationService();

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

    if (notificationEnabled) {
      _scheduleNotifications();
    }
    notifyListeners();
  }

  Future<void> updateSetting(bool notificationEnabled, String notificationFrequency) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationEnabled', notificationEnabled);
    prefs.setString('notificationFrequency', notificationFrequency);

    _setting = Setting(notificationEnabled: notificationEnabled, notificationFrequency: notificationFrequency);

    if (notificationEnabled) {
      _scheduleNotifications();
    } else {
      _notificationService.cancelAllNotifications();
    }
    notifyListeners();
  }

  void _scheduleNotifications() {
    Duration interval = _getNotificationInterval(_setting.notificationFrequency);

    WordProvider wordProvider = WordProvider();
    _notificationService.sendRandomWordNotification(wordProvider, interval);

  }

  Duration _getNotificationInterval(String frequency) {
    switch (frequency) {
      case '30min':
        return Duration(minutes: 30);
      case '1hour':
        return Duration(hours: 1);
      case '3hours':
        return Duration(hours: 3);
      default:
        return Duration(hours: 1);
    }
  }
}