import 'package:flutter/material.dart';
import '../theme.dart';

class LessonLoading extends StatelessWidget {
  const LessonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.brandPurple, strokeWidth: 3),
          SizedBox(height: 12),
          Text(
            'Loading lessons…',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class LessonErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const LessonErrorBox({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded,
              color: AppColors.textMuted, size: 40),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textBody,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Retry'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.brandPurple,
              side: const BorderSide(color: AppColors.brandPurple, width: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
