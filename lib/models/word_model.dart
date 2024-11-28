class Word {
  String eng;
  String kor;
  bool isFavorite;

  Word({required this.eng, required this.kor, this.isFavorite = false});

  factory Word.fromMap(Map<String, dynamic> data) {
    return Word(
      eng: data['eng'] ?? '',
      kor: data['kor'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eng': eng,
      'kor': kor,
      'isFavorite': isFavorite,
    };
  }
}