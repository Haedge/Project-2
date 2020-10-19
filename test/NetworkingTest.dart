import 'package:flutter_test/flutter_test.dart';
import 'package:boggle/Networking/HostNetworking.dart';
import 'package:boggle/Networking/GuestNetworking.dart';
import 'package:boggle/Networking/SocketOutcome.dart';

void main() async {
  test('Testing Connection to two guests with same name', () async {
    HostNetworking host = HostNetworking('Host');
    SocketOutcome hostOutcome = await host.setUpServer();
    expect(hostOutcome.connectionSuccessful, true);
    GuestNetworking guest = GuestNetworking('127.0.0.1', "Guest1");
    GuestNetworking guest2 = GuestNetworking('127.0.0.1', 'Guest1');
    SocketOutcome guestOutcome = await guest.connectToHost();
    SocketOutcome guest2Outcome = await guest2.connectToHost();
    expect(guestOutcome.connectionSuccessful, true);
    host.startGame(2);
    Future.delayed(Duration(milliseconds: 2000));
    print(guest.userList);
    expect(guest2Outcome.connectionSuccessful, true);
    expect(guest2.screenName != 'Guest1', true);
  });
}