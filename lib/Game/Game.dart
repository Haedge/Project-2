import 'dart:math';

import 'package:boggle/Game/GameBoard.dart';
import 'package:boggle/Position.dart';

class Game {
  GameBoard _board;
  int _boardSize;
  Set _validWords;
  Set _submittedWords;

  Game(this._boardSize, int randomSeed) {
    _board = GameBoard(_boardSize, Random(randomSeed));
    _submittedWords = Set();
    _validWords = Set();
  }

  String getLetterAtPosition(Position pos) => _board.getLetterAtPosition(pos.column, pos.row);

  bool _validPosition(Position pos) => pos.row >= 0 && pos.row < _boardSize && pos.column >= 0 && pos.column < _boardSize;

  bool isWordValid(List<Position> positions) {
    if (!_wordPositionsValid(positions)) {
      return false;
    }
    String wordString = _convertPositionListToString(positions);
    if (_validWords.contains(wordString)) {
      _submittedWords.add(wordString);
      return true;
    }
    return false;
  }

  bool _wordPositionsValid(List<Position> positions) {
    for (int i=1; i<positions.length; i++) {
      if (!_validPosition(positions[i]) || !_validPosition(positions[i-1]) || !positions[i].isNeighbor(positions[i-1])) {
        return false;
      }
    }
    return true;
  }

  String _convertPositionListToString(List<Position> positions) {
    String wordString = '';
    for (Position pos in positions) {
      wordString += getLetterAtPosition(pos).toUpperCase();
    }
    return wordString;
  }
}