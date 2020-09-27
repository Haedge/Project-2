import 'dart:math';

import 'package:boggle/Game/LetterDistribution.dart';

class GameBoard{
  Random _random;
  List _board;
  int _size;

  GameBoard(this._size, this._random) {
    _board = List();
    _createBoard();
  }

  void _createBoard() {
    for (int i=0; i<_size; i++) {
      _board.add(List());
      for (int j=0; j<_size; j++) {
        _board[i].add(letterDistributions[_size][i][j].shuffle(_random));
      }
    }
  }

  String getLetterAtPosition(int column, int row) => _board[column][row];
}