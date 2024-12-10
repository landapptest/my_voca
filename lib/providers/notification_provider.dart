import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_voca/models/word_model.dart';
import 'package:my_voca/providers/word_provider.dart';

class NotificationProvider {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationProvider() {
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void scheduleNotification(String title, String body, Duration interval) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    _flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      title,
      body,
      RepeatInterval.everyMinute,
      platformChannelSpecifics,
    );
  }

  void cancelAllNotifications() {
    _flutterLocalNotificationsPlugin.cancelAll();
  }

  void sendRandomWordNotification(List<Word> favoriteWords, Duration interval) {
    if (favoriteWords.isNotEmpty) {
      Word randomWord = favoriteWords[Random().nextInt(favoriteWords.length)];
      scheduleNotification("오늘의 단어", "${randomWord.eng}: ${randomWord.kor}", interval);
    }
  }

  // 여기 추가
  void sendImmediateNotification(String title, String body) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
