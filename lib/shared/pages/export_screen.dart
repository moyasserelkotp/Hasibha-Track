import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/cubit/home_state.dart';
import '../services/export_service.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/snackbars/app_snackbar.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  DateTime? startDate;
  DateTime? endDate;
  bool isExporting = false;

  final ExportService _exportService = ExportService();

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        startDate = picked;

        // Ensure end date is never before start date
        if (endDate != null && endDate!.isBefore(startDate!)) {
          endDate = startDate;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => endDate = picked);
    }
  }

  Future<void> _exportCSV() async {
    final state = context.read<HomeCubit>().state;

    if (state is! HomeLoaded) {
      AppSnackBar.showError(context, message: 'No data to export');
      return;
    }

    setState(() => isExporting = true);

    try {
      final transactions = state.dashboardSummary.recentTransactions;

      final file = await _exportService.exportToCSV(
        transactions,
        startDate: startDate,
        endDate: endDate,
      );

      if (!mounted) return;
      setState(() => isExporting = false);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Export Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('File: ${file.path.split('/').last}'),
              const SizedBox(height: 8),
              Text('Size: ${_exportService.getFileSize(file)}'),
              const SizedBox(height: 8),
              Text('Transactions: ${transactions.length}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                _exportService.shareFile(file, 'Transaction Export');
                Navigator.pop(context);
              },
              child: const Text('Share'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isExporting = false);
      AppSnackBar.showError(context, message: 'Export failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Export Data')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Export Transactions', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Export your transaction data as a CSV file.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),

            /// DATE RANGE CARD
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date Range (Optional)', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _selectStartDate,
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              startDate != null
                                  ? DateFormat('MMM dd, yyyy').format(startDate!)
                                  : 'Start Date',
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _selectEndDate,
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              endDate != null
                                  ? DateFormat('MMM dd, yyyy').format(endDate!)
                                  : 'End Date',
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (startDate != null || endDate != null) ...[
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            startDate = null;
                            endDate = null;
                          });
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear Dates'),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// EXPORT BUTTON
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: isExporting ? null : _exportCSV,
                text: 'Export as CSV',
                child: isExporting
                    ? const SizedBox(
                  height: 20, width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Export as CSV'),
              ),
            ),

            const SizedBox(height: 16),

            /// INFO CARD
            Card(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: theme.colorScheme.primary),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'The CSV file can be opened in Excel, Google Sheets, or any spreadsheet app.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
