import 'dart:io';
import 'package:flutter/foundation.dart';

/// Platform helper for platform-specific utilities and checks
class PlatformHelper {
  /// Check if running on web
  static bool get isWeb => kIsWeb;

  /// Check if running on mobile (iOS or Android)
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// Check if running on desktop (Windows, macOS, or Linux)
  static bool get isDesktop => !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  /// Check if running on Android
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Check if running on iOS
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Check if running on Windows
  static bool get isWindows => !kIsWeb && Platform.isWindows;

  /// Check if running on macOS
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  /// Check if running on Linux
  static bool get isLinux => !kIsWeb && Platform.isLinux;

  /// Get platform name as string
  static String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  /// Check if platform supports biometric authentication
  static bool get supportsBiometrics => isMobile;

  /// Check if platform supports background services
  static bool get supportsBackgroundServices => isMobile || isDesktop;

  /// Check if platform supports file system access
  static bool get supportsFileSystem => !isWeb;

  /// Check if platform supports local notifications
  static bool get supportsNotifications => isMobile || isDesktop;

  /// Check if platform supports deep linking
  static bool get supportsDeepLinking => isMobile || isWeb;

  /// Check if running in debug mode
  static bool get isDebugMode => kDebugMode;

  /// Check if running in release mode
  static bool get isReleaseMode => kReleaseMode;

  /// Check if running in profile mode
  static bool get isProfileMode => kProfileMode;

  /// Get the operating system version
  static String get operatingSystemVersion {
    if (kIsWeb) return 'Web';
    return Platform.operatingSystemVersion;
  }

  /// Get the number of processors
  static int get numberOfProcessors {
    if (kIsWeb) return 1;
    return Platform.numberOfProcessors;
  }

  /// Get the path separator for the platform
  static String get pathSeparator {
    if (kIsWeb) return '/';
    return Platform.pathSeparator;
  }

  /// Get locale name
  static String get localeName {
    if (kIsWeb) return 'en_US';
    return Platform.localeName;
  }

  /// Execute platform-specific code
  static T execute<T>({
    required T Function() onWeb,
    required T Function() onAndroid,
    required T Function() onIOS,
    T Function()? onWindows,
    T Function()? onMacOS,
    T Function()? onLinux,
    T Function()? fallback,
  }) {
    if (isWeb) return onWeb();
    if (isAndroid) return onAndroid();
    if (isIOS) return onIOS();
    if (isWindows && onWindows != null) return onWindows();
    if (isMacOS && onMacOS != null) return onMacOS();
    if (isLinux && onLinux != null) return onLinux();
    if (fallback != null) return fallback();
    throw UnsupportedError('Platform not supported');
  }

  /// Check if dark mode is supported
  static bool get supportsDarkMode => true;

  /// Check if haptic feedback is supported
  static bool get supportsHapticFeedback => isMobile;
}
