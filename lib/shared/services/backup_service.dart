import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../features/home/data/datasources/local/home_local_data_source.dart';
import '../../features/home/data/models/transaction_model.dart';
import '../../features/home/data/models/category_model.dart';
import '../models/app_settings.dart';

class BackupService {
  final HomeLocalDataSource localDataSource;

  BackupService({required this.localDataSource});

  /// Export all app data to JSON file
  Future<File> exportBackup() async {
    // Get all data
    final transactions = await localDataSource.getTransactions();
    final categories = await localDataSource.getCategories();
    final settings = await localDataSource.getSettings();

    // Create backup object
    final backup = {
      'version': '1.0',
      'exportDate': DateTime.now().toIso8601String(),
      'appName': 'Hasibha',
      'transactions': transactions
          .cast<TransactionModel>()
          .map((t) => t.toJson())
          .toList(),
      'categories': categories
          .cast<CategoryModel>()
          .map((c) => c.toJson())
          .toList(),
      'settings': settings,
    };

    // Convert to JSON
    final jsonString = const JsonEncoder.withIndent('  ').convert(backup);

    // Create file
    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'hasibha_backup_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.json';
    final file = File('${directory.path}/$fileName');

    // Write to file
    await file.writeAsString(jsonString);

    return file;
  }

  /// Import backup from JSON file
  Future<void> importBackup(File file) async {
    try {
      // Read file
      final jsonString = await file.readAsString();
      final Map<String, dynamic> backup = jsonDecode(jsonString);

      // Validate backup
      if (backup['version'] != '1.0') {
        throw Exception('Unsupported backup version');
      }

      // Clear existing data
      await localDataSource.clearAllTransactions();

      // Import transactions
      if (backup['transactions'] != null) {
        for (final transactionJson in backup['transactions']) {
          final transaction = TransactionModel.fromJson(transactionJson);
          await localDataSource.addTransaction(transaction);
        }
      }

      // Import categories (skip if they already exist)
      if (backup['categories'] != null) {
        for (final categoryJson in backup['categories']) {
          final category = CategoryModel.fromJson(categoryJson);
          try {
            await localDataSource.addCategory(category);
          } catch (e) {
            // Category might already exist, skip
          }
        }
      }

      // Import settings
      if (backup['settings'] != null) {
        final settings = AppSettings.fromJson(backup['settings']);
        await localDataSource.saveSettings(settings);
      }
    } catch (e) {
      throw Exception('Failed to import backup: $e');
    }
  }

  /// Share backup file
  Future<void> shareBackup(File file) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Hasibha Backup - ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
      text: 'Hasibha app data backup',
    );
  }

  /// Clear all app data
  Future<void> clearAllData() async {
    await localDataSource.clearAllTransactions();
    // Categories are kept (including custom ones)
    // Settings are kept
  }
}
