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
    if (user == null) {
      print("Error: User is not logged in");
      throw Exception('User is not logged in');
    }
    final path = 'users/${user.uid}/words';
    print("Using Firebase path: $path");
    return FirebaseDatabase.instance.ref(path);
  }


  Future<void> fetchWords() async {
    final prefs = await SharedPreferences.getInstance();

    print("Loading favorite words from SharedPreferences...");
    String? localFavorites = prefs.getString('favorite_words');
    if (localFavorites != null) {
      try {
        List<dynamic> jsonData = jsonDecode(localFavorites);
        _words = jsonData.map((word) => Word.fromMap(word['eng'], word)).toList();
        print("Loaded favorite words from SharedPreferences: $_words");
        notifyListeners();
      } catch (e) {
        print("Error decoding local favorites: $e");
      }
    } else {
      print("No local favorite words found.");
    }

    print("Fetching words from Firebase...");
    try {
      final snapshot = await _userWordsRef.get();
      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        _words = data.entries.map((entry) {
          final wordData = Map<String, dynamic>.from(entry.value as Map);
          return Word.fromMap(entry.key, wordData);
        }).toList();

        print("Fetched words from Firebase: $_words");

        List<Word> favorites = _words.where((word) => word.isFavorite).toList();
        String encodedFavorites = jsonEncode(favorites.map((word) => word.toMap()).toList());
        await prefs.setString('favorite_words', encodedFavorites);
        print("Saved favorite words to SharedPreferences: $favorites");

        notifyListeners();
      } else {
        print("No words found in Firebase.");
      }
    } catch (e) {
      print("Failed to fetch words from Firebase: $e");
    }
  }

  Future<void> addWord(String eng, String kor) async {
    final newWord = Word(eng: eng, kor: kor);
    print("Adding word to Firebase: $newWord");
    await _userWordsRef.child(eng).set(newWord.toMap());
    _words.add(newWord);
    print("Added word to local list: $_words");
    notifyListeners();
  }

  Future<void> toggleFavorite(Word word) async {
    word.isFavorite = !word.isFavorite;
    print("Toggling favorite status for: $word");
    await _userWordsRef.child(word.eng).update({'isFavorite': word.isFavorite});

    final prefs = await SharedPreferences.getInstance();
    List<Word> favorites = _words.where((word) => word.isFavorite).toList();
    String encodedFavorites = jsonEncode(favorites.map((word) => word.toMap()).toList());
    await prefs.setString('favorite_words', encodedFavorites);
    print("Updated favorite words in SharedPreferences: $favorites");

    notifyListeners();
  }

  Future<List<Word>> loadFavoriteWordsForNotification() async {
    final prefs = await SharedPreferences.getInstance();
    print("Loading favorite words for notifications...");
    String? localFavorites = prefs.getString('favorite_words');
    if (localFavorites != null) {
      try {
        List<dynamic> jsonData = jsonDecode(localFavorites);
        List<Word> favorites = jsonData.map((word) => Word.fromMap(word['eng'], word)).toList();
        print("Loaded favorite words for notifications: $favorites");
        return favorites;
      } catch (e) {
        print("Error decoding local favorite words for notifications: $e");
      }
    } else {
      print("No favorite words found for notifications.");
    }
    return [];
  }
}
