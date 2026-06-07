import 'package:flutter/material.dart';
import '../theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Help & Support'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: kPurpleGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.support_agent_rounded,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How can we help?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'We\'re here to make learning easier',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const _SectionTitle('Frequently Asked Questions'),
              const SizedBox(height: 10),
              const _Faq(
                question: 'How do I add another child profile?',
                answer:
                    'Go to the Home screen and tap the green greeting card at the top, or open Profile and tap the user '
                    'card. A picker will open with an "Add New Child" option at the bottom.',
              ),
              const _Faq(
                question: 'How does handwriting recognition work?',
                answer:
                    'Taleem uses Google ML Kit Digital Ink Recognition. The model runs entirely on your device — your '
                    'child\'s strokes never leave the phone. The first time you draw, the model (~15 MB) downloads once, '
                    'then everything works offline.',
              ),
              const _Faq(
                question: 'Why doesn\'t the audio play in Urdu?',
                answer:
                    'Audio uses your phone\'s built-in Text-to-Speech engine. Most Android phones include English by '
                    'default but require an extra language pack for Urdu. To install it, go to Settings → System → '
                    'Languages → Text-to-speech output → Install voice data → choose Urdu.',
              ),
              const _Faq(
                question: 'My child is being marked wrong even with correct writing.',
                answer:
                    'Try writing the letter larger and more clearly inside the canvas. The model works best with '
                    'unbroken, deliberate strokes. Both uppercase and lowercase forms are accepted for English letters.',
              ),
              const _Faq(
                question: 'How is progress tracked per child?',
                answer:
                    'Each child profile keeps its own progress. Tap the user card on Home or Profile to switch the '
                    'active child — stats on the Profile screen will update for whichever child is selected.',
              ),
              const _Faq(
                question: 'Can I use Taleem without an internet connection?',
                answer:
                    'After the first login and initial model download, most lessons and handwriting practice work '
                    'offline. Saving progress and fetching new lesson sets does require a connection.',
              ),
              const SizedBox(height: 24),
              const _SectionTitle('Contact Us'),
              const SizedBox(height: 10),
              _ContactTile(
                icon: Icons.mail_outline_rounded,
                bg: AppColors.cardPurple,
                iconColor: AppColors.iconPurple,
                title: 'Email Support',
                subtitle: 'support@taleem.app',
              ),
              const SizedBox(height: 10),
              _ContactTile(
                icon: Icons.bug_report_outlined,
                bg: AppColors.cardOrange,
                iconColor: AppColors.iconOrange,
                title: 'Report a Bug',
                subtitle: 'Tell us what went wrong',
              ),
              const SizedBox(height: 10),
              _ContactTile(
                icon: Icons.lightbulb_outline_rounded,
                bg: AppColors.cardYellow,
                iconColor: AppColors.iconYellow,
                title: 'Suggest a Feature',
                subtitle: 'Help us improve Taleem',
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Made with care for young learners',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
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
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyLarge?.color,
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _Faq extends StatelessWidget {
  final String question;
  final String answer;

  const _Faq({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? const Color(0xFF2E2E44) : AppColors.border,
            width: 1,
          ),
        ),
        child: Theme(
          data: Theme.of(context)
              .copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            iconColor: AppColors.brandPurple,
            collapsedIconColor: AppColors.brandPurple,
            title: Text(
              question,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  answer,
                  style: const TextStyle(
                    color: AppColors.textBody,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    height: 1.55,
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

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _ContactTile({
    required this.icon,
    required this.bg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF2E2E44) : AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 14,
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
          const Icon(Icons.arrow_forward_ios_rounded,
              color: AppColors.textMuted, size: 14),
        ],
      ),
    );
  }
}
