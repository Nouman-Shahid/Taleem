import 'package:flutter/material.dart';
import '../handwriting_recognizer.dart';
import '../services/imla_service.dart';
import '../services/tts_service.dart';
import '../state/app_session.dart';
import '../theme.dart';
import '../widgets/result_dialog.dart';

class LessonDetailScreen extends StatefulWidget {
  final String mainText;
  final String title;
  final String subtitle;
  final Color tint;
  final Color iconColor;
  final String languageCode;
  final String? audioUrl;

  const LessonDetailScreen({
    super.key,
    required this.mainText,
    required this.title,
    required this.subtitle,
    required this.tint,
    required this.iconColor,
    this.languageCode = 'en',
    this.audioUrl,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  String _mode = 'learn';
  final List<List<Offset>> _strokes = [];
  final List<List<int>> _strokeTimes = [];
  int _inkStart = 0;
  bool _isChecking = false;

  void _setMode(String m) {
    setState(() {
      _mode = m;
      _strokes.clear();
      _strokeTimes.clear();
    });
  }

  Future<void> _playAudio() async {
    final spoken = widget.languageCode == 'en'
        ? (widget.title.isNotEmpty ? widget.title : widget.mainText)
        : widget.mainText;
    final ok = await TtsService.speak(spoken, languageCode: widget.languageCode);
    if (!ok && mounted && widget.languageCode == 'ur') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Urdu voice not installed. Add it in Settings → System → '
              'Languages → Text-to-speech output.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  void dispose() {
    TtsService.stop();
    super.dispose();
  }

  void _clearCanvas() {
    setState(() {
      _strokes.clear();
      _strokeTimes.clear();
    });
  }

  void _onPanStart(DragStartDetails d) {
    if (_strokes.isEmpty) {
      _inkStart = DateTime.now().millisecondsSinceEpoch;
    }
    setState(() {
      _strokes.add([d.localPosition]);
      _strokeTimes
          .add([DateTime.now().millisecondsSinceEpoch - _inkStart]);
    });
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() {
      _strokes.last = List<Offset>.from(_strokes.last)..add(d.localPosition);
      _strokeTimes.last = List<int>.from(_strokeTimes.last)
        ..add(DateTime.now().millisecondsSinceEpoch - _inkStart);
    });
  }

  Future<void> _logAttempt({
    required bool isCorrect,
    required String? predicted,
    required double confidence,
  }) async {
    final child = AppSession.instance.currentChild;
    if (child == null) return;
    try {
      await ImlaService.storeAttempt(
        childId: child.id,
        targetLetter: widget.mainText,
        predictedLetter: predicted,
        confidence: confidence,
        isCorrect: isCorrect,
        language: widget.languageCode,
      );
    } catch (_) {
      // logging is best-effort; user already got feedback
    }
  }

  Future<void> _checkDrawing() async {
    if (_isChecking) return;
    setState(() => _isChecking = true);

    final result = await HandwritingRecognizer.recognize(
      languageCode: widget.languageCode,
      strokes: _strokes,
      strokeTimes: _strokeTimes,
      target: widget.mainText,
    );

    if (!mounted) return;
    setState(() => _isChecking = false);

    ResultKind kind;
    String? subline;
    if (result.error == 'no_ink') {
      kind = ResultKind.empty;
    } else if (result.error != null) {
      kind = ResultKind.wrong;
      subline = 'Recognition unavailable. Please try again.';
    } else if (result.isCorrect) {
      kind = ResultKind.correct;
    } else {
      kind = ResultKind.wrong;
    }

    if (kind != ResultKind.empty) {
      _logAttempt(
        isCorrect: kind == ResultKind.correct,
        predicted: result.predicted.isEmpty ? null : result.predicted,
        confidence: result.error == null ? result.confidence : 0,
      );
    }

    await showResultDialog(
      context,
      kind: kind,
      target: widget.mainText,
      predicted: result.predicted.isEmpty ? null : result.predicted,
      confidence: result.error == null ? result.confidence : null,
      customSubline: subline,
      showRetryButton: kind == ResultKind.wrong,
      onContinue: () {
        if (mounted) _clearCanvas();
      },
      onTryAgain: () {
        if (mounted) _clearCanvas();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.chipBg(context),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          _ModeChip(
                            label: 'Learn',
                            active: _mode == 'learn',
                            onTap: () => _setMode('learn'),
                          ),
                          _ModeChip(
                            label: 'Practice',
                            active: _mode == 'practice',
                            onTap: () => _setMode('practice'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.chipBg(context),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.close_rounded,
                          color: AppColors.textBody, size: 22),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child:
                    _mode == 'learn' ? _buildLearn() : _buildPractice(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLearn() {
    return LayoutBuilder(
      builder: (context, c) {
        final boxSize = (c.maxHeight * 0.4).clamp(120.0, 200.0);
        final fontSize = boxSize * 0.55;
        return Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: boxSize,
                  height: boxSize,
                  decoration: BoxDecoration(
                    color: widget.tint,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.mainText,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w800,
                        color: widget.iconColor,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.iconColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: _playAudio,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      decoration: BoxDecoration(
                        color: widget.tint,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color:
                                widget.iconColor.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.volume_up_rounded,
                              color: widget.iconColor, size: 22),
                          const SizedBox(width: 10),
                          Text(
                            'Play Sound',
                            style: TextStyle(
                              color: widget.iconColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPractice() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Trace ${widget.title}',
              style: const TextStyle(
                color: AppColors.textBody,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.purple100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'AI Check',
                style: TextStyle(
                  color: AppColors.purple700,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardBg(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderSoft(context), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.mainText,
                      style: TextStyle(
                        fontSize: 220,
                        fontWeight: FontWeight.w300,
                        color: widget.iconColor.withValues(alpha: 0.12),
                        height: 1,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: _isChecking ? null : _onPanStart,
                  onPanUpdate: _isChecking ? null : _onPanUpdate,
                  child: CustomPaint(
                    painter: _StrokePainter(_strokes),
                    size: Size.infinite,
                  ),
                ),
                if (_isChecking)
                  Positioned.fill(
                    child: Container(
                      color: AppColors.cardBg(context).withValues(alpha: 0.7),
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                              color: AppColors.brandPurple, strokeWidth: 3),
                          SizedBox(height: 12),
                          Text(
                            'Recognizing…',
                            style: TextStyle(
                              color: AppColors.purple700,
                              fontWeight: FontWeight.w700,
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
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: _isChecking ? null : _clearCanvas,
                  icon: const Icon(Icons.cleaning_services_rounded, size: 18),
                  label: const Text('Clear'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textBody,
                    side: const BorderSide(
                        color: AppColors.border, width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    textStyle: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isChecking ? null : _checkDrawing,
                  icon: const Icon(Icons.check_rounded, size: 20),
                  label: const Text('Check'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cardGreen,
                    foregroundColor: AppColors.iconGreen,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _ModeChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.cardBg(context) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: active
                ? Border.all(color: AppColors.text(context), width: 1.5)
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: active ? AppColors.brandPurple : AppColors.textBody,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  _StrokePainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textDark
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.length < 2) {
        if (stroke.length == 1) {
          canvas.drawCircle(stroke.first, 4,
              Paint()..color = AppColors.textDark);
        }
        continue;
      }
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StrokePainter oldDelegate) => true;
}
