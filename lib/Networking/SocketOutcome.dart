class SocketOutcome {
  String _errorMessage;

  SocketOutcome({String errorMessage = ''}) {
    _errorMessage = errorMessage;
  }

  bool get connectionSuccessful => _errorMessage.length == 0;

  String get errorMessage => _errorMessage;
}