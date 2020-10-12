import 'dart:math';
import 'dart:io';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:boggle/Game/GameBoard.dart';
import 'package:boggle/Position.dart';

class Game {
  String wordFilePath = 'assets/bogglewords.txt';
  GameBoard _board;
  int _boardSize;
  Set _validWords;
  Set _submittedWords;


  Game(this._boardSize, int randomSeed) {
    _board = GameBoard(_boardSize, Random(randomSeed));
    _submittedWords = Set();
    _validWords = Set();
    loadInValidWords();
  }

  void loadInValidWords() async {
    String wordFile = await rootBundle.loadString(wordFilePath);
    List<String> lines = wordFile.split("\n");
    for (String line in lines) {
      _validWords.add(line.toUpperCase());
    }
  }

  Set getValidWords() => _validWords;

  Set getSubmittedWords() => _submittedWords;

  String getBoardString() => _board.toString();

  String getLetterAtPosition(Position pos) => _board.getLetterAtPosition(pos.column, pos.row);

  bool _validPosition(Position pos) => pos.row >= 0 && pos.row < _boardSize && pos.column >= 0 && pos.column < _boardSize;

  bool isWordValid(List<Position> positions) {
    if (!_wordPositionsValid(positions)) {
      return false;
    }
    String wordString = _convertPositionListToString(positions);
    print(wordString);
    if (_validWords.contains(wordString) && !_submittedWords.contains(wordString)) {
      _submittedWords.add(wordString);
      return true;
    }
    return false;
  }

  bool _wordPositionsValid(List<Position> positions) {
    Set<Position> positionsAlreadyPlayed = Set();
    positionsAlreadyPlayed.add(positions[0]);
    for (int i=1; i<positions.length; i++) {
      if (!_validPosition(positions[i]) || !_validPosition(positions[i-1])
          || !positions[i].isNeighbor(positions[i-1]) || positionsAlreadyPlayed.contains(positions[i])) {
        return false;
      }
      positionsAlreadyPlayed.add(positions[i]);
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

  void printSubmittedWords() {
    for (String word in _submittedWords) {
      print(word);
    }
  }
}