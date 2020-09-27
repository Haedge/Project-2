import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:boggle/Game/GameBoard.dart';

void main() {
  test('4x4 boards with same seed have same letters', () {
    testBoardEquality(4);
  });
  test('5x5 boards with same seed have same letters', () {
    testBoardEquality(5);
  });
  test('6x6 boards with same seed have same letters', () {
    testBoardEquality(6);
  });
}

void testBoardEquality(int size) {
  Random rng = Random(5);
  GameBoard board1 = GameBoard(size, rng);
  GameBoard board2 = GameBoard(size, rng);
  for (int i=0; i<size; i++) {
    for (int j=0; j<size; j++) {
      expect(board1.getLetterAtPosition(i, j) == board2.getLetterAtPosition(i, j), true);
    }
  }
}