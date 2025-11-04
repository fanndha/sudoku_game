/// File: lib/core/utils/logger.dart
/// Custom logger untuk debugging dan error tracking

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as log;

/// Custom Logger class
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;
  AppLogger._internal();

  late final log.Logger _logger;
  bool _isInitialized = false;

  /// Initialize logger
  void init({bool enableInRelease = false}) {
    if (_isInitialized) return;

    final shouldLog = kDebugMode || enableInRelease;

    _logger = log.Logger(
      printer: log.PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: shouldLog ? log.Level.debug : log.Level.nothing,
    );

    _isInitialized = true;
  }

  /// Debug log (🐛)
  void d(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (!_isInitialized) init();
    final formattedMessage = _formatMessage(message, tag);
    _logger.d(formattedMessage, error: error, stackTrace: stackTrace);
  }

  /// Info log (💡)
  void i(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (!_isInitialized) init();
    final formattedMessage = _formatMessage(message, tag);
    _logger.i(formattedMessage, error: error, stackTrace: stackTrace);
  }

  /// Warning log (⚠️)
  void w(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (!_isInitialized) init();
    final formattedMessage = _formatMessage(message, tag);
    _logger.w(formattedMessage, error: error, stackTrace: stackTrace);
  }

  /// Error log (⛔)
  void e(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (!_isInitialized) init();
    final formattedMessage = _formatMessage(message, tag);
    _logger.e(formattedMessage, error: error, stackTrace: stackTrace);
  }

  /// Verbose log (📝)
  void v(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (!_isInitialized) init();
    final formattedMessage = _formatMessage(message, tag);
    _logger.v(formattedMessage, error: error, stackTrace: stackTrace);
  }

  /// WTF log - What a Terrible Failure (👾)
  void wtf(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (!_isInitialized) init();
    final formattedMessage = _formatMessage(message, tag);
    _logger.wtf(formattedMessage, error: error, stackTrace: stackTrace);
  }

  /// Format message dengan tag
  String _formatMessage(dynamic message, String? tag) {
    if (tag != null) {
      return '[$tag] $message';
    }
    return message.toString();
  }

  // ========== SPECIALIZED LOGGING METHODS ==========

  /// Log API request
  void apiRequest(
    String method,
    String url, {
    Map<String, dynamic>? headers,
    dynamic body,
  }) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln('🌐 API REQUEST');
    buffer.writeln('Method: $method');
    buffer.writeln('URL: $url');
    
    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('Headers: $headers');
    }
    
    if (body != null) {
      buffer.writeln('Body: $body');
    }

    d(buffer.toString(), tag: 'API');
  }

  /// Log API response
  void apiResponse(
    String url,
    int statusCode, {
    dynamic body,
    Duration? duration,
  }) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln('✅ API RESPONSE');
    buffer.writeln('URL: $url');
    buffer.writeln('Status: $statusCode');
    
    if (duration != null) {
      buffer.writeln('Duration: ${duration.inMilliseconds}ms');
    }
    
    if (body != null) {
      buffer.writeln('Body: $body');
    }

    d(buffer.toString(), tag: 'API');
  }

  /// Log API error
  void apiError(
    String url,
    dynamic error, {
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln('❌ API ERROR');
    buffer.writeln('URL: $url');
    buffer.writeln('Error: $error');

    e(buffer.toString(), error: error, stackTrace: stackTrace, tag: 'API');
  }

  /// Log Firebase operation
  void firebase(
    String operation,
    String collection, {
    String? documentId,
    dynamic data,
  }) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln('🔥 FIREBASE: $operation');
    buffer.writeln('Collection: $collection');
    
    if (documentId != null) {
      buffer.writeln('Document ID: $documentId');
    }
    
    if (data != null) {
      buffer.writeln('Data: $data');
    }

    d(buffer.toString(), tag: 'Firebase');
  }

  /// Log Hive operation
  void hive(
    String operation,
    String boxName, {
    dynamic key,
    dynamic value,
  }) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln('💾 HIVE: $operation');
    buffer.writeln('Box: $boxName');
    
    if (key != null) {
      buffer.writeln('Key: $key');
    }
    
    if (value != null) {
      buffer.writeln('Value: $value');
    }

    d(buffer.toString(), tag: 'Hive');
  }

  /// Log navigation
  void navigation(String routeName, {Map<String, dynamic>? arguments}) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln('🧭 NAVIGATION');
    buffer.writeln('Route: $routeName');
    
    if (arguments != null && arguments.isNotEmpty) {
      buffer.writeln('Arguments: $arguments');
    }

    d(buffer.toString(), tag: 'Navigation');
  }

  /// Log bloc event
  void blocEvent(String blocName, dynamic event) {
    if (!kDebugMode) return;

    d('📤 Event: $event', tag: blocName);
  }

  /// Log bloc state
  void blocState(String blocName, dynamic state) {
    if (!kDebugMode) return;

    d('📥 State: $state', tag: blocName);
  }

  /// Log game action
  void gameAction(String action, {Map<String, dynamic>? details}) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln('🎮 GAME ACTION: $action');
    
    if (details != null && details.isNotEmpty) {
      details.forEach((key, value) {
        buffer.writeln('$key: $value');
      });
    }

    d(buffer.toString(), tag: 'Game');
  }

  /// Log performance metric
  void performance(String operation, Duration duration) {
    if (!kDebugMode) return;

    final ms = duration.inMilliseconds;
    final emoji = ms < 100 ? '⚡' : (ms < 500 ? '🐢' : '🐌');
    
    i('$emoji $operation took ${ms}ms', tag: 'Performance');
  }

  /// Log ad event
  void adEvent(String adType, String event, {String? message}) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln('📺 AD EVENT: $event');
    buffer.writeln('Type: $adType');
    
    if (message != null) {
      buffer.writeln('Message: $message');
    }

    d(buffer.toString(), tag: 'AdMob');
  }

  /// Log IAP event
  void iapEvent(String event, String productId, {dynamic details}) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln('💳 IAP EVENT: $event');
    buffer.writeln('Product: $productId');
    
    if (details != null) {
      buffer.writeln('Details: $details');
    }

    d(buffer.toString(), tag: 'IAP');
  }
}

/// Global logger instance
final logger = AppLogger();