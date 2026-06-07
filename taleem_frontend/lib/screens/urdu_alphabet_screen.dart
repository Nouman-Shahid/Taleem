import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../services/lesson_service.dart';
import '../services/tts_service.dart';
import '../theme.dart';
import '../widgets/animations.dart';
import '../widgets/lesson_loading.dart';
import 'lesson_detail_screen.dart';

class UrduAlphabetScreen extends StatefulWidget {
  const UrduAlphabetScreen({super.key});

  @override
  State<UrduAlphabetScreen> createState() => _UrduAlphabetScreenState();
}

class _UrduAlphabetScreenState extends State<UrduAlphabetScreen> {
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

  Future<void> _play(Lesson l) async {
    if (_speakingId == l.id) return;
    setState(() => _speakingId = l.id);
    await TtsService.speak(l.displayText, languageCode: 'ur');
    if (mounted) setState(() => _speakingId = null);
  }

  Future<void> _load() async {
    try {
      final list = await LessonService.listByType('urdu_alphabet');
      if (!mounted) return;
      setState(() {
        _lessons = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load lessons. Pull to retry.';
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
          title: l.translation ?? l.displayText,
          subtitle: 'Urdu Alphabet',
          tint: AppColors.cardPurple,
          iconColor: AppColors.iconPurple,
          languageCode: 'ur',
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
          'Urdu Alphabet',
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
                            // Urdu reads right-to-left, so letters fill from the
                            // top-right and flow leftward.
                            child: Directionality(
                              textDirection: TextDirection.rtl,
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
                                  delay: Duration(milliseconds: 30 * i),
                                  child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(18),
                                    onTap: () => _open(l),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.cardPurple,
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
                                                  l.displayText,
                                                  style: const TextStyle(
                                                    fontSize: 44,
                                                    fontWeight: FontWeight.w800,
                                                    color: AppColors.iconPurple,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  l.translation ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.purple700,
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
                                                onTap: () => _play(l),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  child: Icon(
                                                    _speakingId == l.id
                                                        ? Icons.volume_up_rounded
                                                        : Icons
                                                            .volume_up_outlined,
                                                    size: 18,
                                                    color: AppColors.iconPurple,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
