import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import 'logger_service.dart';

class EnhancedOcrService {
  final TextRecognizer _textRecognizer = TextRecognizer();
  final ImagePicker _imagePicker = ImagePicker();
  final _logger = Logger.get("EnhancedOcrService");

  /// Scan receipt from camera or gallery
  Future<Map<String, dynamic>?> scanReceipt({
    ImageSource source = ImageSource.camera,
  }) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) return null;

      return await processReceiptImage(image.path);
    } catch (e) {
      _logger.error('Error scanning receipt: $e');
      return null;
    }
  }

  /// Process receipt image and extract data
  Future<Map<String, dynamic>?> processReceiptImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      final extractedData = _extractReceiptData(recognizedText.text);
      extractedData['imagePath'] = imagePath;

      return extractedData;
    } catch (e) {
      _logger.error('Error processing receipt: $e');
      return null;
    }
  }

  /// Extract structured data from OCR text
  Map<String, dynamic> _extractReceiptData(String text) {
    final lines = text.split('\n');
    double? amount;
    DateTime? date;
    String? merchantName;
    List<String> items = [];

    // Extract amount (look for total, price patterns)
    final amountPatterns = [
      RegExp(r'total[:\s]*\$?\s*([\d,]+\.?\d*)', caseSensitive: false),
      RegExp(r'amount[:\s]*\$?\s*([\d,]+\.?\d*)', caseSensitive: false),
      RegExp(r'\$\s*([\d,]+\.\d{2})'),
    ];

    for (final pattern in amountPatterns) {
      final match = pattern.firstMatch(text.toLowerCase());
      if (match != null) {
        final amountStr = match.group(1)!.replaceAll(',', '');
        amount = double.tryParse(amountStr);
        if (amount != null) break;
      }
    }

    // Extract date
    final datePatterns = [
      RegExp(r'(\d{1,2})[/-](\d{1,2})[/-](\d{2,4})'),
      RegExp(r'(\d{4})[/-](\d{1,2})[/-](\d{1,2})'),
    ];

    for (final pattern in datePatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        try {
          int day, month, year;
          if (match.group(0)!.startsWith(RegExp(r'\d{4}'))) {
            // YYYY-MM-DD format
            year = int.parse(match.group(1)!);
            month = int.parse(match.group(2)!);
            day = int.parse(match.group(3)!);
          } else {
            // MM-DD-YYYY or DD-MM-YYYY format (assume MM-DD for US)
            month = int.parse(match.group(1)!);
            day = int.parse(match.group(2)!);
            year = int.parse(match.group(3)!);
            if (year < 100) year += 2000; // Convert 2-digit year
          }
          date = DateTime(year, month, day);
          break;
        } catch (e) {
          // Continue to next pattern
        }
      }
    }

    // Extract merchant name (usually first 1-3 lines)
    if (lines.isNotEmpty) {
      merchantName = lines.first.trim();
      if (merchantName.length > 50) {
        merchantName = merchantName.substring(0, 50);
      }
    }

    // Extract items (lines with prices)
    final itemPattern = RegExp(r'(.+?)\s+\$?\s*([\d,]+\.\d{2})');
    for (final line in lines) {
      final match = itemPattern.firstMatch(line);
      if (match != null && match.group(1) != null) {
        final itemName = match.group(1)!.trim();
        if (itemName.length > 3 && !itemName.toLowerCase().contains('total')) {
          items.add(itemName);
        }
      }
    }

    // Infer category from merchant name or items
    String category = _inferCategory(merchantName ?? '', items);

    return {
      'amount': amount,
      'date': date ?? DateTime.now(),
      'merchantName': merchantName,
      'category': category,
      'items': items,
      'rawText': text,
      'confidence': amount != null ? 0.8 : 0.5, // Simple confidence score
    };
  }

  /// Infer category from merchant/items
  String _inferCategory(String merchant, List<String> items) {
    final text = ('$merchant ${items.join(' ')}').toLowerCase();

    if (text.contains('grocery') || text.contains('market') || text.contains('food')) {
      return 'food';
    } else if (text.contains('gas') || text.contains('fuel') || text.contains('shell') || text.contains('exxon')) {
      return 'transport';
    } else if (text.contains('pharmacy') || text.contains('cvs') || text.contains('walgreens')) {
      return 'health';
    } else if (text.contains('restaurant') || text.contains('cafe') || text.contains('pizza')) {
      return 'food';
    } else if (text.contains('hotel') || text.contains('airline')) {
      return 'travel';
    }

    return 'other';
  }

  void dispose() {
    _textRecognizer.close();
  }
}
