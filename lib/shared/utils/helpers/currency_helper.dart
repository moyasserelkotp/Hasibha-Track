import 'package:intl/intl.dart';

/// Currency helper utilities for formatting and parsing currency values
class CurrencyHelper {
  /// Default currency symbol
  static String _defaultCurrencySymbol = '\$';
  
  /// Default locale
  static String _defaultLocale = 'en_US';

  /// Set the default currency symbol
  static void setDefaultCurrency(String symbol) {
    _defaultCurrencySymbol = symbol;
  }

  /// Set the default locale
  static void setDefaultLocale(String locale) {
    _defaultLocale = locale;
  }

  /// Format a number as currency with symbol (e.g., "$1,234.56")
  static String format(
    num amount, {
    String? symbol,
    String? locale,
    int decimalDigits = 2,
  }) {
    final currencySymbol = symbol ?? _defaultCurrencySymbol;
    final currencyLocale = locale ?? _defaultLocale;
    
    final formatter = NumberFormat.currency(
      locale: currencyLocale,
      symbol: currencySymbol,
      decimalDigits: decimalDigits,
    );
    
    return formatter.format(amount);
  }

  /// Format a number as currency without symbol (e.g., "1,234.56")
  static String formatWithoutSymbol(
    num amount, {
    String? locale,
    int decimalDigits = 2,
  }) {
    final currencyLocale = locale ?? _defaultLocale;
    
    final formatter = NumberFormat.currency(
      locale: currencyLocale,
      symbol: '',
      decimalDigits: decimalDigits,
    );
    
    return formatter.format(amount).trim();
  }

  /// Format a number as compact currency (e.g., "$1.2K", "$1.5M")
  static String formatCompact(
    num amount, {
    String? symbol,
    String? locale,
  }) {
    final currencySymbol = symbol ?? _defaultCurrencySymbol;
    final currencyLocale = locale ?? _defaultLocale;
    
    final formatter = NumberFormat.compactCurrency(
      locale: currencyLocale,
      symbol: currencySymbol,
    );
    
    return formatter.format(amount);
  }

  /// Parse a currency string to a double
  static double? parse(String currencyString) {
    try {
      // Remove currency symbols and whitespace
      String cleaned = currencyString
          .replaceAll(RegExp(r'[^\d.,\-]'), '')
          .replaceAll(',', '');
      
      return double.parse(cleaned);
    } catch (e) {
      return null;
    }
  }

  /// Format amount with color indication (positive = green, negative = red)
  static String formatWithSign(num amount, {String? symbol}) {
    final formatted = format(amount, symbol: symbol);
    if (amount >= 0) {
      return '+$formatted';
    }
    return formatted;
  }

  /// Get formatted amount for display in transaction lists
  static String formatTransaction(
    num amount, {
    required bool isIncome,
    String? symbol,
  }) {
    final formatted = format(amount.abs(), symbol: symbol);
    return isIncome ? '+$formatted' : '-$formatted';
  }

  /// Format percentage (e.g., "15.5%")
  static String formatPercentage(
    num value, {
    int decimalDigits = 1,
  }) {
    final formatter = NumberFormat.decimalPattern();
    formatter.minimumFractionDigits = decimalDigits;
    formatter.maximumFractionDigits = decimalDigits;
    return '${formatter.format(value)}%';
  }

  /// Format a large number with abbreviations (K, M, B)
  static String formatAbbreviated(num amount) {
    if (amount.abs() >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount.abs() >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount.abs() >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }

  /// Validate if a string is a valid currency amount
  static bool isValidAmount(String amount) {
    final cleaned = amount.replaceAll(RegExp(r'[^\d.,\-]'), '');
    final parsed = double.tryParse(cleaned.replaceAll(',', ''));
    return parsed != null && parsed >= 0;
  }

  /// Convert amount to words (e.g., 1234 -> "One Thousand Two Hundred Thirty Four")
  static String toWords(int amount) {
    if (amount == 0) return 'Zero';

    final ones = ['', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine'];
    final teens = ['Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'];
    final tens = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];
    final thousands = ['', 'Thousand', 'Million', 'Billion'];

    String convertHundreds(int num) {
      String result = '';
      if (num >= 100) {
        result += '${ones[num ~/ 100]} Hundred ';
        num %= 100;
      }
      if (num >= 20) {
        result += '${tens[num ~/ 10]} ';
        num %= 10;
      } else if (num >= 10) {
        result += '${teens[num - 10]} ';
        return result;
      }
      if (num > 0) {
        result += '${ones[num]} ';
      }
      return result;
    }

    String result = '';
    int thousandCounter = 0;
    
    while (amount > 0) {
      if (amount % 1000 != 0) {
        result = '${convertHundreds(amount % 1000)}${thousands[thousandCounter]} $result';
      }
      amount ~/= 1000;
      thousandCounter++;
    }

    return result.trim();
  }
}
