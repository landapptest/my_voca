class Word {
  String eng;
  String kor;
  bool isFavorite;

  Word({required this.eng, required this.kor, this.isFavorite = false});

  factory Word.fromMap(String eng, Map<String, dynamic> data) {
    return Word(
      eng: eng,
      kor: data['kor'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kor': kor,
      'isFavorite': isFavorite,
    };
  }
}
