import 'package:flutter_test/flutter_test.dart';
import 'package:boggle/Networking/HostNetworking.dart';
import 'package:boggle/Networking/GuestNetworking.dart';
import 'package:boggle/Networking/SocketOutcome.dart';

void main() async {
  test('Testing Connection to one guest', () async {
    HostNetworking host = HostNetworking('Host');
    SocketOutcome hostOutcome = await host.setUpServer();
    expect(hostOutcome.connectionSuccessful, true);
    GuestNetworking guest = GuestNetworking('127.0.0.1', "Guest1");
    SocketOutcome guestOutcome = await guest.connectToHost();
    expect(guestOutcome.connectionSuccessful, true);
    Future.delayed(Duration(milliseconds: 2000));
    print(guest.userList);
    expect(guest.userList != null, true);
  });
}