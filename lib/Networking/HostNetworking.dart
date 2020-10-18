import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'SocketOutcome.dart';
import 'GamePhase.dart';

final int port = 4444;

// For use by host

class HostNetworking {
  GamePhase _phase;
  Map<String, Socket> _guestSockets;
  List<String> screenNamesInGame;
  JsonCodec _encoder;

  HostNetworking(String screenName) {
    _phase = GamePhase.settingUp;
    _guestSockets = Map();
    screenNamesInGame = [screenName];
    _encoder = JsonCodec();
  }

  Future<SocketOutcome> setUpServer() async {
    try {
      ServerSocket server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
      server.listen(_makeConnection);
      return SocketOutcome();
    } on SocketException catch (e) {
      return SocketOutcome(errorMessage: e.message);
    }
  }

  void _makeConnection(Socket socket) {
    socket.listen((data) {
      if (_phase == GamePhase.settingUp) {
        print('Received connection from ${socket.remoteAddress.address}');
        _addNewGuest(socket, data);
      }
    });
  }

  void _addNewGuest(Socket socket, Uint8List data) {
    String guestName = String.fromCharCodes(data);
    if (!_guestSockets.containsKey(guestName)) {
      _guestSockets[guestName] = socket;
      screenNamesInGame.add(guestName);
      _sendGuestListToAllGuests();
    } else {
      socket.write('Invalid Name: Name already in use');
      socket.close();
    }
  }

  void _sendGuestListToAllGuests() {
    for (String guest in _guestSockets.keys) {
      _guestSockets[guest].write(_encoder.encode(screenNamesInGame));
    }
  }

  void startGame(int gameSeed) {
    _phase = GamePhase.started;
    for (String guest in _guestSockets.keys) {
      _guestSockets[guest].writeln('Starting Game');
      _guestSockets[guest].writeln(_encoder.encode(gameSeed));
    }
  }
}