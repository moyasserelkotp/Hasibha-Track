import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  /// Extract text and structured data from receipt image
  Future<Map<String, dynamic>> extractTextFromImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      // Extract all text
      final String fullText = recognizedText.text;

      // Parse structured data from the text
      final result = _parseReceiptText(fullText);

      return result;
    } catch (e) {
      throw Exception('Failed to process image: ${e.toString()}');
    }
  }

  /// Parse receipt text to extract amount, date, merchant, etc.
  Map<String, dynamic> _parseReceiptText(String text) {
    final result = <String, dynamic>{};

    // Extract amount (looking for patterns like $XX.XX, XX.XX, etc.)
    final amountRegex = RegExp(r'[\$€£]?\s*(\d+[.,]\d{2})');
    final amountMatch = amountRegex.allMatches(text);
    
    if (amountMatch.isNotEmpty) {
      // Try to find the total amount (usually labeled)
      for (final match in amountMatch) {
        final beforeMatch = text.substring(0, match.start).toLowerCase();
        if (beforeMatch.contains('total') || 
            beforeMatch.contains('amount') ||
            beforeMatch.contains('sum')) {
          final amountStr = match.group(1)?.replaceAll(',', '.') ?? '0';
          result['amount'] = double.tryParse(amountStr) ?? 0.0;
          break;
        }
      }
      
      // If no labeled total found, use the largest amount
      if (result['amount'] == null) {
        double maxAmount = 0.0;
        for (final match in amountMatch) {
          final amountStr = match.group(1)?.replaceAll(',', '.') ?? '0';
          final amount = double.tryParse(amountStr) ?? 0.0;
          if (amount > maxAmount) {
            maxAmount = amount;
          }
        }
        result['amount'] = maxAmount;
      }
    } else {
      result['amount'] = 0.0;
    }

    // Extract date (various formats)
    final dateRegex = RegExp(
      r'(\d{1,2}[-/]\d{1,2}[-/]\d{2,4})|(\d{4}[-/]\d{1,2}[-/]\d{1,2})',
    );
    final dateMatch = dateRegex.firstMatch(text);
    
    if (dateMatch != null) {
      try {
        final dateStr = dateMatch.group(0) ?? '';
        result['date'] = _parseDate(dateStr);
      } catch (e) {
        result['date'] = DateTime.now();
      }
    } else {
      result['date'] = DateTime.now();
    }

    // Extract merchant name (usually at the top of the receipt)
    final lines = text.split('\n');
    if (lines.isNotEmpty) {
      // Take the first non-empty line as merchant name
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isNotEmpty && trimmed.length > 2) {
          result['merchant'] = trimmed;
          break;
        }
      }
    }

    // Try to guess category based on merchant name
    result['categoryId'] = _guessCategory(result['merchant'] as String?);

    // Use full text as description
    result['description'] = text.substring(0, text.length > 200 ? 200 : text.length);

    return result;
  }

  /// Parse various date formats
  DateTime _parseDate(String dateStr) {
    try {
      // Try different separators
      for (final separator in ['-', '/', '.']) {
        final parts = dateStr.split(separator);
        
        if (parts.length == 3) {
          int year, month, day;
          
          // Check if year is first (YYYY-MM-DD format)
          if (parts[0].length == 4) {
            year = int.parse(parts[0]);
            month = int.parse(parts[1]);
            day = int.parse(parts[2]);
          }
          // Otherwise assume DD-MM-YYYY or MM-DD-YYYY
          else {
            // Try DD-MM-YYYY first
            day = int.parse(parts[0]);
            month = int.parse(parts[1]);
            year = int.parse(parts[2]);
            
            // Handle 2-digit years
            if (year < 100) {
              year += 2000;
            }
          }
          
          return DateTime(year, month, day);
        }
      }
    } catch (e) {
      // If parsing fails, return current date
    }
    
    return DateTime.now();
  }

  /// Guess category based on merchant name
  String _guessCategory(String? merchant) {
    if (merchant == null) return '';
    
    final lowerMerchant = merchant.toLowerCase();
    
    // Food & Dining
    if (lowerMerchant.contains('restaurant') ||
        lowerMerchant.contains('cafe') ||
        lowerMerchant.contains('coffee') ||
        lowerMerchant.contains('pizza') ||
        lowerMerchant.contains('burger')) {
      return 'food_dining';
    }
    
    // Groceries
    if (lowerMerchant.contains('supermarket') ||
        lowerMerchant.contains('grocery') ||
        lowerMerchant.contains('market')) {
      return 'groceries';
    }
    
    // Transportation
    if (lowerMerchant.contains('gas') ||
        lowerMerchant.contains('fuel') ||
        lowerMerchant.contains('uber') ||
        lowerMerchant.contains('taxi')) {
      return 'transportation';
    }
    
    // Shopping
    if (lowerMerchant.contains('store') ||
        lowerMerchant.contains('shop') ||
        lowerMerchant.contains('mall')) {
      return 'shopping';
    }
    
    // Default to uncategorized
    return '';
  }

  void dispose() {
    _textRecognizer.close();
  }
}
