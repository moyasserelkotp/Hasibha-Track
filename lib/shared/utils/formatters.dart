import 'package:intl/intl.dart';

class Formatters {
  // Currency Formatter
  static String currency(double amount, {String symbol = '\$', int decimalDigits = 2}) {
    final format = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return format.format(amount);
  }

  // Currency with compact notation (e.g., $1.2K)
  static String currencyCompact(double amount, {String symbol = '\$'}) {
    final format = NumberFormat.compactCurrency(
      symbol: symbol,
      decimalDigits: 1,
    );
    return format.format(amount);
  }

  // Number formatter
  static String number(num value, {int decimalDigits = 0}) {
    final format = NumberFormat.decimalPattern();
    if (decimalDigits > 0) {
      return value.toStringAsFixed(decimalDigits);
    }
    return format.format(value);
  }

  // Percentage formatter
  static String percentage(double value, {int decimalDigits = 1}) {
    return '${(value * 100).toStringAsFixed(decimalDigits)}%';
  }

  // Date Formatters
  static String date(DateTime date, {String pattern = 'MMM dd, yyyy'}) {
    final format = DateFormat(pattern);
    return format.format(date);
  }

  static String dateTime(DateTime date, {String pattern = 'MMM dd, yyyy hh:mm a'}) {
    final format = DateFormat(pattern);
    return format.format(date);
  }

  static String time(DateTime date, {String pattern = 'hh:mm a'}) {
    final format = DateFormat(pattern);
    return format.format(date);
  }

  static String dateShort(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  static String dateLong(DateTime date) {
    return DateFormat('EEEE, MMMM dd, yyyy').format(date);
  }

  // Relative time (handled by timeago package, but included for reference)
  static String relativeTime(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  // Phone number formatter (basic)
  static String phoneNumber(String number) {
    if (number.length == 10) {
      return '(${number.substring(0, 3)}) ${number.substring(3, 6)}-${number.substring(6)}';
    }
    return number;
  }

  // File size formatter
  static String fileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
