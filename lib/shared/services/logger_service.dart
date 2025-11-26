import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Log levels
enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}

/// Log entry
class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? tag;
  final Map<String, dynamic>? data;
  final dynamic error;
  final StackTrace? stackTrace;

  LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.tag,
    this.data,
    this.error,
    this.stackTrace,
  });

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('[${level.name.toUpperCase()}]');
    if (tag != null) buffer.write(' [$tag]');
    buffer.write(' $message');
    if (data != null) buffer.write(' | Data: $data');
    if (error != null) buffer.write(' | Error: $error');
    return buffer.toString();
  }
}

/// Logging service
class Logger {
  static final Logger _instance = Logger._internal();
  factory Logger() => _instance;
  Logger._internal();

  /// Get named logger
  static Logger get(String tag) {
    return Logger().._currentTag = tag;
  }

  String? _currentTag;
  final List<LogEntry> _logHistory = [];
  static const int _maxHistorySize = 1000;

  /// Log debug message
  void debug(String message, {Map<String, dynamic>? data}) {
    _log(LogLevel.debug, message, data: data);
  }

  /// Log info message
  void info(String message, {Map<String, dynamic>? data}) {
    _log(LogLevel.info, message, data: data);
  }

  /// Log warning message
  void warning(String message, {Map<String, dynamic>? data}) {
    _log(LogLevel.warning, message, data: data);
  }

  /// Log error message
  void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _log(
      LogLevel.error,
      message,
      error: error,
      stackTrace: stackTrace,
      data: data,
    );
  }

  /// Log fatal error
  void fatal(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _log(
      LogLevel.fatal,
      message,
      error: error,
      stackTrace: stackTrace,
      data: data,
    );
  }

  /// Internal log method
  void _log(
    LogLevel level,
    String message, {
    Map<String, dynamic>? data,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      tag: _currentTag,
      data: data,
      error: error,
      stackTrace: stackTrace,
    );

    // Add to history
    _logHistory.add(entry);
    if (_logHistory.length > _maxHistorySize) {
      _logHistory.removeAt(0);
    }

    // Print to console in debug mode
    if (kDebugMode) {
      _printLog(entry);
    }

    // Send to developer console
    _sendToDeveloperLog(entry);
  }

  /// Print log to console
  void _printLog(LogEntry entry) {
    final color = _getColorForLevel(entry.level);
    print('$color${entry.toString()}\x1B[0m');

    if (entry.stackTrace != null) {
      print('${_getColorForLevel(LogLevel.error)}Stack trace:\n${entry.stackTrace}\x1B[0m');
    }
  }

  /// Get ANSI color code for log level
  String _getColorForLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '\x1B[37m'; // White
      case LogLevel.info:
        return '\x1B[32m'; // Green
      case LogLevel.warning:
        return '\x1B[33m'; // Yellow
      case LogLevel.error:
        return '\x1B[31m'; // Red
      case LogLevel.fatal:
        return '\x1B[35m'; // Magenta
    }
  }

  /// Send to Flutter developer log
  void _sendToDeveloperLog(LogEntry entry) {
    developer.log(
      entry.message,
      time: entry.timestamp,
      level: _getDeveloperLogLevel(entry.level),
      name: entry.tag ?? 'App',
      error: entry.error,
      stackTrace: entry.stackTrace,
    );
  }

  /// Convert LogLevel to developer.log level
  int _getDeveloperLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500; // FINE
      case LogLevel.info:
        return 800; // INFO
      case LogLevel.warning:
        return 900; // WARNING
      case LogLevel.error:
        return 1000; // SEVERE
      case LogLevel.fatal:
        return 1200; // SHOUT
    }
  }

  /// Get log history
  List<LogEntry> get history => List.unmodifiable(_logHistory);

  /// Clear log history
  void clearHistory() {
    _logHistory.clear();
  }

  /// Export logs as string
  String exportLogs() {
    return _logHistory.map((e) => e.toString()).join('\n');
  }

  /// Get logs for specific level
  List<LogEntry> getLogsForLevel(LogLevel level) {
    return _logHistory.where((e) => e.level == level).toList();
  }

  /// Get logs for specific tag
  List<LogEntry> getLogsForTag(String tag) {
    return _logHistory.where((e) => e.tag == tag).toList();
  }
}

/// Extension for easy logging
extension LoggerExtension on Object {
  Logger get log => Logger.get(runtimeType.toString());
}
