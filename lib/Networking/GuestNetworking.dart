import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'GamePhase.dart';
import 'SocketOutcome.dart';

final int port = 4444;

class GuestNetworking {
  String _hostIP;
  String _screenName;
  GamePhase _phase;
  JsonCodec _decoder;
  List userList;


  GuestNetworking(this._hostIP, this._screenName) {
    _phase = GamePhase.settingUp;
    _decoder = JsonCodec();
  }

  Future<SocketOutcome> connectToHost() async {
    try {
      print('Connecting...');
      Socket socket = await Socket.connect(_hostIP, port);
      print('connected to host');
      socket.write(_screenName);
      socket.listen(handleData,
      onDone: () {socket.close();});
      return SocketOutcome();
    } on SocketException catch (e) {
      return SocketOutcome(errorMessage: e.message);
    }
  }

  void handleData(Uint8List data) {
    if (_phase == GamePhase.settingUp) {
      var decoded = _decoder.decode(String.fromCharCodes(data));
      userList = decoded;
      print(userList);
    }
  }
}