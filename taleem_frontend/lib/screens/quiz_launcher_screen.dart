import 'package:flutter/material.dart';
import '../theme.dart';
import 'quiz_screen.dart';

class QuizLauncherScreen extends StatefulWidget {
  final String quizKey;
  final String quizTitle;

  const QuizLauncherScreen({
    super.key,
    required this.quizKey,
    required this.quizTitle,
  });

  @override
  State<QuizLauncherScreen> createState() => _QuizLauncherScreenState();
}

class _QuizLauncherScreenState extends State<QuizLauncherScreen> {
  String _mode = 'mcq';
  int _count = 5;

  static const _counts = [5, 10, 15, 20];

  void _start() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          quizKey: widget.quizKey,
          quizTitle: widget.quizTitle,
          mode: _mode,
          questionCount: _count,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Start Quiz'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: kPurpleGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.purple500.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.quiz_rounded,
                          color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      widget.quizTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Choose how you want to play',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _SectionTitle(text: 'Quiz Mode'),
              const SizedBox(height: 10),
              _ModeOptionTile(
                icon: Icons.image_outlined,
                iconColor: AppColors.iconBlue,
                bgColor: AppColors.cardBlue,
                title: 'Picture MCQ',
                subtitle: 'See an image, pick the right word',
                selected: _mode == 'mcq',
                onTap: () => setState(() => _mode = 'mcq'),
              ),
              const SizedBox(height: 10),
              _ModeOptionTile(
                icon: Icons.edit_rounded,
                iconColor: AppColors.iconPurple,
                bgColor: AppColors.cardPurple,
                title: 'Drawing',
                subtitle: 'Trace the letter or number with AI check',
                selected: _mode == 'drawing',
                onTap: () => setState(() => _mode = 'drawing'),
              ),
              const SizedBox(height: 24),
              _SectionTitle(text: 'Number of Questions'),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (final c in _counts) ...[
                    Expanded(
                      child: _CountChip(
                        value: c,
                        selected: _count == c,
                        onTap: () => setState(() => _count = c),
                      ),
                    ),
                    if (c != _counts.last) const SizedBox(width: 10),
                  ],
                ],
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _start,
                  icon: const Icon(Icons.play_arrow_rounded, size: 24),
                  label: const Text('Start Quiz'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandPurple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.text(context),
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _ModeOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _ModeOptionTile({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBg(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? AppColors.brandPurple
                  : AppColors.borderSoft(context),
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: AppColors.brandPurple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Colors.white, size: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  final int value;
  final bool selected;
  final VoidCallback onTap;

  const _CountChip({
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.brandPurple
                : AppColors.cardBg(context),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? AppColors.brandPurple
                  : AppColors.borderSoft(context),
              width: selected ? 2 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '$value',
            style: TextStyle(
              color: selected ? Colors.white : AppColors.text(context),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
