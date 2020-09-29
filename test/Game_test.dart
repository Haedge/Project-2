import 'dart:math';

import 'package:boggle/Game/GameBoard.dart';
import 'package:boggle/Game/LetterDistribution.dart';
import 'package:boggle/Position.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:boggle/Game/Game.dart';

void main() {
  test('Entered a valid sequence of positions', () {
    Game g = Game(4, 2);
    print(g.getValidWords().length);
    expect(g.isWordValid([Position(0,2), Position(0,3), Position(1,3)]), true);
  });

  test('A valid word laid out unusually', () {
    Game g = Game(4, 2);
    expect(g.isWordValid([Position(0,1), Position(0,0), Position(1,1)]), true);
  });

  test('Some positions off board', () {
    Game g = Game(4, 2);
    print(g.getBoardString());
    expect(g.isWordValid([Position(-1,2), Position(0,3), Position(0,4)]), false);
  });

  test('A valid word with non-neighboring positions', (){
    Game g = Game(4, 2);
    expect(g.isWordValid([Position(3,2), Position(0,3), Position(3,3), Position(1,3)]), false);
  });

  test('Valid positions but invalid word', (){
    Game g = Game(4, 2);
    expect(g.isWordValid([Position(3, 2), Position(3, 1), Position(3, 0)]), false);
  });
}