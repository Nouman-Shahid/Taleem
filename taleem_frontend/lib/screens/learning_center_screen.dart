import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/animations.dart';
import '../widgets/main_bottom_nav.dart';
import '../widgets/playful_background.dart';
import 'english_alphabet_screen.dart';
import 'english_number_screen.dart';
import 'english_spelling_screen.dart';
import 'english_vowels_screen.dart';
import 'imla_spelling_screen.dart';
import 'profile_screen.dart';
import 'progress_screen.dart';
import 'urdu_alphabet_screen.dart';
import 'urdu_ginti_screen.dart';
import 'urdu_haroof_screen.dart';

class LearningCenterScreen extends StatelessWidget {
  const LearningCenterScreen({super.key});

  void _onNavTap(BuildContext context, int i) {
    if (i == 1) return;
    Navigator.popUntil(context, (r) => r.isFirst);
    if (i == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProgressScreen()),
      );
    } else if (i == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'icon': Icons.text_fields_rounded,
        'title': 'Learn Urdu\nAlphabets',
        'subtitle': 'حروف تہجی',
        'tint': AppColors.cardPurple,
        'iconColor': AppColors.iconPurple,
        'screen': const UrduAlphabetScreen(),
      },
      {
        'icon': Icons.tag_rounded,
        'title': 'Urdu Counting',
        'subtitle': 'اردو گنتی',
        'tint': AppColors.cardPink,
        'iconColor': AppColors.iconPink,
        'screen': const UrduGintiScreen(),
      },
      {
        'icon': Icons.translate_rounded,
        'title': 'English\nAlphabets',
        'subtitle': 'A to Z',
        'tint': AppColors.cardBlue,
        'iconColor': AppColors.iconBlue,
        'screen': const EnglishAlphabetScreen(),
      },
      {
        'icon': Icons.calculate_rounded,
        'title': 'English Numbers',
        'subtitle': '1 to 100',
        'tint': AppColors.cardOrange,
        'iconColor': AppColors.iconOrange,
        'screen': const EnglishNumberScreen(),
      },
      {
        'icon': Icons.edit_rounded,
        'title': 'Imla',
        'subtitle': 'Spelling Practice',
        'tint': AppColors.cardGreen,
        'iconColor': AppColors.iconGreen,
        'screen': const ImlaSpellingScreen(),
      },
      {
        'icon': Icons.spellcheck_rounded,
        'title': 'English\nSpelling',
        'subtitle': 'Spelling Practice',
        'tint': AppColors.cardYellow,
        'iconColor': AppColors.iconYellow,
        'screen': const EnglishSpellingScreen(),
      },
      {
        'icon': Icons.record_voice_over_rounded,
        'title': 'English\nVowels',
        'subtitle': 'A E I O U',
        'tint': AppColors.cardPink,
        'iconColor': AppColors.iconPink,
        'screen': const EnglishVowelsScreen(),
      },
      {
        'icon': Icons.auto_stories_rounded,
        'title': 'Urdu Haroof\nتصویری',
        'subtitle': 'حروف تہجی',
        'tint': AppColors.cardTeal,
        'iconColor': AppColors.iconTeal,
        'screen': const UrduHaroofScreen(),
      },
    ];

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
          'Learning Center',
          style: TextStyle(
            color: AppColors.brandPurple,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: PlayfulBackground()),
          Positioned.fill(
            child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 14),
                child: Text(
                  'Choose what you want to learn',
                  style: TextStyle(
                    color: AppColors.textSoft(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Divider(
                  color: AppColors.borderSoft(context),
                  height: 1,
                  thickness: 1),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  itemCount: categories.length,
                  padding: const EdgeInsets.only(bottom: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, i) {
                    final c = categories[i];
                    return FadeSlideIn(
                      delay: Duration(milliseconds: 60 * i),
                      child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => c['screen'] as Widget),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg(context),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: c['tint'] as Color,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Bob(
                                  distance: 5,
                                  period: Duration(
                                      milliseconds: 1900 + (i % 4) * 250),
                                  child: Icon(c['icon'] as IconData,
                                      color: c['iconColor'] as Color, size: 28),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Flexible(
                                child: Text(
                                  c['title'] as String,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.text(context),
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                c['subtitle'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: c['iconColor'] as Color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
          ),
        ],
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: 1,
        onTap: (i) => _onNavTap(context, i),
      ),
    );
  }
}
