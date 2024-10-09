import 'package:flutter/material.dart';
import 'package:my_voca/views/word_list_page.dart';
import 'package:my_voca/views/favorite_page.dart';
import 'package:my_voca/views/quiz_page.dart';
import 'package:my_voca/views/setting_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('테스트'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
              icon: Icon(Icons.settings)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => WordListPage()),
                );
              },
              child: Text('전체 단어장'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FavoritePage()),
                );
              },
              child: Text('즐겨찾기'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => QuizPage()),
                );
              },
              child: Text('퀴즈'),
            ),
          ],
        ),
      ),
    );
  }
}
