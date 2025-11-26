import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../../../../shared/const/colors.dart';

class MultiFormatEntryButtons extends StatefulWidget {
  final Function(String imagePath) onImageSelected;
  final Function(String text) onVoiceRecorded;

  const MultiFormatEntryButtons({
    super.key,
    required this.onImageSelected,
    required this.onVoiceRecorded,
  });

  @override
  State<MultiFormatEntryButtons> createState() => _MultiFormatEntryButtonsState();
}

class _MultiFormatEntryButtonsState extends State<MultiFormatEntryButtons> {
  final ImagePicker _picker = ImagePicker();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  Future<void> _pickImageFromCamera() async {
    // Request camera permission
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission denied')),
        );
      }
      return;
    }

    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null) {
      widget.onImageSelected(image.path);
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      widget.onImageSelected(image.path);
    }
  }

  Future<void> _startListening() async {
    // Request microphone permission
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission denied')),
        );
      }
      return;
    }

    final available = await _speech.initialize();
    if (!available) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Speech recognition not available')),
        );
      }
      return;
    }

    setState(() => _isListening = true);

    _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          widget.onVoiceRecorded(result.recognizedWords);
          setState(() => _isListening = false);
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
    );
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Entry',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              // Camera Button
              Expanded(
                child: _buildEntryButton(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: _pickImageFromCamera,
                ),
              ),
              SizedBox(width: 8.w),
              
              // Gallery Button
              Expanded(
                child: _buildEntryButton(
                  icon: Icons.image,
                  label: 'Gallery',
                  onTap: _pickImageFromGallery,
                ),
              ),
              SizedBox(width: 8.w),
              
              // Voice Button
              Expanded(
                child: _buildEntryButton(
                  icon: _isListening ? Icons.mic : Icons.mic_none,
                  label: _isListening ? 'Listening...' : 'Voice',
                  onTap: _isListening ? _stopListening : _startListening,
                  color: _isListening ? AppColors.accent : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEntryButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: color ?? AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: color != null ? AppColors.white : AppColors.primary,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: color != null ? AppColors.white : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
