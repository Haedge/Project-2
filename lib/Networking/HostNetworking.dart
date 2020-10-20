import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'SocketOutcome.dart';
import 'GamePhase.dart';

final int port = 4444;

// For use by host

class HostNetworking {
  String screenName;
  GamePhase _phase;
  InternetAddress _address;
  ServerSocket _server;
  Map<String, Socket> _guestSockets;
  List<String> screenNamesInGame;
  Map _wordsFromGuests;
  Set _guestsWhoHaveSubmittedWords;
  JsonCodec _encoder;

  HostNetworking(this.screenName) {
    _address = InternetAddress.anyIPv4;
    _phase = GamePhase.settingUp;
    _guestSockets = Map();
    screenNamesInGame = [screenName];
    _encoder = JsonCodec();
    _guestsWhoHaveSubmittedWords = Set();
    _wordsFromGuests = Map();
  }

  // Be sure to call this right after you initialize
  // it
  Future<SocketOutcome> setUpServer() async {
    try {
      _server = await ServerSocket.bind(_address, port);
      _server.listen(_makeInitialConnection);
      return SocketOutcome();
    } on SocketException catch (e) {
      return SocketOutcome(errorMessage: e.message);
    }
  }

  void _makeInitialConnection(Socket socket) {
    socket.listen((data) {
      print('Received connection from ${socket.remoteAddress.address}');
      _addNewGuest(socket, data);
    },
    onDone: () {socket.destroy();});
  }

  void _addNewGuest(Socket socket, Uint8List data) {
    String guestName = _encoder.decode(String.fromCharCodes(data));
    if (_guestSockets.containsKey(guestName)) {
      guestName = _distinguishRepeatName(guestName);
      socket.writeln(_encoder.encode(guestName));
    }
    _guestSockets[guestName] = socket;
    screenNamesInGame.add(guestName);
    // For testing purposes
    //startGameAndAwaitResults(2);
  }

  String _distinguishRepeatName(String name) {
    int c = 2;
    String newName = '$name($c)';
    while (_guestSockets.containsKey(newName)) {
      c++;
      newName = '$name($c)';
    }
    return newName;
  }

  // This sends out the seed to guests and will return
  // a map of their words once they send them in
  Future<Map> startGameAndAwaitResults(int gameSeed) {
    _phase = GamePhase.started;
    for (String guest in _guestSockets.keys) {
      _guestSockets[guest].writeln(_encoder.encode(gameSeed));
    }
    _server.close();
    return _receiveWords();
  }

  Future<Map> _receiveWords() async {
    try {
      _server = await ServerSocket.bind(_address, port);
      await _server.listen((socket) async {
        await _reconnectToGuest(socket);
        print(_allGuestsSubmittedWords());
        if (_allGuestsSubmittedWords()) {
          _server.close();
        }
      }).asFuture().timeout(
          Duration(minutes: 4),
          onTimeout: () {});
    } on SocketException catch(e) {
      print(e.message);
    }
    // For testing purposes
    //sendOutScores({'Guest1': 1, 'Host': 2});
    return _wordsFromGuests;
  }

  Future<void> _reconnectToGuest(Socket socket) async {
    print("Received connection from socket at ${socket.remoteAddress.address}");
    _readInWords(socket, await socket.first);
  }

  // The words will come in as a list and need to be
  // converted to a set
  void _readInWords(Socket socket, Uint8List data) {
    Map words = _encoder.decode(String.fromCharCodes(data));
    print(words);
    _wordsFromGuests[words['name']] = words['words'];
    _guestSockets[words['name']] = socket;
    _guestsWhoHaveSubmittedWords.add(words['name']);
    print('Received words from ${words['name']}');
  }

  bool _allGuestsSubmittedWords() {
    for (String guest in screenNamesInGame) {
      print(guest);
      print(_guestsWhoHaveSubmittedWords);
      print(_guestsWhoHaveSubmittedWords.contains("Guest1"));
      if (!_guestsWhoHaveSubmittedWords.contains(guest) && guest != screenName) {
        print('$guest has not submitted words');
        return false;
      }
    }
    return true;
  }

  // This sends the scores out to all guests
  void sendOutScores(Map<String, int> scores) {
    for (String guest in _guestsWhoHaveSubmittedWords) {
      _guestSockets[guest].write(_encoder.encode(scores));
      print('sent scores to $guest');
    }
  }
}