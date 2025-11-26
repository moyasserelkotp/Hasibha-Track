extension StringExtensions on String {
  // Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  // Capitalize each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  // Check if string is email
  bool get isEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  // Check if string is phone number
  bool get isPhoneNumber {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(replaceAll(RegExp(r'[^0-9]'), ''));
  }

  // Check if string is numeric
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  // Check if string is URL
  bool get isUrl {
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return urlRegex.hasMatch(this);
  }

  // Remove spaces
  String get removeSpaces {
    return replaceAll(' ', '');
  }

  // Truncate string
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  // Parse to double safely
  double? get toDoubleOrNull {
    return double.tryParse(this);
  }

  // Parse to int safely
  int? get toIntOrNull {
    return int.tryParse(this);
  }

  // Check if string is empty or null
  bool get isNullOrEmpty {
    return trim().isEmpty;
  }

  // Reverse string
  String get reverse {
    return split('').reversed.join('');
  }

  // Count words
  int get wordCount {
    return trim().split(RegExp(r'\s+')).length;
  }

  // Remove HTML tags
  String get removeHtmlTags {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }

  // To snake_case
  String get toSnakeCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst('_', '');
  }

  // To camelCase
  String get toCamelCase {
    final words = split('_');
    if (words.isEmpty) return this;
    return words[0] + words.skip(1).map((w) => w.capitalize).join('');
  }
}
