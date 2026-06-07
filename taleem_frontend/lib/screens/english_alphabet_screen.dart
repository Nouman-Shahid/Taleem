import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../services/lesson_service.dart';
import '../services/tts_service.dart';
import '../theme.dart';
import '../widgets/animations.dart';
import '../widgets/lesson_loading.dart';
import 'lesson_detail_screen.dart';

class EnglishAlphabetScreen extends StatefulWidget {
  const EnglishAlphabetScreen({super.key});

  @override
  State<EnglishAlphabetScreen> createState() => _EnglishAlphabetScreenState();
}

class _EnglishAlphabetScreenState extends State<EnglishAlphabetScreen> {
  List<Lesson> _lessons = [];
  bool _loading = true;
  String? _error;
  int? _speakingId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    TtsService.stop();
    super.dispose();
  }

  Future<void> _playLetter(Lesson l) async {
    if (_speakingId == l.id) return;
    setState(() => _speakingId = l.id);
    await TtsService.speak(l.displayText, languageCode: 'en');
    if (mounted) setState(() => _speakingId = null);
  }

  Future<void> _load() async {
    try {
      final list = await LessonService.listByType('english_alphabet');
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

  void _open(Lesson l) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonDetailScreen(
          mainText: l.displayText,
          title: '${l.displayText} for ${l.translation ?? ""}',
          subtitle: 'English Alphabet',
          tint: AppColors.cardPink,
          iconColor: AppColors.iconPink,
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
      appBar: AppBar(
        backgroundColor: AppColors.surface(context),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.brandPurple, size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          'English Alphabet',
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
              const Text('Tap a letter to learn or practice',
                  style: TextStyle(
                    color: AppColors.textBody,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  )),
              const SizedBox(height: 16),
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
                            child: GridView.builder(
                              itemCount: _lessons.length,
                              padding: const EdgeInsets.only(bottom: 16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 1.0,
                              ),
                              itemBuilder: (context, i) {
                                final l = _lessons[i];
                                return FadeSlideIn(
                                  delay: Duration(milliseconds: 40 * i),
                                  child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(18),
                                    onTap: () => _open(l),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.cardPink,
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${l.displayText.toUpperCase()}${l.displayText.toLowerCase()}',
                                                  style: const TextStyle(
                                                    fontSize: 34,
                                                    fontWeight: FontWeight.w800,
                                                    color: AppColors.iconPink,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  l.translation ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.iconPink,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top: 2,
                                            right: 2,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                onTap: () => _playLetter(l),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  child: Icon(
                                                    _speakingId == l.id
                                                        ? Icons.volume_up_rounded
                                                        : Icons
                                                            .volume_up_outlined,
                                                    size: 20,
                                                    color: AppColors.iconPink,
                                                  ),
                                                ),
                                              ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
