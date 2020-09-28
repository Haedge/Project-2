import 'dart:math';

import 'package:boggle/Game/GameBoard.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:boggle/Game/Game.dart';

void main() {
  test('description', () {
    GameBoard g = GameBoard(4, Random(2));
    print(g.toString());
  });
}