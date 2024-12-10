import 'package:flutter/material.dart';
import 'package:my_voca/views/word_list_page.dart';
import 'package:my_voca/views/favorite_page.dart';
import 'package:my_voca/views/quiz_page.dart';
import 'package:my_voca/views/setting_page.dart';
import 'package:my_voca/views/search_page.dart';
import 'package:provider/provider.dart';
import 'package:my_voca/providers/word_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // WordProvider의 fetchWords를 호출하여 데이터를 로드
    Future.microtask(() {
      final wordProvider = Provider.of<WordProvider>(context, listen: false);
      wordProvider.fetchWords();
    });
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('테스트'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingPage()),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: '검색어 입력',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    if (_searchController.text.isNotEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              SearchPage(query: _searchController.text),
                        ),
                      );
                    }
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SearchPage(query: value),
                    ),
                  );
                }
              },
            ),
          ),
        ),
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
