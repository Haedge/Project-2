import 'dart:math';

import 'package:boggle/Game/GameBoard.dart';
import 'package:boggle/Position.dart';

class Game {
  GameBoard _board;
  int _size;
  Set _validWords;
  Set _submittedWords;

  Game(this._size, int randomSeed) {
    _board = GameBoard(_size, Random(randomSeed));
    _submittedWords = Set();
    _validWords = Set();
  }

  String getLetterAtPosition(Position pos) => _board.getLetterAtPosition(pos.column, pos.row);
}