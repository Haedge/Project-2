import 'dart:math';

import 'package:boggle/Game/LetterDistribution.dart';

class GameBoard{
  Random _random;
  List _board;
  int _size;

  GameBoard(this._size, this._random) {
    _board = List();
  }

  void _createBoard() {
    for (int i=0; i<_size; i++) {
      _board.add(List());

    }
  }
}