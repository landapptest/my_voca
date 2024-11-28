import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_voca/models/word_model.dart';

class WordProvider with ChangeNotifier {
  List<Word> _words = [];
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('words');

  List<Word> get words => _words;
  List<Word> get favoriteWords => _words.where((word) => word.isFavorite).toList();

  WordProvider() {
    fetchWords();
  }

  Future<void> fetchWords() async {
    final snapshot = await _databaseRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      _words = data.entries
        .map((entry) => Word.fromMap(Map<String, dynamic>.from(entry.value)))
        .toList();
      notifyListeners();
    }
  }

  Future<void> addWord(String eng, String kor) async {
    final newWord = Word(eng: eng, kor: kor);
    await _databaseRef.push().set(newWord.toMap());
    _words.add(newWord);
    notifyListeners();
  }

  Future<void> toggleFavorite(Word word) async {
    word.isFavorite = !word.isFavorite;
    final wordRef = _databaseRef.child(word.eng);
    await wordRef.update({'isFavorite': word.isFavorite});
    notifyListeners();
  }
}