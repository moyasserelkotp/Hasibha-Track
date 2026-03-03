import 'dart:io';

/// Simple connectivity checker using DNS lookup.
/// For production, consider integrating `connectivity_plus` for stream-based monitoring.
class ConnectivityService {
  /// Returns true if the device has an active internet connection.
  Future<bool> hasConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Throws [NetworkUnavailableException] if there is no connection.
  Future<void> ensureConnected() async {
    if (!await hasConnection()) {
      throw const NetworkUnavailableException();
    }
  }
}

class NetworkUnavailableException implements Exception {
  final String message;
  const NetworkUnavailableException([
    this.message = 'No internet connection. Please check your network.',
  ]);

  @override
  String toString() => message;
}
