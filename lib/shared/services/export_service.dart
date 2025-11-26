import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../features/home/domain/entities/transaction.dart';

class ExportService {
  /// Export transactions to CSV format
  Future<File> exportToCSV(
    List<Transaction> transactions, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Filter by date range if provided
    var filteredTransactions = transactions;
    if (startDate != null || endDate != null) {
      filteredTransactions = transactions.where((t) {
        if (startDate != null && t.date.isBefore(startDate)) return false;
        if (endDate != null && t.date.isAfter(endDate)) return false;
        return true;
      }).toList();
    }

    // Sort by date
    filteredTransactions.sort((a, b) => b.date.compareTo(a.date));

    // Create CSV data
    final List<List<dynamic>> rows = [
      ['Date', 'Type', 'Category', 'Title', 'Description', 'Amount'],
      ...filteredTransactions.map((t) => [
            DateFormat('yyyy-MM-dd').format(t.date),
            t.type.toUpperCase(),
            t.category,
            t.title,
            t.description ?? '',
            t.type == 'expense' ? '-${t.amount}' : t.amount.toString(),
          ]),
    ];

    // Convert to CSV string
    final csv = const ListToCsvConverter().convert(rows);

    // Get directory and create file
    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'transactions_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
    final file = File('${directory.path}/$fileName');

    // Write to file
    await file.writeAsString(csv);

    return file;
  }

  /// Share a file using the system share sheet
  Future<void> shareFile(File file, String subject) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: subject,
    );
  }

  /// Get file size in human-readable format
  String getFileSize(File file) {
    final bytes = file.lengthSync();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
