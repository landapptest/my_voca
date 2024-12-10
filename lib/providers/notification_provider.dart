import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_voca/models/word_model.dart';

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
    InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

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

  void cancelAllNotifications() {
    _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> sendRandomWordNotification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("Error: User is not logged in");
      return;
    }

    final DatabaseReference userWordsRef =
    FirebaseDatabase.instance.ref('users/${user.uid}/words');

    try {
      final snapshot = await userWordsRef.get();
      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        List<Word> favoriteWords = data.entries
            .map((entry) {
          final wordData = Map<String, dynamic>.from(entry.value as Map);
          return Word.fromMap(entry.key, wordData);
        })
            .where((word) => word.isFavorite)
            .toList();

        if (favoriteWords.isNotEmpty) {
          Word randomWord =
          favoriteWords[Random().nextInt(favoriteWords.length)];
          sendImmediateNotification(
            "오늘의 단어",
            "${randomWord.eng}: ${randomWord.kor}",
          );
        } else {
          print("즐겨찾기 단어가 없습니다.");
        }
      } else {
        print("No words found in Firebase.");
      }
    } catch (e) {
      print("Failed to fetch words from Firebase: $e");
    }
  }
}
