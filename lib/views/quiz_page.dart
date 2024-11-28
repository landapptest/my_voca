import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:my_voca/models/word_model.dart';
import 'package:my_voca/providers/word_provider.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<Word> _quizWords;
  late Word _currentWord;
  List<Word> _options = [];
  bool _answered = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  void _loadQuiz() {
    final wordProvider = Provider.of<WordProvider>(context, listen: false);
    _quizWords = wordProvider.favoriteWords;

    if (_quizWords.isNotEmpty) {
      _generateQuestion();
    }
  }

  void _generateQuestion() {
    setState(() {
      _answered = false;
      _isCorrect = false;

      _currentWord = _quizWords[Random().nextInt(_quizWords.length)];

      _options = List.from(_quizWords)..shuffle();
      _options = _options.take(4).toList();

      if (!_options.contains(_currentWord)) {
        _options[Random().nextInt(4)] = _currentWord;
      }
      _options.shuffle();
    });
  }

  void _checkAnswer(Word seletedWord) {
    setState(() {
      _answered = true;
      _isCorrect = seletedWord.eng == _currentWord.eng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('퀴즈'),
      ),
      body: _quizWords.isEmpty
          ? Center(child: Text('즐겨찾기한 단어가 없습니다.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '단어의 뜻 찾기',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _currentWord.eng,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  if (_answered)
                    Text(
                      _isCorrect ? '정답' : '오답',
                      style: TextStyle(
                        fontSize: 24,
                        color: _isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _options.length,
                      itemBuilder: (context, index) {
                        final option = _options[index];
                        return ListTile(
                          title: ElevatedButton(
                            onPressed:
                                _answered ? null : () => _checkAnswer(option),
                            child: Text(option.kor),
                          ),
                        );
                      },
                    ),
                  ),
                  if (_answered)
                    ElevatedButton(
                      onPressed: _generateQuestion,
                      child: Text('다음'),
                    ),
                ],
              ),
            ),
    );
  }
}
