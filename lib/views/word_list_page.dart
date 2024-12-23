import 'package:flutter/material.dart';
import 'package:my_voca/models/word_model.dart';
import 'package:provider/provider.dart';
import 'package:my_voca/providers/word_provider.dart';

class WordListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wordProvider = Provider.of<WordProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('전체 단어장'),
        actions: [
          IconButton(
            onPressed: () {
              _showAddWordDialog(context);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: wordProvider.words.length,
        itemBuilder: (context, index) {
          final word = wordProvider.words[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // 카드 간의 여백
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              title: Text(
                word.eng,
                style: TextStyle(
                  fontSize: 22, // 단어 텍스트 크기 조정
                  fontWeight: FontWeight.bold, // 굵은 글씨
                ),
              ),
              subtitle: Text(
                word.kor,
                style: TextStyle(
                  fontSize: 16, // 뜻 텍스트 크기 조정
                  color: Colors.grey[600], // 색상 조정
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  word.isFavorite ? Icons.star : Icons.star_border,
                  color: Colors.yellow, // 스타 아이콘 색상
                ),
                onPressed: () {
                  wordProvider.toggleFavorite(word);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddWordDialog(BuildContext context) {
    String eng = '';
    String kor = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('단어 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: '단어'),
                onChanged: (value) {
                  eng = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: '뜻'),
                onChanged: (value) {
                  kor = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                if (eng.isNotEmpty && kor.isNotEmpty) {
                  Provider.of<WordProvider>(context, listen: false)
                      .addWord(eng, kor);
                  Navigator.of(context).pop();
                }
              },
              child: Text('추가'),
            ),
          ],
        );
      },
    );
  }
}
