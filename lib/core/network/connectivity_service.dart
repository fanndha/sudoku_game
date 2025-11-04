/// File: lib/core/network/connectivity_service.dart
/// Service untuk manage connectivity state dan notifications
library;

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

/// Connectivity Service untuk manage network state
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  
  // Stream controller untuk broadcast connectivity status
  final StreamController<ConnectivityStatus> _connectivityController =
      StreamController<ConnectivityStatus>.broadcast();

  Stream<ConnectivityStatus> get connectivityStream =>
      _connectivityController.stream;

  ConnectivityStatus _currentStatus = ConnectivityStatus.online;
  ConnectivityStatus get currentStatus => _currentStatus;

  ConnectivityService() {
    _initialize();
  }

  /// Initialize connectivity listener
  void _initialize() {
    // Check initial connectivity
    _checkConnectivity();

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectionStatus(result);
    });
  }

  /// Check current connectivity
  Future<void> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      _updateStatus(ConnectivityStatus.offline);
    }
  }

  /// Update connection status berdasarkan ConnectivityResult
  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      _updateStatus(ConnectivityStatus.offline);
    } else if (result == ConnectivityResult.mobile) {
      _updateStatus(ConnectivityStatus.cellular);
    } else if (result == ConnectivityResult.wifi) {
      _updateStatus(ConnectivityStatus.wifi);
    } else {
      _updateStatus(ConnectivityStatus.online);
    }
  }

  /// Update status dan broadcast ke stream
  void _updateStatus(ConnectivityStatus status) {
    if (_currentStatus != status) {
      _currentStatus = status;
      _connectivityController.add(status);
      debugPrint('Connectivity status changed: $status');
    }
  }

  /// Check apakah online
  bool get isOnline => _currentStatus != ConnectivityStatus.offline;

  /// Check apakah offline
  bool get isOffline => _currentStatus == ConnectivityStatus.offline;

  /// Check apakah menggunakan WiFi
  bool get isWifi => _currentStatus == ConnectivityStatus.wifi;

  /// Check apakah menggunakan cellular
  bool get isCellular => _currentStatus == ConnectivityStatus.cellular;

  /// Dispose stream controller
  void dispose() {
    _connectivityController.close();
  }
}

/// Enum untuk connectivity status
enum ConnectivityStatus {
  online,
  offline,
  wifi,
  cellular,
}

/// Extension untuk ConnectivityStatus
extension ConnectivityStatusExtension on ConnectivityStatus {
  String get displayName {
    switch (this) {
      case ConnectivityStatus.online:
        return 'Online';
      case ConnectivityStatus.offline:
        return 'Offline';
      case ConnectivityStatus.wifi:
        return 'WiFi';
      case ConnectivityStatus.cellular:
        return 'Mobile Data';
    }
  }

  IconData get icon {
    switch (this) {
      case ConnectivityStatus.online:
        return Icons.wifi;
      case ConnectivityStatus.offline:
        return Icons.wifi_off;
      case ConnectivityStatus.wifi:
        return Icons.wifi;
      case ConnectivityStatus.cellular:
        return Icons.signal_cellular_alt;
    }
  }

  Color get color {
    switch (this) {
      case ConnectivityStatus.online:
      case ConnectivityStatus.wifi:
        return Colors.green;
      case ConnectivityStatus.cellular:
        return Colors.orange;
      case ConnectivityStatus.offline:
        return Colors.red;
    }
  }
}