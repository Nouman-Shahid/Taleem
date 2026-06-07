import 'package:flutter/material.dart';
import '../theme.dart';
import 'animations.dart';

enum ResultKind { correct, wrong, empty }

Future<void> showResultDialog(
  BuildContext context, {
  required ResultKind kind,
  required String target,
  String? predicted,
  double? confidence,
  String? customSubline,
  VoidCallback? onContinue,
  VoidCallback? onTryAgain,
  bool showRetryButton = false,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _ResultDialog(
      kind: kind,
      target: target,
      predicted: predicted,
      confidence: confidence,
      customSubline: customSubline,
      onContinue: onContinue,
      onTryAgain: onTryAgain,
      showRetryButton: showRetryButton,
    ),
  );
}

class _ResultDialog extends StatelessWidget {
  final ResultKind kind;
  final String target;
  final String? predicted;
  final double? confidence;
  final String? customSubline;
  final VoidCallback? onContinue;
  final VoidCallback? onTryAgain;
  final bool showRetryButton;

  const _ResultDialog({
    required this.kind,
    required this.target,
    required this.predicted,
    required this.confidence,
    required this.customSubline,
    required this.onContinue,
    required this.onTryAgain,
    required this.showRetryButton,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = kind == ResultKind.correct;
    final isEmpty = kind == ResultKind.empty;

    final accent = isCorrect
        ? AppColors.success
        : isEmpty
            ? AppColors.iconYellow
            : AppColors.error;
    final tint = isCorrect
        ? AppColors.cardGreen
        : isEmpty
            ? AppColors.cardYellow
            : const Color(0xFFFEF2F2);
    final icon = isCorrect
        ? Icons.check_circle_rounded
        : isEmpty
            ? Icons.edit_off_rounded
            : Icons.replay_rounded;
    final headline = isCorrect
        ? 'Great Job!'
        : isEmpty
            ? 'Nothing to check'
            : 'Try Again';

    String subline;
    if (customSubline != null) {
      subline = customSubline!;
    } else if (isEmpty) {
      subline = 'Write the letter on the canvas first.';
    } else if (isCorrect) {
      subline = predicted != null
          ? 'You wrote "$predicted" correctly!'
          : 'Correct answer!';
    } else {
      subline = predicted != null && predicted!.isNotEmpty
          ? 'Got "$predicted". Try writing "$target".'
          : 'That was not quite right.';
    }

    return Dialog(
      backgroundColor: AppColors.surface(context),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PopIn(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: tint,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: accent, size: 56),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              headline,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.text(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subline,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textBody,
                height: 1.4,
              ),
            ),
            if (confidence != null && !isEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.purple100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.psychology_rounded,
                        color: AppColors.brandPurple, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'AI Confidence: ${(confidence! * 100).round()}%',
                      style: const TextStyle(
                        color: AppColors.purple700,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 22),
            if (showRetryButton && !isCorrect) ...[
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onTryAgain?.call();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textBody,
                    side: const BorderSide(
                        color: AppColors.border, width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    textStyle: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  child: const Text('Try Again'),
                ),
              ),
              const SizedBox(height: 10),
            ],
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onContinue?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800),
                ),
                child: Text(isCorrect ? 'Continue' : 'OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
