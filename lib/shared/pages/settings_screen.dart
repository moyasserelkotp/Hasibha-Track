import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../cubit/theme_cubit.dart';
import '../services/backup_service.dart';
import '../widgets/snackbars/app_snackbar.dart';
import '../../di/injection.dart' as di;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _exportBackup(BuildContext context) async {
    try {
      final backupService = di.sl<BackupService>();
      final file = await backupService.exportBackup();
      
      if (!context.mounted) return;
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Backup Created'),
          content: Text('Backup saved to:\n${file.path}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                backupService.shareBackup(file);
                Navigator.pop(context);
              },
              child: const Text('Share'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      AppSnackBar.showError(context, message: 'Backup failed: $e');
    }
  }

  Future<void> _importBackup(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.single.path == null) return;

      if (!context.mounted) return;

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Import Backup?'),
          content: const Text(
            'This will replace all current data. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Import'),
            ),
          ],
        ),
      );

      if (confirmed != true || !context.mounted) return;

      final backupService = di.sl<BackupService>();
      final file = File(result.files.single.path!);
      await backupService.importBackup(file);

      if (!context.mounted) return;
      AppSnackBar.showSuccess(context, message: 'Backup imported successfully');
    } catch (e) {
      if (!context.mounted) return;
      AppSnackBar.showError(context, message: 'Import failed: $e');
    }
  }

  Future<void> _clearAllData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will delete all transactions. Categories and settings will be kept. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final backupService = di.sl<BackupService>();
      await backupService.clearAllData();
      
      if (!context.mounted) return;
      AppSnackBar.showSuccess(context, message: 'All data cleared');
    } catch (e) {
      if (!context.mounted) return;
      AppSnackBar.showError(context, message: 'Failed to clear data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Appearance Section
          _buildSectionHeader(context, 'Appearance'),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text('Theme'),
                subtitle: Text(_getThemeName(themeMode)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showThemeDialog(context),
              );
            },
          ),

          const Divider(),

          // Preferences Section
          _buildSectionHeader(context, 'Preferences'),
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              if (state is SettingsLoaded) {
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.attach_money),
                      title: const Text('Currency'),
                      subtitle: Text(state.settings.currency),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showCurrencyDialog(context, state.settings.currency),
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Date Format'),
                      subtitle: Text(state.settings.dateFormat),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showDateFormatDialog(context, state.settings.dateFormat),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),

          const Divider(),

          // Data Management Section
          _buildSectionHeader(context, 'Data Management'),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Backup Data'),
            subtitle: const Text('Export all data as JSON'),
            onTap: () => _exportBackup(context),
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Restore Data'),
            subtitle: const Text('Import data from backup'),
            onTap: () => _importBackup(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('Clear All Data'),
            subtitle: const Text('Delete all transactions'),
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () => _clearAllData(context),
          ),

          const Divider(),

          // About Section
          _buildSectionHeader(context, 'About'),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),
          const ListTile(
            leading: Icon(Icons.code),
            title: Text('Developer'),
            subtitle: Text('Built with Flutter'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  String _getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System Default';
    }
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(context, 'Light', ThemeMode.light),
            _buildThemeOption(context, 'Dark', ThemeMode.dark),
            _buildThemeOption(context, 'System Default', ThemeMode.system),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, String title, ThemeMode mode) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, currentMode) {
        return RadioListTile<ThemeMode>(
          title: Text(title),
          value: mode,
          groupValue: currentMode,
          onChanged: (value) {
            if (value != null) {
              context.read<ThemeCubit>().setTheme(value);
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  void _showCurrencyDialog(BuildContext context, String currentCurrency) {
    final currencies = ['USD', 'EUR', 'GBP', 'EGP', 'SAR', 'AED'];
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies.map((currency) {
            return RadioListTile<String>(
              title: Text(currency),
              value: currency,
              groupValue: currentCurrency,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsCubit>().updateCurrency(value);
                  Navigator.pop(dialogContext);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDateFormatDialog(BuildContext context, String currentFormat) {
    final formats = {
      'MM/dd/yyyy': 'MM/DD/YYYY (US)',
      'dd/MM/yyyy': 'DD/MM/YYYY (EU)',
      'yyyy-MM-dd': 'YYYY-MM-DD (ISO)',
    };
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Select Date Format'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: formats.entries.map((entry) {
            return RadioListTile<String>(
              title: Text(entry.value),
              value: entry.key,
              groupValue: currentFormat,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsCubit>().updateDateFormat(value);
                  Navigator.pop(dialogContext);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
