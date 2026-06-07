import 'package:flutter/material.dart';
import '../theme.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Terms & Conditions'),
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
                      child: const Icon(Icons.gavel_rounded,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Terms & Conditions',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Last updated: May 2026',
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
              const _Section(
                title: '1. Acceptance of Terms',
                body:
                    'By creating an account or using Taleem, you agree to these Terms & Conditions. '
                    'If you do not agree with any part of these terms, please discontinue use of the app. '
                    'These terms apply to parents, guardians, and any child profiles registered under their account.',
              ),
              _Section(
                title: '2. Educational Purpose',
                body:
                    'Taleem is an educational platform designed to help children aged 3–8 learn the Arabic and Urdu '
                    'alphabets, numbers, basic spelling, and core Islamic vocabulary in a safe, ad-free environment. '
                    'The content is curated for early-childhood learning and is for educational purposes only.',
              ),
              _Section(
                title: '3. Child Profiles & Parental Responsibility',
                body:
                    'A parent or legal guardian creates and manages all child profiles. Multiple children can be added '
                    'under one parent account, with separate progress tracking for each child. Parents are responsible '
                    'for supervising their child\'s use of the app and for the accuracy of profile information.',
              ),
              _Section(
                title: '4. Privacy & Data',
                body:
                    'We collect only the minimum data needed to operate the app — your name and email for authentication, '
                    'and your child\'s name, age, and learning progress. Handwriting recognition runs entirely on your device '
                    'using Google ML Kit; stroke data is never transmitted to our servers. Progress statistics are stored '
                    'so you can track your child\'s improvement over time.',
              ),
              _Section(
                title: '5. Acceptable Use',
                body:
                    'You agree to use Taleem only for its intended educational purpose. You will not attempt to reverse '
                    'engineer, modify, or misuse the application or its data. Any attempt to exploit security vulnerabilities '
                    'or interfere with normal operation is prohibited.',
              ),
              _Section(
                title: '6. Content Ownership',
                body:
                    'All lessons, illustrations, audio, and brand assets within Taleem are the intellectual property of '
                    'the Taleem project and may not be copied, redistributed, or used commercially without written permission.',
              ),
              _Section(
                title: '7. Disclaimer',
                body:
                    'Taleem is provided "as is" without warranty of any kind. While we strive for accuracy, we do not '
                    'guarantee that the app will be free of errors or interruptions. The handwriting recognition and audio '
                    'features depend on your device\'s capabilities and may vary in accuracy.',
              ),
              _Section(
                title: '8. Changes to Terms',
                body:
                    'We may update these terms from time to time as the app evolves. The "Last updated" date at the top '
                    'of this page reflects the most recent version. Continued use of Taleem after updates constitutes '
                    'acceptance of the revised terms.',
              ),
              _Section(
                title: '9. Contact',
                body:
                    'For any questions, concerns, or feedback regarding these terms, please reach out via the Help & Support '
                    'section of the app. We aim to respond to all inquiries within a reasonable timeframe.',
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Thank you for choosing Taleem.',
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

class _Section extends StatelessWidget {
  final String title;
  final String body;

  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              color: AppColors.textBody,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
