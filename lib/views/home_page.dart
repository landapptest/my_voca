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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final wordProvider = Provider.of<WordProvider>(context, listen: false);
      wordProvider.fetchWords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Voca'),
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
                          builder: (context) => SearchPage(query: _searchController.text),
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
            _buildCardButton(
              context,
              title: '전체 단어장',
              icon: Icons.book,
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => WordListPage()),
                );
              },
            ),
            SizedBox(height: 24),
            _buildCardButton(
              context,
              title: '즐겨찾기',
              icon: Icons.favorite,
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FavoritePage()),
                );
              },
            ),
            SizedBox(height: 24),
            _buildCardButton(
              context,
              title: '퀴즈',
              icon: Icons.question_answer,
              color: Colors.purple,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => QuizPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardButton(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onPressed}) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
