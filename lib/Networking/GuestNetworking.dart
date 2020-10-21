import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'GamePhase.dart';
import 'SocketOutcome.dart';

final int port = 4444;

class GuestNetworking {
  String _hostIP;
  String screenName;
  JsonCodec _decoder;
  Map gameCodeAndSeed;
  Socket _socket;
  Map _scores;


  GuestNetworking(this._hostIP, this.screenName) {
    _decoder = JsonCodec();
  }

  // Call this to connect to host and use await
  // to await the seed
  Future<Map> joinGameAndGetGameCode() async {
    await _connectToHost();
    _socket.write(_decoder.encode(screenName));
    await _socket.listen(_handleInitialData).asFuture();
    return gameCodeAndSeed;
  }

  // Call this after the game is over and use await to wait
  // for the host to send the scores
  Future<Map> sendInWordsAndAwaitScores(Set words) async {
    await _connectToHost();
    Map<String, dynamic> wordsWithName = {
      "name" : screenName,
    "words": words.toList()
    };
    _socket.write(_decoder.encode(wordsWithName));
    await _socket.listen(_handleIncomingScores).asFuture().timeout(Duration(minutes: 1));
    return _scores;
  }

  Future<SocketOutcome> _connectToHost() async {
    try {
      print('Connecting...');
      _socket = await Socket.connect(_hostIP, port);
      print('connected to host');
      return SocketOutcome();
    } on SocketException catch (e) {
      return SocketOutcome(errorMessage: e.message);
    }
  }

  void _handleInitialData(Uint8List data) {
    var decoded = _decoder.decode(String.fromCharCodes(data));
    print(decoded);
    if (decoded.runtimeType == String) {
      screenName = decoded;
      print('name changed to $decoded');
    } if (decoded.runtimeType == int) {
      print('received Game code');
      gameCodeAndSeed = decoded;
      _socket.destroy();
    }
  }

  void _handleIncomingScores(Uint8List data) {
    _scores = _decoder.decode(String.fromCharCodes(data));
    _socket.destroy();
  }
}