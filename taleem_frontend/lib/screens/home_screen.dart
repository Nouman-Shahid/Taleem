import 'package:flutter/material.dart';
import '../services/child_service.dart';
import '../state/app_session.dart';
import '../theme.dart';
import '../widgets/animations.dart';
import '../widgets/child_picker_modal.dart';
import '../widgets/main_bottom_nav.dart';
import '../widgets/playful_background.dart';
import 'learning_center_screen.dart';
import 'progress_screen.dart';
import 'profile_screen.dart';
import 'quiz_launcher_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  void _onNavTap(int i) {
    if (i == 0) {
      setState(() => _navIndex = 0);
      return;
    }
    setState(() => _navIndex = i);
    if (i == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LearningCenterScreen()),
      ).then((_) => setState(() => _navIndex = 0));
    } else if (i == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProgressScreen()),
      ).then((_) => setState(() => _navIndex = 0));
    } else if (i == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      ).then((_) {
        if (mounted) setState(() => _navIndex = 0);
      });
    }
  }

  void _openQuiz(String key, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizLauncherScreen(quizKey: key, quizTitle: title),
      ),
    );
  }

  Future<void> _switchChild() async {
    try {
      final children = await ChildService.list();
      if (!mounted) return;
      final picked = await showChildPickerModal(context, children);
      if (picked != null) {
        await AppSession.instance.setCurrentChild(picked);
        if (mounted) setState(() {});
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not load children'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = AppSession.instance.currentChild;
    final childName = child?.name ?? 'Friend';

    return Scaffold(
      backgroundColor: AppColors.surface(context),
      body: Stack(
        children: [
          const Positioned.fill(child: PlayfulBackground()),
          Positioned.fill(
            child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: FadeSlideIn(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: _switchChild,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF34D399), Color(0xFF14B8A6)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF14B8A6).withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Assalamu Alaikum',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.95),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                childName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              if (child != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Age ${child.age} · Tap to switch child',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.swap_horiz_rounded,
                              color: Colors.white, size: 22),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LearningCenterScreen()),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
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
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Bob(
                            child: Icon(Icons.school_rounded,
                                color: Colors.white, size: 30),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Learning Center',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Alphabets, Numbers & Words',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded,
                            color: Colors.white, size: 24),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Practice Quizzes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text(context),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _QuizCard(
                title: 'Counting Quiz',
                subtitle: 'Practice drawing numbers',
                bg: const Color(0xFFF59E0B),
                icon: Icons.calculate_rounded,
                onTap: () => _openQuiz('counting', 'Counting Quiz'),
              ),
              const SizedBox(height: 12),
              _QuizCard(
                title: 'English Alphabet Quiz',
                subtitle: 'Practice drawing letters',
                bg: const Color(0xFF6366F1),
                icon: Icons.abc_rounded,
                onTap: () =>
                    _openQuiz('english_alphabet', 'English Alphabet Quiz'),
              ),
              const SizedBox(height: 12),
              _QuizCard(
                title: 'Urdu Alphabet Quiz',
                subtitle: 'Practice Urdu letters',
                bg: const Color(0xFF14B8A6),
                icon: Icons.translate_rounded,
                onTap: () =>
                    _openQuiz('urdu_alphabet', 'Urdu Alphabet Quiz'),
              ),
            ],
          ),
          ),
        ),
      ),
          ),
        ],
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color bg;
  final IconData icon;
  final VoidCallback onTap;

  const _QuizCard({
    required this.title,
    required this.subtitle,
    required this.bg,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: bg.withValues(alpha: 0.40),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Bob(
                distance: 4,
                child: Icon(icon, color: Colors.white, size: 28),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded,
                color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }
}
