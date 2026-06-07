import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../services/lesson_service.dart';
import '../services/tts_service.dart';
import '../theme.dart';
import '../widgets/lesson_loading.dart';
import 'lesson_detail_screen.dart';

class EnglishSpellingScreen extends StatefulWidget {
  const EnglishSpellingScreen({super.key});

  @override
  State<EnglishSpellingScreen> createState() => _EnglishSpellingScreenState();
}

class _EnglishSpellingScreenState extends State<EnglishSpellingScreen> {
  List<Lesson> _lessons = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await LessonService.listByType('english_spelling');
      if (!mounted) return;
      setState(() {
        _lessons = list;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load. Pull to retry.';
        _loading = false;
      });
    }
  }

  void _playAudio(Lesson l) {
    TtsService.speak(l.displayText, languageCode: 'en');
  }

  void _openWord(Lesson l) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonDetailScreen(
          mainText: l.displayText,
          title: l.displayText,
          subtitle: 'English Spelling',
          tint: AppColors.cardBlue,
          iconColor: AppColors.iconBlue,
          languageCode: 'en',
          audioUrl: l.audioUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface(context),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: kPurpleGradient),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white, size: 26),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Currently Learning',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'English Spelling',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const LessonLoading()
                : _error != null
                    ? LessonErrorBox(message: _error!, onRetry: () {
                        setState(() {
                          _loading = true;
                          _error = null;
                        });
                        _load();
                      })
                    : RefreshIndicator(
                        onRefresh: _load,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                          child: GridView.builder(
                            itemCount: _lessons.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 0.78,
                            ),
                            itemBuilder: (context, i) {
                              final l = _lessons[i];
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () => _openWord(l),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.cardBg(context),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.black.withValues(alpha: 0.06),
                                          blurRadius: 14,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 52,
                                          height: 52,
                                          decoration: const BoxDecoration(
                                            color: AppColors.cardBlue,
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            l.displayText.isNotEmpty
                                                ? l.displayText[0]
                                                : '',
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.iconBlue,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              l.displayText,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.text(context),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => _playAudio(l),
                                          child: Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: AppColors.cardBlue,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Icon(
                                                Icons.volume_up_rounded,
                                                color: AppColors.iconBlue,
                                                size: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
