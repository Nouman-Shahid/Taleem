import 'package:flutter/material.dart';
import '../services/tts_service.dart';
import '../theme.dart';

class UrduHaroofScreen extends StatefulWidget {
  const UrduHaroofScreen({super.key});

  @override
  State<UrduHaroofScreen> createState() => _UrduHaroofScreenState();
}

class _UrduHaroofScreenState extends State<UrduHaroofScreen> {
  String? _activeKey;

  static final _haroof = [
    {
      'letter': 'ا',
      'examples': [
        {'emoji': '🥭', 'word': 'آم', 'meaning': 'Mango'},
        {'emoji': '🥚', 'word': 'انڈا', 'meaning': 'Egg'},
        {'emoji': '🍇', 'word': 'انگور', 'meaning': 'Grapes'},
        {'emoji': '🐪', 'word': 'اونٹ', 'meaning': 'Camel'},
      ],
    },
    {
      'letter': 'ب',
      'examples': [
        {'emoji': '🐱', 'word': 'بلی', 'meaning': 'Cat'},
        {'emoji': '🐐', 'word': 'بکری', 'meaning': 'Goat'},
        {'emoji': '☁️', 'word': 'بادل', 'meaning': 'Cloud'},
        {'emoji': '🐒', 'word': 'بندر', 'meaning': 'Monkey'},
      ],
    },
    {
      'letter': 'پ',
      'examples': [
        {'emoji': '✏️', 'word': 'پنسل', 'meaning': 'Pencil'},
        {'emoji': '🌸', 'word': 'پھول', 'meaning': 'Flower'},
        {'emoji': '🐦', 'word': 'پرندہ', 'meaning': 'Bird'},
        {'emoji': '🪁', 'word': 'پتنگ', 'meaning': 'Kite'},
      ],
    },
    {
      'letter': 'ت',
      'examples': [
        {'emoji': '🍉', 'word': 'تربوز', 'meaning': 'Watermelon'},
        {'emoji': '🦋', 'word': 'تتلی', 'meaning': 'Butterfly'},
        {'emoji': '⭐', 'word': 'تارہ', 'meaning': 'Star'},
        {'emoji': '🏹', 'word': 'تیر', 'meaning': 'Arrow'},
      ],
    },
    {
      'letter': 'ٹ',
      'examples': [
        {'emoji': '🎩', 'word': 'ٹوپی', 'meaning': 'Hat'},
        {'emoji': '🚛', 'word': 'ٹرک', 'meaning': 'Truck'},
        {'emoji': '📞', 'word': 'ٹیلی فون', 'meaning': 'Phone'},
      ],
    },
    {
      'letter': 'ث',
      'examples': [
        {'emoji': '🦊', 'word': 'ثعلب', 'meaning': 'Fox'},
        {'emoji': '🍑', 'word': 'ثمر', 'meaning': 'Fruit'},
      ],
    },
    {
      'letter': 'ج',
      'examples': [
        {'emoji': '👟', 'word': 'جوتا', 'meaning': 'Shoe'},
        {'emoji': '✈️', 'word': 'جہاز', 'meaning': 'Airplane'},
        {'emoji': '🌲', 'word': 'جنگل', 'meaning': 'Forest'},
        {'emoji': '🐾', 'word': 'جانور', 'meaning': 'Animal'},
      ],
    },
    {
      'letter': 'چ',
      'examples': [
        {'emoji': '🔑', 'word': 'چابی', 'meaning': 'Key'},
        {'emoji': '🌙', 'word': 'چاند', 'meaning': 'Moon'},
        {'emoji': '🐦', 'word': 'چڑیا', 'meaning': 'Sparrow'},
        {'emoji': '🐆', 'word': 'چیتا', 'meaning': 'Cheetah'},
      ],
    },
    {
      'letter': 'ح',
      'examples': [
        {'emoji': '🌿', 'word': 'حنا', 'meaning': 'Henna'},
        {'emoji': '🍮', 'word': 'حلوہ', 'meaning': 'Halwa'},
        {'emoji': '🦗', 'word': 'حشرہ', 'meaning': 'Insect'},
      ],
    },
    {
      'letter': 'خ',
      'examples': [
        {'emoji': '🐰', 'word': 'خرگوش', 'meaning': 'Rabbit'},
        {'emoji': '🍈', 'word': 'خربوزہ', 'meaning': 'Melon'},
        {'emoji': '🍑', 'word': 'خوبانی', 'meaning': 'Apricot'},
        {'emoji': '😊', 'word': 'خوشی', 'meaning': 'Happiness'},
      ],
    },
    {
      'letter': 'د',
      'examples': [
        {'emoji': '🚪', 'word': 'دروازہ', 'meaning': 'Door'},
        {'emoji': '🥛', 'word': 'دودھ', 'meaning': 'Milk'},
        {'emoji': '🌳', 'word': 'درخت', 'meaning': 'Tree'},
        {'emoji': '🪔', 'word': 'دیا', 'meaning': 'Lamp'},
      ],
    },
    {
      'letter': 'ڈ',
      'examples': [
        {'emoji': '📦', 'word': 'ڈبہ', 'meaning': 'Box'},
        {'emoji': '🐬', 'word': 'ڈالفن', 'meaning': 'Dolphin'},
        {'emoji': '🥁', 'word': 'ڈرم', 'meaning': 'Drum'},
      ],
    },
    {
      'letter': 'ذ',
      'examples': [
        {'emoji': '🧠', 'word': 'ذہن', 'meaning': 'Mind'},
        {'emoji': '😋', 'word': 'ذائقہ', 'meaning': 'Taste'},
      ],
    },
    {
      'letter': 'ر',
      'examples': [
        {'emoji': '🍞', 'word': 'روٹی', 'meaning': 'Bread'},
        {'emoji': '🛺', 'word': 'رکشہ', 'meaning': 'Rickshaw'},
        {'emoji': '🎨', 'word': 'رنگ', 'meaning': 'Color'},
        {'emoji': '🐻', 'word': 'ریچھ', 'meaning': 'Bear'},
      ],
    },
    {
      'letter': 'ڑ',
      'examples': [
        {'emoji': '🚂', 'word': 'ریل', 'meaning': 'Train'},
      ],
    },
    {
      'letter': 'ز',
      'examples': [
        {'emoji': '🦒', 'word': 'زرافہ', 'meaning': 'Giraffe'},
        {'emoji': '🌍', 'word': 'زمین', 'meaning': 'Earth'},
        {'emoji': '🫒', 'word': 'زیتون', 'meaning': 'Olive'},
      ],
    },
    {
      'letter': 'ژ',
      'examples': [
        {'emoji': '❄️', 'word': 'ژالہ', 'meaning': 'Hail'},
      ],
    },
    {
      'letter': 'س',
      'examples': [
        {'emoji': '🍎', 'word': 'سیب', 'meaning': 'Apple'},
        {'emoji': '🐍', 'word': 'سانپ', 'meaning': 'Snake'},
        {'emoji': '⭐', 'word': 'ستارہ', 'meaning': 'Star'},
        {'emoji': '🍊', 'word': 'سنترا', 'meaning': 'Orange'},
      ],
    },
    {
      'letter': 'ش',
      'examples': [
        {'emoji': '🦁', 'word': 'شیر', 'meaning': 'Lion'},
        {'emoji': '🍯', 'word': 'شہد', 'meaning': 'Honey'},
        {'emoji': '🕯️', 'word': 'شمع', 'meaning': 'Candle'},
        {'emoji': '🍲', 'word': 'شوربہ', 'meaning': 'Soup'},
      ],
    },
    {
      'letter': 'ص',
      'examples': [
        {'emoji': '🧼', 'word': 'صابن', 'meaning': 'Soap'},
        {'emoji': '🐚', 'word': 'صدف', 'meaning': 'Shell'},
        {'emoji': '🏜️', 'word': 'صحرا', 'meaning': 'Desert'},
      ],
    },
    {
      'letter': 'ض',
      'examples': [
        {'emoji': '💡', 'word': 'ضرورت', 'meaning': 'Need'},
        {'emoji': '🍽️', 'word': 'ضیافت', 'meaning': 'Feast'},
      ],
    },
    {
      'letter': 'ط',
      'examples': [
        {'emoji': '🦜', 'word': 'طوطا', 'meaning': 'Parrot'},
        {'emoji': '🥁', 'word': 'طبلہ', 'meaning': 'Drum'},
        {'emoji': '🌅', 'word': 'طلوع', 'meaning': 'Sunrise'},
      ],
    },
    {
      'letter': 'ظ',
      'examples': [
        {'emoji': '🫙', 'word': 'ظرف', 'meaning': 'Container'},
      ],
    },
    {
      'letter': 'ع',
      'examples': [
        {'emoji': '🦅', 'word': 'عقاب', 'meaning': 'Eagle'},
        {'emoji': '🕷️', 'word': 'عنکبوت', 'meaning': 'Spider'},
        {'emoji': '🏢', 'word': 'عمارت', 'meaning': 'Building'},
      ],
    },
    {
      'letter': 'غ',
      'examples': [
        {'emoji': '🎈', 'word': 'غبارہ', 'meaning': 'Balloon'},
        {'emoji': '🕳️', 'word': 'غار', 'meaning': 'Cave'},
        {'emoji': '🌅', 'word': 'غروب', 'meaning': 'Sunset'},
      ],
    },
    {
      'letter': 'ف',
      'examples': [
        {'emoji': '🕊️', 'word': 'فاختہ', 'meaning': 'Dove'},
        {'emoji': '🏮', 'word': 'فانوس', 'meaning': 'Lantern'},
        {'emoji': '🌾', 'word': 'فصل', 'meaning': 'Crop'},
      ],
    },
    {
      'letter': 'ق',
      'examples': [
        {'emoji': '✂️', 'word': 'قینچی', 'meaning': 'Scissors'},
        {'emoji': '🏰', 'word': 'قلعہ', 'meaning': 'Fort'},
        {'emoji': '🖊️', 'word': 'قلم', 'meaning': 'Pen'},
      ],
    },
    {
      'letter': 'ک',
      'examples': [
        {'emoji': '🐶', 'word': 'کتا', 'meaning': 'Dog'},
        {'emoji': '📚', 'word': 'کتاب', 'meaning': 'Book'},
        {'emoji': '🐢', 'word': 'کچھوا', 'meaning': 'Turtle'},
        {'emoji': '🍌', 'word': 'کیلا', 'meaning': 'Banana'},
      ],
    },
    {
      'letter': 'گ',
      'examples': [
        {'emoji': '🐄', 'word': 'گائے', 'meaning': 'Cow'},
        {'emoji': '🌹', 'word': 'گلاب', 'meaning': 'Rose'},
        {'emoji': '🏠', 'word': 'گھر', 'meaning': 'House'},
      ],
    },
    {
      'letter': 'ل',
      'examples': [
        {'emoji': '🦊', 'word': 'لومڑی', 'meaning': 'Fox'},
        {'emoji': '🎀', 'word': 'لڑکی', 'meaning': 'Girl'},
        {'emoji': '🤿', 'word': 'لہر', 'meaning': 'Wave'},
      ],
    },
    {
      'letter': 'م',
      'examples': [
        {'emoji': '🐟', 'word': 'مچھلی', 'meaning': 'Fish'},
        {'emoji': '🐔', 'word': 'مرغی', 'meaning': 'Hen'},
        {'emoji': '🦚', 'word': 'مور', 'meaning': 'Peacock'},
        {'emoji': '🍬', 'word': 'مٹھائی', 'meaning': 'Sweet'},
      ],
    },
    {
      'letter': 'ن',
      'examples': [
        {'emoji': '🍊', 'word': 'نارنگی', 'meaning': 'Orange'},
        {'emoji': '🎋', 'word': 'نل', 'meaning': 'Tap'},
        {'emoji': '🗺️', 'word': 'نقشہ', 'meaning': 'Map'},
      ],
    },
    {
      'letter': 'و',
      'examples': [
        {'emoji': '🐟', 'word': 'وھیل', 'meaning': 'Whale'},
        {'emoji': '⏰', 'word': 'وقت', 'meaning': 'Time'},
      ],
    },
    {
      'letter': 'ہ',
      'examples': [
        {'emoji': '🦢', 'word': 'ہنس', 'meaning': 'Swan'},
        {'emoji': '🌬️', 'word': 'ہوا', 'meaning': 'Wind'},
        {'emoji': '🤲', 'word': 'ہاتھ', 'meaning': 'Hand'},
      ],
    },
    {
      'letter': 'ی',
      'examples': [
        {'emoji': '🥶', 'word': 'یخ', 'meaning': 'Ice'},
        {'emoji': '💛', 'word': 'یاد', 'meaning': 'Memory'},
      ],
    },
  ];

  static const _colors = [
    AppColors.cardPurple, AppColors.cardPink,  AppColors.cardBlue,
    AppColors.cardGreen,  AppColors.cardOrange, AppColors.cardYellow,
    AppColors.cardTeal,   AppColors.cardIndigo,
  ];
  static const _iconColors = [
    AppColors.iconPurple, AppColors.iconPink,  AppColors.iconBlue,
    AppColors.iconGreen,  AppColors.iconOrange, AppColors.iconYellow,
    AppColors.iconTeal,   AppColors.iconIndigo,
  ];

  @override
  void dispose() {
    TtsService.stop();
    super.dispose();
  }

  Future<void> _tap(String key, String text, String lang) async {
    if (_activeKey == key) return;
    setState(() => _activeKey = key);
    await TtsService.speak(text, languageCode: lang);
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
          'حروف تہجی',
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
              Text(
                'Urdu Alphabet with Pictures — tap to hear',
                style: TextStyle(
                  color: AppColors.textSoft(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: _haroof.length,
                  separatorBuilder: (context, i) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final h = _haroof[i];
                    final bg = _colors[i % _colors.length];
                    final ic = _iconColors[i % _iconColors.length];
                    final examples = h['examples'] as List;
                    final letter = h['letter'] as String;

                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBg(context),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GestureDetector(
                              onTap: () => _tap(letter, letter, 'ur'),
                              child: Container(
                                width: 64,
                                decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(18),
                                    bottomLeft: Radius.circular(18),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      letter,
                                      style: TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.w900,
                                        color: ic,
                                      ),
                                    ),
                                    Icon(
                                      _activeKey == letter
                                          ? Icons.volume_up_rounded
                                          : Icons.volume_up_outlined,
                                      color: ic.withValues(alpha: 0.65),
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: examples.map((e) {
                                    final ex = e as Map;
                                    final word = ex['word'] as String;
                                    final tileKey = '${letter}_$word';
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10),
                                      child: _HaroofTile(
                                        emoji: ex['emoji'] as String,
                                        word: word,
                                        meaning: ex['meaning'] as String,
                                        iconColor: ic,
                                        bgColor: bg,
                                        isSpeaking: _activeKey == tileKey,
                                        onTap: () =>
                                            _tap(tileKey, word, 'ur'),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}

class _HaroofTile extends StatelessWidget {
  final String emoji;
  final String word;
  final String meaning;
  final Color iconColor;
  final Color bgColor;
  final bool isSpeaking;
  final VoidCallback onTap;

  const _HaroofTile({
    required this.emoji,
    required this.word,
    required this.meaning,
    required this.iconColor,
    required this.bgColor,
    required this.isSpeaking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 68,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSpeaking
              ? bgColor.withValues(alpha: 0.8)
              : bgColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: isSpeaking
              ? Border.all(color: iconColor, width: 2)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 4),
            Text(
              word,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: iconColor,
              ),
            ),
            Text(
              meaning,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: iconColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
