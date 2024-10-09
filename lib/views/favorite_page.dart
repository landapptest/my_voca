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
                return ListTile(
                  title: Text(word.eng),
                  subtitle: Text(word.kor),
                  trailing: IconButton(
                    icon: Icon(
                      word.isFavorite ? Icons.star : Icons.star_border,
                    ),
                    onPressed: () {
                      wordProvider.toggleFavorite(word);
                    },
                  ),
                );
              },
            ),
    );
  }
}
