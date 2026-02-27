import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1C1E),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        children: [
          // Appearance Section
          _buildSectionHeader(context, 'Appearance'),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return _buildSettingTile(
                icon: Icons.brightness_6_outlined,
                title: 'Theme',
                subtitle: _getThemeName(themeMode),
                onTap: () => _showThemeDialog(context),
              );
            },
          ),

          _buildDivider(),

          // Preferences Section
          _buildSectionHeader(context, 'Preferences'),
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              if (state is SettingsLoaded) {
                return Column(
                  children: [
                    _buildSettingTile(
                      icon: Icons.attach_money_rounded,
                      title: 'Currency',
                      subtitle: state.settings.currency,
                      onTap: () => _showCurrencyDialog(context, state.settings.currency),
                    ),
                    _buildSettingTile(
                      icon: Icons.calendar_today_outlined,
                      title: 'Date Format',
                      subtitle: state.settings.dateFormat,
                      onTap: () => _showDateFormatDialog(context, state.settings.dateFormat),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),

          _buildDivider(),

          // Data Management Section
          _buildSectionHeader(context, 'Data Management'),
          _buildSettingTile(
            icon: Icons.backup_outlined,
            title: 'Backup Data',
            subtitle: 'Export all data as JSON',
            onTap: () => _exportBackup(context),
          ),
          _buildSettingTile(
            icon: Icons.restore_outlined,
            title: 'Restore Data',
            subtitle: 'Import data from backup',
            onTap: () => _importBackup(context),
          ),
          _buildSettingTile(
            icon: Icons.delete_outline_rounded,
            title: 'Clear All Data',
            subtitle: 'Delete all transactions',
            subtitleColor: Colors.red.withValues(alpha: 0.7),
            titleColor: Colors.red,
            iconColor: Colors.red,
            onTap: () => _clearAllData(context),
          ),

          _buildDivider(),

          // About Section
          _buildSectionHeader(context, 'About'),
          _buildSettingTile(
            icon: Icons.info_outline_rounded,
            title: 'Version',
            subtitle: '1.0.0',
          ),
          _buildSettingTile(
            icon: Icons.code_rounded,
            title: 'Developer',
            subtitle: 'Built with Flutter',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF00BFA5),
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Color? iconColor,
    Color? titleColor,
    Color? subtitleColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? const Color(0xFF1A1C1E), size: 22.sp),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: titleColor ?? const Color(0xFF1A1C1E),
          fontSize: 15.sp,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: subtitleColor ?? Colors.grey[600],
                fontSize: 12.sp,
              ),
            )
          : null,
      trailing: onTap != null ? Icon(Icons.chevron_right_rounded, color: Colors.grey[400], size: 20.sp) : null,
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[50],
      indent: 16.w,
      endIndent: 16.w,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
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
          title: Text(title, style: TextStyle(fontSize: 15.sp)),
          value: mode,
          groupValue: currentMode,
          activeColor: const Color(0xFF00BFA5),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies.map((currency) {
            return RadioListTile<String>(
              title: Text(currency, style: TextStyle(fontSize: 15.sp)),
              value: currency,
              groupValue: currentCurrency,
              activeColor: const Color(0xFF00BFA5),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: formats.entries.map((entry) {
            return RadioListTile<String>(
              title: Text(entry.value, style: TextStyle(fontSize: 15.sp)),
              value: entry.key,
              groupValue: currentFormat,
              activeColor: const Color(0xFF00BFA5),
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
