import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:avatar_glow/avatar_glow.dart';
import '../../../../di/injection.dart' as di;
import '../../../../shared/const/colors.dart';
import '../../../../shared/services/voice_input_service.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../domain/entities/expense.dart';
import '../blocs/expense/expense_bloc.dart';
import '../blocs/expense/expense_event.dart';

class VoiceExpenseDialog extends StatefulWidget {
  const VoiceExpenseDialog({super.key});

  @override
  State<VoiceExpenseDialog> createState() => _VoiceExpenseDialogState();
}

class _VoiceExpenseDialogState extends State<VoiceExpenseDialog> {
  final VoiceInputService _voiceService = di.sl<VoiceInputService>();
  String _transcription = '';
  String _partialTranscription = '';
  bool _isListening = false;
  Map<String, dynamic>? _parsedData;

  @override
  void initState() {
    super.initState();
    _initializeVoice();
  }

  Future<void> _initializeVoice() async {
    final initialized = await _voiceService.initialize();
    if (!initialized && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microphone permission required'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _startListening() async {
    try {
      setState(() {
        _isListening = true;
        _transcription = '';
        _partialTranscription = '';
        _parsedData = null;
      });

      await _voiceService.startListening(
        onResult: (text) {
          setState(() {
            _transcription = text;
            _isListening = false;
            _parsedData = _voiceService.parseExpenseFromVoice(text);
          });
        },
        onPartialResult: (text) {
          setState(() {
            _partialTranscription = text;
          });
        },
      );
    } catch (e) {
      setState(() {
        _isListening = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _stopListening() async {
    await _voiceService.stopListening();
    setState(() {
      _isListening = false;
    });
  }

  void _saveExpense() {
    if (_parsedData == null) return;

    final expense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: _parsedData!['amount'],
      categoryId: _parsedData!['category'] ?? 'other',
      description: _parsedData!['description'] ?? _transcription,
      date: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      // type is not in Expense entity, assuming handled by category or implicit
    );

    context.read<ExpenseBloc>().add(CreateExpense(expense));
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _voiceService.cancelListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _isListening ? AppColors.primary : Colors.white,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'Voice Expense Entry',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: _isListening ? Colors.white : AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _isListening
                  ? 'Listening...'
                  : 'Tap the microphone to speak',
              style: TextStyle(
                fontSize: 12.sp,
                color: _isListening
                    ? Colors.white.withAlpha(204)
                    : AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 24.h),

            // Microphone Button with Glow
            AvatarGlow(
              animate: _isListening,
              glowColor: AppColors.primary,
              // radius: 90.r, // Try radius if endRadius/glowRadius fail, or omit for default
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              child: GestureDetector(
                onTap: _isListening ? _stopListening : _startListening,
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isListening ? AppColors.error : AppColors.primary,
                    boxShadow: [
                      BoxShadow(
                        color: (_isListening ? AppColors.error : AppColors.primary)
                            .withAlpha(102),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isListening ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 40.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Transcription Display
            if (_isListening && _partialTranscription.isNotEmpty)
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.grey.withAlpha(51),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  _partialTranscription,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            if (!_isListening && _transcription.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha(51),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.success),
                ),
                child: Column(
                  children: [
                    Text(
                      '"$_transcription"',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_parsedData != null) ...[
                      SizedBox(height: 12.h),
                      Divider(),
                      SizedBox(height: 8.h),
                      _buildParsedDataRow(
                        'Amount',
                        '\$${_parsedData!['amount'].toStringAsFixed(2)}',
                      ),
                      if (_parsedData!['category'] != null)
                        _buildParsedDataRow(
                          'Category',
                          _parsedData!['category'].toString().toUpperCase(),
                        ),
                      _buildParsedDataRow(
                        'Type',
                        _parsedData!['type'].toString().toUpperCase(),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _transcription = '';
                          _parsedData = null;
                        });
                        _startListening();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: const Text('Try Again'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: PrimaryButton(
                      onPressed: _parsedData != null ? _saveExpense : null,
                      text: 'Save',
                    ),
                  ),
                ],
              ),
            ] else if (!_isListening)
              Text(
                'Example: "I spent 50 dollars on groceries"',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildParsedDataRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
