import 'dart:math';
import 'package:flutter/material.dart';

class CircularProgressButton extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final VoidCallback onTap;
  final bool isLastPage;
  final Color color;

  const CircularProgressButton({
    super.key,
    required this.progress,
    required this.onTap,
    this.isLastPage = false,
    this.color = const Color(0xFF00A38E),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer progress border (Arc)
          SizedBox(
            width: 86,
            height: 86,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 2.5,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          
          // Inner circular button
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              isLastPage ? Icons.check : Icons.arrow_forward,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
