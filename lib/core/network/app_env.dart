/// Environment configuration for the Hasibha app.
/// Use --dart-define=APP_ENV=prod to switch environments.
enum AppEnvironment { dev, staging, prod }

class AppEnv {
  AppEnv._();

  static const String _envKey = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static AppEnvironment get current {
    switch (_envKey) {
      case 'prod':
        return AppEnvironment.prod;
      case 'staging':
        return AppEnvironment.staging;
      default:
        return AppEnvironment.dev;
    }
  }

  static bool get isDev => current == AppEnvironment.dev;
  static bool get isStaging => current == AppEnvironment.staging;
  static bool get isProd => current == AppEnvironment.prod;

  // Auth service base URL (port 3210)
  static String get authBaseUrl {
    switch (current) {
      case AppEnvironment.prod:
        return 'https://api.hasibha.com';
      case AppEnvironment.staging:
        return 'https://staging-api.hasibha.com';
      case AppEnvironment.dev:
        return 'http://localhost:3210';
    }
  }

  // Home/budget service base URL (port 5001)
  static String get homeBaseUrl {
    switch (current) {
      case AppEnvironment.prod:
        return 'https://home-api.hasibha.com';
      case AppEnvironment.staging:
        return 'https://staging-home-api.hasibha.com';
      case AppEnvironment.dev:
        return 'http://localhost:5001';
    }
  }

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
