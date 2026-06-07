import 'package:flutter/material.dart';
import '../services/tts_service.dart';
import '../theme.dart';

class EnglishVowelsScreen extends StatefulWidget {
  const EnglishVowelsScreen({super.key});

  @override
  State<EnglishVowelsScreen> createState() => _EnglishVowelsScreenState();
}

class _EnglishVowelsScreenState extends State<EnglishVowelsScreen> {
  String? _activeKey;

  static final _vowels = [
    {
      'letter': 'A',
      'card': AppColors.cardPink,
      'icon': AppColors.iconPink,
      'examples': [
        {'emoji': '🍎', 'word': 'Apple'},
        {'emoji': '🐜', 'word': 'Ant'},
        {'emoji': '✈️', 'word': 'Airplane'},
        {'emoji': '🐊', 'word': 'Alligator'},
        {'emoji': '🏹', 'word': 'Arrow'},
        {'emoji': '🥑', 'word': 'Avocado'},
        {'emoji': '🪓', 'word': 'Axe'},
        {'emoji': '💪', 'word': 'Arm'},
      ],
    },
    {
      'letter': 'E',
      'card': AppColors.cardBlue,
      'icon': AppColors.iconBlue,
      'examples': [
        {'emoji': '🥚', 'word': 'Egg'},
        {'emoji': '🐘', 'word': 'Elephant'},
        {'emoji': '🦅', 'word': 'Eagle'},
        {'emoji': '👁️', 'word': 'Eye'},
        {'emoji': '👂', 'word': 'Ear'},
        {'emoji': '🌍', 'word': 'Earth'},
        {'emoji': '🍆', 'word': 'Eggplant'},
        {'emoji': '✉️', 'word': 'Envelope'},
      ],
    },
    {
      'letter': 'I',
      'card': AppColors.cardGreen,
      'icon': AppColors.iconGreen,
      'examples': [
        {'emoji': '🍦', 'word': 'Ice Cream'},
        {'emoji': '🛖', 'word': 'Igloo'},
        {'emoji': '🦗', 'word': 'Insect'},
        {'emoji': '🏝️', 'word': 'Island'},
        {'emoji': '🧊', 'word': 'Ice'},
        {'emoji': '🖊️', 'word': 'Ink'},
        {'emoji': '🦎', 'word': 'Iguana'},
      ],
    },
    {
      'letter': 'O',
      'card': AppColors.cardOrange,
      'icon': AppColors.iconOrange,
      'examples': [
        {'emoji': '🍊', 'word': 'Orange'},
        {'emoji': '🐙', 'word': 'Octopus'},
        {'emoji': '🦉', 'word': 'Owl'},
        {'emoji': '🌊', 'word': 'Ocean'},
        {'emoji': '🧅', 'word': 'Onion'},
        {'emoji': '🦦', 'word': 'Otter'},
        {'emoji': '🫒', 'word': 'Olive'},
      ],
    },
    {
      'letter': 'U',
      'card': AppColors.cardYellow,
      'icon': AppColors.iconYellow,
      'examples': [
        {'emoji': '☂️', 'word': 'Umbrella'},
        {'emoji': '🦄', 'word': 'Unicorn'},
        {'emoji': '🛸', 'word': 'UFO'},
        {'emoji': '🪕', 'word': 'Ukulele'},
        {'emoji': '🦔', 'word': 'Urchin'},
      ],
    },
  ];

  @override
  void dispose() {
    TtsService.stop();
    super.dispose();
  }

  Future<void> _tap(String key, String text) async {
    if (_activeKey == key) return;
    setState(() => _activeKey = key);
    await TtsService.speak(text, languageCode: 'en');
    if (mounted) setState(() => _activeKey = null);
  }

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
          'English Vowels',
          style: TextStyle(
            color: AppColors.brandPurple,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () =>
                    _tap('header', 'A, E, I, O, U are the five vowels'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.cardPurple,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'A  E  I  O  U',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.brandPurple,
                          letterSpacing: 3,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        _activeKey == 'header'
                            ? Icons.volume_up_rounded
                            : Icons.volume_up_outlined,
                        color: AppColors.brandPurple,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: _vowels.length,
                  separatorBuilder: (context, i) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, i) {
                    final v = _vowels[i];
                    final examples = v['examples'] as List;
                    final cardColor = v['card'] as Color;
                    final iconColor = v['icon'] as Color;
                    final letter = v['letter'] as String;

                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBg(context),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => _tap(letter, '$letter is a vowel'),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    letter,
                                    style: TextStyle(
                                      fontSize: 52,
                                      fontWeight: FontWeight.w900,
                                      color: iconColor,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$letter is for...',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: iconColor
                                                .withValues(alpha: 0.75),
                                          ),
                                        ),
                                        Text(
                                          (examples[0] as Map)['word']
                                              as String,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            color: iconColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    _activeKey == letter
                                        ? Icons.volume_up_rounded
                                        : Icons.volume_up_outlined,
                                    color: iconColor,
                                    size: 22,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: examples.map((e) {
                                final ex = e as Map;
                                final word = ex['word'] as String;
                                final chipKey = '${letter}_$word';
                                return _ExampleChip(
                                  emoji: ex['emoji'] as String,
                                  word: word,
                                  iconColor: iconColor,
                                  cardColor: cardColor,
                                  isSpeaking: _activeKey == chipKey,
                                  onTap: () =>
                                      _tap(chipKey, '$letter is for $word'),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExampleChip extends StatelessWidget {
  final String emoji;
  final String word;
  final Color iconColor;
  final Color cardColor;
  final bool isSpeaking;
  final VoidCallback onTap;

  const _ExampleChip({
    required this.emoji,
    required this.word,
    required this.iconColor,
    required this.cardColor,
    required this.isSpeaking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSpeaking
              ? cardColor.withValues(alpha: 0.85)
              : cardColor.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(12),
          border: isSpeaking
              ? Border.all(color: iconColor, width: 2)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(
              word,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
