/// File: lib/core/network/network_info.dart
/// Interface untuk check network connectivity
library;

import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Abstract class untuk network info
abstract class NetworkInfo {
  /// Check apakah device terkoneksi ke internet
  Future<bool> get isConnected;
  
  /// Stream untuk listen connection changes
  Stream<bool> get onConnectivityChanged;
}

/// Implementation dari NetworkInfo menggunakan InternetConnectionChecker
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;

  @override
  Stream<bool> get onConnectivityChanged {
    return connectionChecker.onStatusChange.map(
      (status) => status == InternetConnectionStatus.connected,
    );
  }
}