import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../services/lesson_service.dart';
import '../services/tts_service.dart';
import '../theme.dart';
import '../widgets/animations.dart';
import '../widgets/lesson_loading.dart';
import 'lesson_detail_screen.dart';

class UrduGintiScreen extends StatefulWidget {
  const UrduGintiScreen({super.key});

  @override
  State<UrduGintiScreen> createState() => _UrduGintiScreenState();
}

class _UrduGintiScreenState extends State<UrduGintiScreen> {
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
    await TtsService.speak(l.translation ?? l.displayText, languageCode: 'ur');
    if (mounted) setState(() => _speakingId = null);
  }

  Future<void> _load() async {
    try {
      final list = await LessonService.listByType('urdu_ginti');
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
          title: l.translation ?? l.displayText,
          subtitle: 'Urdu Counting',
          tint: AppColors.cardTeal,
          iconColor: AppColors.iconTeal,
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
          'Urdu Counting',
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
              const Text('Tap any number to learn or practice',
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
                            // Urdu reads right-to-left, so numbers fill from the
                            // top-right and flow leftward.
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: GridView.builder(
                              itemCount: _lessons.length,
                              padding: const EdgeInsets.only(bottom: 16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1.0,
                              ),
                              itemBuilder: (context, i) {
                                final l = _lessons[i];
                                return FadeSlideIn(
                                  delay: Duration(milliseconds: 30 * i),
                                  child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () => _open(l),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.cardTeal,
                                        borderRadius: BorderRadius.circular(16),
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
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.w800,
                                                    color: AppColors.iconTeal,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  l.translation ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.iconTeal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                onTap: () => _play(l),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Icon(
                                                    _speakingId == l.id
                                                        ? Icons.volume_up_rounded
                                                        : Icons
                                                            .volume_up_outlined,
                                                    size: 15,
                                                    color: AppColors.iconTeal,
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
