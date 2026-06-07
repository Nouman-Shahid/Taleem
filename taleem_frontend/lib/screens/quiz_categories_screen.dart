import 'package:flutter/material.dart';
import '../theme.dart';
import 'quiz_launcher_screen.dart';

class QuizCategoriesScreen extends StatelessWidget {
  const QuizCategoriesScreen({super.key});

  static const _quizzes = [
    {
      'key': 'counting',
      'title': 'Counting Quiz',
      'subtitle': 'Practice drawing numbers',
      'bg': Color(0xFFFACC15),
      'trophyBg': Color(0xFFEAB308),
    },
    {
      'key': 'english_alphabet',
      'title': 'English Alphabet Quiz',
      'subtitle': 'Practice drawing letters',
      'bg': Color(0xFFFB923C),
      'trophyBg': Color(0xFFEA580C),
    },
    {
      'key': 'urdu_alphabet',
      'title': 'Urdu Alphabet Quiz',
      'subtitle': 'Haroof-e-Tahaji with pictures',
      'bg': Color(0xFF5EEAD4),
      'trophyBg': Color(0xFF14B8A6),
    },
    {
      'key': 'english_vowels',
      'title': 'English Vowels Quiz',
      'subtitle': 'A E I O U – picture MCQs',
      'bg': Color(0xFFFCE7F3),
      'trophyBg': Color(0xFFDB2777),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface(context),
      appBar: AppBar(
        backgroundColor: AppColors.surface(context),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.brandPurple, size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          'Practice Quizzes',
          style: TextStyle(
            color: AppColors.brandPurple,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pick a quiz to start',
                  style: TextStyle(
                    color: AppColors.textBody,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  )),
              const SizedBox(height: 18),
              ..._quizzes.map((q) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizLauncherScreen(
                              quizKey: q['key'] as String,
                              quizTitle: q['title'] as String,
                            ),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: q['bg'] as Color,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(q['title'] as String,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.text(context),
                                        )),
                                    const SizedBox(height: 4),
                                    Text(q['subtitle'] as String,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textBody,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: (q['trophyBg'] as Color)
                                      .withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Icon(Icons.emoji_events_rounded,
                                    color: AppColors.text(context), size: 22),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
