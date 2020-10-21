class Scorer {
  Map<String, Set> _wordLists;
  Map<String, int> _scores;

  Scorer(this._wordLists) {
    _scores = Map();
    _copyNamesToScoreMap();
  }

  void _copyNamesToScoreMap() {
    for (String name in _wordLists.keys) {
      _scores[name] = 0;
    }
  }

  void generateScores() {
    _findAndRemoveDuplicateWords();
    for (String name in _scores.keys) {
      for (String word in _wordLists[name]) {
        _scores[name] += _scoreWord(word);
      }
    }
  }

  int getScore(String name) => _scores[name];

  Set getWords(String name) => _wordLists[name];

  int _scoreWord(String word) {
    if (word.length == 3 || word.length == 4) {
      return 1;
    } else if (word.length == 5) {
      return 2;
    } else if (word.length == 6) {
      return 3;
    }else if (word.length == 7) {
      return 5;
    } else if (word.length == 8) {
      return 11;
    } else if (word.length >= 9) {
      return 2 * word.length;
    } else {
      return 0;
    }
  }

  void _findAndRemoveDuplicateWords() => _removeDuplicateWords(_findDuplicateWords());

  Set _findDuplicateWords() {
    Set duplicates = Set();
    List names = _wordLists.keys.toList();
    for (int i=0; i<names.length-1; i++) {
      for (int j=i+1; j<names.length; j++) {
        for (String word in _wordLists[names[i]]) {
          if (_wordLists[names[j]].contains(word)) {
            duplicates.add(word);
          }
        }
      }
    }
    return duplicates;
  }

  void _removeDuplicateWords(Set duplicates) {
    for (String word in duplicates) {
      for (String name in _wordLists.keys) {
        _wordLists[name].remove(word);
      }
    }
  }

}