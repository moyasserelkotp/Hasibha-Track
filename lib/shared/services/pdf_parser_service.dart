import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'logger_service.dart';

class PdfParserService {
  final _logger = LoggerService();
  /// Pick and parse PDF file
  Future<List<Map<String, dynamic>>?> importFromPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.isEmpty) return null;

      final file = File(result.files.first.path!);
      return await parsePdfTransactions(file);
    } catch (e) {
      _logger.error('Error importing PDF: $e');
      return null;
    }
  }

  /// Parse PDF and extract transactions
  Future<List<Map<String, dynamic>>> parsePdfTransactions(File pdfFile) async {
    try {
      final bytes = await pdfFile.readAsBytes();
      // Note: PDF text extraction requires platform-specific implementation
      // This is a simplified version - in production, use pdf_text or similar
      
      final text = await _extractTextFromPdf(bytes);
      return _parseTransactionsFromText(text);
    } catch (e) {
      _logger.error('Error parsing PDF: $e');
      return [];
    }
  }

  /// Extract text from PDF bytes (simplified)
  Future<String> _extractTextFromPdf(List<int> bytes) async {
    // This is a placeholder - actual PDF text extraction requires
    // native platform code or specialized packages like pdf_text
    // For now, return instructions for manual processing
    return '''
    PDF Import Note:
    Due to platform limitations, please manually review the PDF
    and enter transactions. Future updates will support automatic extraction.
    
    Look for:
    - Transaction dates
    - Amounts (debits/credits)
    - Descriptions/merchants
    - Categories
    ''';
  }

  /// Parse transactions from extracted text
  List<Map<String, dynamic>> _parseTransactionsFromText(String text) {
    final transactions = <Map<String, dynamic>>[];
    final lines = text.split('\n');

    // Pattern for typical bank statement line:
    // Date Description Amount
    final transactionPattern = RegExp(
      r'(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})\s+(.+?)\s+([-+]?\$?\s*[\d,]+\.\d{2})',
    );

    for (final line in lines) {
      final match = transactionPattern.firstMatch(line);
      if (match != null) {
        try {
          final dateStr = match.group(1)!;
          final description = match.group(2)!.trim();
          final amountStr = match.group(3)!.replaceAll(RegExp(r'[\$,]'), '');
          
          final amount = double.tryParse(amountStr);
          if (amount == null) continue;

          final date = _parseDate(dateStr);

          transactions.add({
            'date': date,
            'description': description,
            'amount': amount.abs(),
            'type': amount < 0 ? 'expense' : 'income',
            'category': _inferCategoryFromDescription(description),
          });
        } catch (e) {
          // Skip malformed entries
          continue;
        }
      }
    }

    return transactions;
  }

  /// Parse date string
  DateTime _parseDate(String dateStr) {
    try {
      final parts = dateStr.split(RegExp(r'[/-]'));
      if (parts.length == 3) {
        int month = int.parse(parts[0]);
        int day = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        if (year < 100) year += 2000;
        return DateTime(year, month, day);
      }
    } catch (e) {
      // Return current date if parsing fails
    }
    return DateTime.now();
  }

  /// Infer category from transaction description
  String _inferCategoryFromDescription(String description) {
    final lower = description.toLowerCase();

    if (lower.contains('grocery') || lower.contains('market') || lower.contains('food')) {
      return 'food';
    } else if (lower.contains('gas') || lower.contains('fuel')) {
      return 'transport';
    } else if (lower.contains('amazon') || lower.contains('walmart') || lower.contains('target')) {
      return 'shopping';
    } else if (lower.contains('netflix') || lower.contains('spotify') || lower.contains('subscription')) {
      return 'entertainment';
    } else if (lower.contains('electric') || lower.contains('water') || lower.contains('internet')) {
      return 'bills';
    }

    return 'other';
  }
}
