//enum gameplayType (tabel scenes)
enum GameplayType {
  dialog,
  multipleChoice,
  wordArrangement,
  sqlInput;

  // Fungsi konversi dari String DB ke Enum
  static GameplayType fromString(String type) {
    switch (type) {
      case 'Pilihan ganda':
        return GameplayType.multipleChoice;
      case 'Susun kata':
        return GameplayType.wordArrangement;
      case 'Tulis SQL':
        return GameplayType.sqlInput;
      case 'Dialog':
      default:
        return GameplayType.dialog;
    }
  }
}

//enum kolom level_type (tabel levels)
enum LevelType {
  intro('intro'),
  gameplay('gameplay');

  final String value;
  const LevelType(this.value);
}
