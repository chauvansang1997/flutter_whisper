class WhisperLanguage {
  final String? languageCode;
  final String? languageName;
  WhisperLanguage({
    this.languageCode,
    this.languageName,
  });

  WhisperLanguage copyWith({
    String? languageCode,
    String? languageName,
  }) {
    return WhisperLanguage(
      languageCode: languageCode ?? this.languageCode,
      languageName: languageName ?? this.languageName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'languageCode': languageCode,
      'languageName': languageName,
    };
  }

  factory WhisperLanguage.fromMap(Map<String, dynamic> map) {
    return WhisperLanguage(
      languageCode: map['languageCode'],
      languageName: map['languageName'],
    );
  }

  @override
  String toString() =>
      'WhisperLanguage(languageCode: $languageCode, languageName: $languageName)';

  @override
  bool operator ==(covariant WhisperLanguage other) {
    if (identical(this, other)) return true;

    return other.languageCode == languageCode &&
        other.languageName == languageName;
  }

  @override
  int get hashCode => languageCode.hashCode ^ languageName.hashCode;
}
