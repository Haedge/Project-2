import 'package:flutter_test/flutter_test.dart';
import 'package:boggle/Networking/HostNetworking.dart';
import 'package:boggle/Networking/GuestNetworking.dart';
import 'package:boggle/Networking/SocketOutcome.dart';

void main() async {
  test('Testing Connection', () async {
    HostNetworking host = HostNetworking('Host');
    SocketOutcome hostOutcome = await host.setUpServer();
    expect(hostOutcome.connectionSuccessful, true);
    GuestNetworking guest = GuestNetworking('127.0.0.1', "Guest1");
    Map gameCode = await guest.joinGameAndGetGameCode();
    expect(gameCode['seed'] == 2, true);
    Map scores = await guest.sendInWordsAndAwaitScores({'word1', 'word2', 'qjoi'});
    print(scores);
  });
}