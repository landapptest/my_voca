class Word {
  String eng;
  String kor;
  bool isFavorite;

  Word({required this.eng, required this.kor, this.isFavorite = false});

  // 'eng'는 외부에서 따로 받아옴
  factory Word.fromMap(String eng, Map<String, dynamic> data) {
    return Word(
      eng: eng, // 영어 단어는 외부에서 받아온 키로 설정
      kor: data['kor'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  // 'eng'는 따로 저장할 필요 없으므로 map에 포함하지 않음
  Map<String, dynamic> toMap() {
    return {
      'kor': kor,
      'isFavorite': isFavorite,
    };
  }
}
