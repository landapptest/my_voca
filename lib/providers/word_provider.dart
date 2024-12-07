import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_voca/models/word_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WordProvider with ChangeNotifier {
  List<Word> _words = [];
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('words');

  List<Word> get words => _words;
  List<Word> get favoriteWords => _words.where((word) => word.isFavorite).toList();

  WordProvider() {
    fetchWords();
  }

  Future<void> fetchWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? localData = prefs.getString('word_list');

    if (localData != null) {
      List<dynamic> jsonData = jsonDecode(localData);

      // 여기서는 'eng' 키가 따로 없으므로, 기존 fromMap 형식을 사용
      _words = jsonData.map((word) => Word.fromMap(word['eng'], word)).toList(); // 로컬 데이터에서 맵핑 시 eng 키가 포함되어 있지 않기 때문에 이를 바로 넘겨줌
      notifyListeners();
    }

    final snapshot = await _databaseRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      _words = data.entries
          .map((entry) => Word.fromMap(entry.key, Map<String, dynamic>.from(entry.value)))
          .toList();

      String encodedData = jsonEncode(_words.map((word) => word.toMap()).toList());
      await prefs.setString('word_list', encodedData);

      notifyListeners();
    }
  }

  Future<void> addWord(String eng, String kor) async {
    if (eng.isNotEmpty && kor.isNotEmpty) {
      final newWord = Word(eng: eng, kor: kor);
      await _databaseRef.child(eng).set(newWord.toMap()); // 단어의 영어 부분을 키로 사용
      _words.add(newWord);
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Word word) async {
    word.isFavorite = !word.isFavorite;
    final wordRef = _databaseRef.child(word.eng); // 영어 단어를 키로 사용하여 업데이트
    await wordRef.update({'isFavorite': word.isFavorite});
    notifyListeners();
  }
}
