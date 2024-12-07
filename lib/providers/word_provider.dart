import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_voca/models/word_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WordProvider with ChangeNotifier {
  List<Word> _words = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Word> get words => _words;
  List<Word> get favoriteWords => _words.where((word) => word.isFavorite).toList();

  DatabaseReference get _userWordsRef {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User is not logged in');
    return FirebaseDatabase.instance.ref('users/${user.uid}/words');
  }

  Future<void> fetchWords() async {
    final prefs = await SharedPreferences.getInstance();

    // 로컬 데이터 가져오기
    String? localData = prefs.getString('word_list');
    if (localData != null) {
      List<dynamic> jsonData = jsonDecode(localData);
      _words = jsonData.map((word) => Word.fromMap(word['eng'], word)).toList();
      notifyListeners();
    }

    // Firebase 데이터 가져오기
    final snapshot = await _userWordsRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      _words = data.entries.map((entry) {
        final wordData = Map<String, dynamic>.from(entry.value as Map);
        return Word.fromMap(entry.key, wordData);
      }).toList();

      // 로컬 데이터 저장
      String encodedData = jsonEncode(_words.map((word) => word.toMap()).toList());
      await prefs.setString('word_list', encodedData);

      notifyListeners();
    }
  }

  Future<void> addWord(String eng, String kor) async {
    final newWord = Word(eng: eng, kor: kor);
    await _userWordsRef.child(eng).set(newWord.toMap());
    _words.add(newWord);
    notifyListeners();
  }

  Future<void> toggleFavorite(Word word) async {
    word.isFavorite = !word.isFavorite;
    await _userWordsRef.child(word.eng).update({'isFavorite': word.isFavorite});
    notifyListeners();
  }
}
