import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 2)
class AppSettings {
  @HiveField(0, defaultValue: 'USD')
  final String currency;
  
  @HiveField(1, defaultValue: 'MM/dd/yyyy')
  final String dateFormat;
  
  @HiveField(2, defaultValue: 'system')
  final String theme;
  
  @HiveField(3, defaultValue: 1)
  final int firstDayOfWeek;
  
  @HiveField(4, defaultValue: 'en')
  final String language;
  
  @HiveField(5, defaultValue: true)
  final bool enableNotifications;
  
  @HiveField(6, defaultValue: true)
  final bool enableHapticFeedback;

  AppSettings({
    this.currency = 'USD',
    this.dateFormat = 'MM/dd/yyyy',
    this.theme = 'system',
    this.firstDayOfWeek = 1,
    this.language = 'en',
    this.enableNotifications = true,
    this.enableHapticFeedback = true,
  });

  AppSettings copyWith({
    String? currency,
    String? dateFormat,
    String? theme,
    int? firstDayOfWeek,
    String? language,
    bool? enableNotifications,
    bool? enableHapticFeedback,
  }) {
    return AppSettings(
      currency: currency ?? this.currency,
      dateFormat: dateFormat ?? this.dateFormat,
      theme: theme ?? this.theme,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      language: language ?? this.language,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
    );
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      currency: json['currency'] as String? ?? 'USD',
      dateFormat: json['dateFormat'] as String? ?? 'MM/dd/yyyy',
      theme: json['theme'] as String? ?? 'system',
      firstDayOfWeek: json['firstDayOfWeek'] as int? ?? 1,
      language: json['language'] as String? ?? 'en',
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      enableHapticFeedback: json['enableHapticFeedback'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'dateFormat': dateFormat,
      'theme': theme,
      'firstDayOfWeek': firstDayOfWeek,
      'language': language,
      'enableNotifications': enableNotifications,
      'enableHapticFeedback': enableHapticFeedback,
    };
  }
}
