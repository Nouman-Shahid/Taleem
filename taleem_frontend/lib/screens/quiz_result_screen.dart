import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/animations.dart';
import '../widgets/primary_button.dart';

class QuizResultScreen extends StatelessWidget {
  final int correct;
  final int total;
  final Color tint;
  final Color iconColor;
  final String quizTitle;

  const QuizResultScreen({
    super.key,
    required this.correct,
    required this.total,
    required this.tint,
    required this.iconColor,
    required this.quizTitle,
  });

  @override
  Widget build(BuildContext context) {
    final percent = total > 0 ? correct / total : 0.0;
    final isGreat = percent >= 0.8;
    final isOk = percent >= 0.5;
    final headline = isGreat ? 'Great job!' : isOk ? 'Well done!' : 'Keep going!';
    final subline = 'Great job on completing the quiz';

    return Scaffold(
      backgroundColor: AppColors.surface(context),
      appBar: AppBar(
        backgroundColor: AppColors.surface(context),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    PopIn(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: kPurpleGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.purple500.withValues(alpha: 0.4),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.emoji_events_rounded,
                            size: 64, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 22),
                    FadeSlideIn(
                        delay: const Duration(milliseconds: 250),
                        child: Text(headline, style: AppTextStyles.h1)),
                    const SizedBox(height: 6),
                    Text(subline,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.purple100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text('Your Score',
                              style: TextStyle(
                                color: AppColors.purple700,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              )),
                          const SizedBox(height: 8),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '$correct',
                                    style: const TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.brandPurple,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' / $total',
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.purple700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(percent * 100).toInt()}% accuracy',
                            style: const TextStyle(
                              color: AppColors.purple700,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _StatBox(
                            icon: Icons.check_circle_rounded,
                            iconColor: AppColors.success,
                            label: 'Correct',
                            value: '$correct',
                            bg: AppColors.cardGreen,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatBox(
                            icon: Icons.cancel_rounded,
                            iconColor: AppColors.error,
                            label: 'Wrong',
                            value: '${total - correct}',
                            bg: const Color(0xFFFEF2F2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: Column(
                children: [
                  PrimaryButton(
                    label: 'Try Again',
                    icon: Icons.refresh_rounded,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 10),
                  GhostButton(
                    label: 'Back to Home',
                    onPressed: () =>
                        Navigator.popUntil(context, (r) => r.isFirst),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color bg;

  const _StatBox({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 26),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: iconColor,
              )),
          Text(label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textBody,
              )),
        ],
      ),
    );
  }
}
