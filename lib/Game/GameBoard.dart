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
        _board[i].add(letterDistributions[_size][i][j][_random.nextInt(letterDistributions[_size][i][j].length)]);
      }
    }
  }

  String getLetterAtPosition(int column, int row) => _board[column][row];

  String toString() {
    String s = '';
    for (int i=0; i<_size; i++) {
      for (int j=0; j<_size; j++) {
        s = s + getLetterAtPosition(j, i);
      }
      s = s + '\n';
    }
    return s;
  }
}