import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_voca/providers/word_provider.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wordProvider = Provider.of<WordProvider>(context);
    final favoriteWords = wordProvider.favoriteWords;

    return Scaffold(
      appBar: AppBar(
        title: Text('즐겨찾기'),
      ),
      body: favoriteWords.isEmpty
          ? Center(child: Text('즐겨찾기한 단어가 없습니다.'))
          : ListView.builder(
        itemCount: favoriteWords.length,
        itemBuilder: (context, index) {
          final word = favoriteWords[index];
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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                word.kor,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  word.isFavorite ? Icons.star : Icons.star_border,
                  color: Colors.yellow,
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
}
