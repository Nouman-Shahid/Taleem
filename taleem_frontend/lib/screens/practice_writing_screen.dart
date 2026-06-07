import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/main_bottom_nav.dart';
import '../widgets/result_dialog.dart';
import 'learning_center_screen.dart';
import 'profile_screen.dart';

class PracticeWritingScreen extends StatefulWidget {
  const PracticeWritingScreen({super.key});

  @override
  State<PracticeWritingScreen> createState() =>
      _PracticeWritingScreenState();
}

class _PracticeWritingScreenState extends State<PracticeWritingScreen> {
  final List<List<Offset>> _strokes = [];
  int _patternIndex = 0;

  static final List<Path Function(Size)> _patterns = [
    (Size s) {
      final p = Path();
      p.moveTo(s.width * 0.18, s.height * 0.65);
      p.cubicTo(
        s.width * 0.35, s.height * 0.20,
        s.width * 0.65, s.height * 0.20,
        s.width * 0.82, s.height * 0.65,
      );
      return p;
    },
    (Size s) {
      final p = Path();
      p.moveTo(s.width * 0.2, s.height * 0.3);
      p.cubicTo(
        s.width * 0.55, s.height * 0.3,
        s.width * 0.45, s.height * 0.7,
        s.width * 0.8, s.height * 0.7,
      );
      return p;
    },
    (Size s) {
      final p = Path();
      p.moveTo(s.width * 0.2, s.height * 0.25);
      p.lineTo(s.width * 0.8, s.height * 0.75);
      return p;
    },
    (Size s) {
      final p = Path();
      p.moveTo(s.width * 0.15, s.height * 0.5);
      p.quadraticBezierTo(
        s.width * 0.32, s.height * 0.25,
        s.width * 0.5, s.height * 0.5,
      );
      p.quadraticBezierTo(
        s.width * 0.68, s.height * 0.75,
        s.width * 0.85, s.height * 0.5,
      );
      return p;
    },
  ];

  void _onPanStart(DragStartDetails d) {
    setState(() => _strokes.add([d.localPosition]));
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() {
      _strokes.last = List<Offset>.from(_strokes.last)..add(d.localPosition);
    });
  }

  void _newPattern() {
    setState(() {
      _patternIndex = (_patternIndex + 1) % _patterns.length;
      _strokes.clear();
    });
  }

  Future<void> _check() async {
    final totalPoints = _strokes.fold<int>(0, (sum, s) => sum + s.length);
    final hasEnoughInk = totalPoints > 20;

    await showResultDialog(
      context,
      kind: hasEnoughInk ? ResultKind.correct : ResultKind.empty,
      target: 'stroke',
      customSubline: hasEnoughInk
          ? 'Excellent tracing! Tap + to try a new stroke.'
          : 'Trace over the example curve to practice.',
      onContinue: () {
        if (mounted && hasEnoughInk) _newPattern();
      },
    );
  }

  void _onNavTap(int i) {
    if (i == 2) return;
    Navigator.popUntil(context, (route) => route.isFirst);
    if (i == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LearningCenterScreen()),
      );
    } else if (i == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface(context),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              color: AppColors.surface(context),
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded,
                            color: AppColors.brandPurple, size: 26),
                        onPressed: () =>
                            Navigator.popUntil(context, (r) => r.isFirst),
                      ),
                      const Text(
                        'Practice Writing',
                        style: TextStyle(
                          color: AppColors.brandPurple,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 56),
                    child: Text(
                      'Trace the example stroke',
                      style: TextStyle(
                        color: AppColors.iconTeal,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg(context),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 1.35,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.surface(context),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.purple100,
                                  width: 1.5,
                                ),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onPanStart: _onPanStart,
                                onPanUpdate: _onPanUpdate,
                                child: CustomPaint(
                                  painter: _TracePainter(
                                    pattern: _patterns[_patternIndex],
                                    strokes: _strokes,
                                  ),
                                  size: Size.infinite,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: _newPattern,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: AppColors.cardPurple,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.add_rounded,
                                    color: AppColors.brandPurple, size: 26),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: kPurpleGradient,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.purple500.withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: _check,
                            child: const Center(
                              child: Text(
                                'Check Answer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: 2,
        onTap: _onNavTap,
      ),
    );
  }
}

class _TracePainter extends CustomPainter {
  final Path Function(Size) pattern;
  final List<List<Offset>> strokes;

  _TracePainter({required this.pattern, required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    final examplePaint = Paint()
      ..color = AppColors.brandPurple.withValues(alpha: 0.30)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(pattern(size), examplePaint);

    final userPaint = Paint()
      ..color = AppColors.textDark
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.length < 2) {
        if (stroke.length == 1) {
          canvas.drawCircle(stroke.first, 3,
              Paint()..color = AppColors.textDark);
        }
        continue;
      }
      final p = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        p.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(p, userPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TracePainter oldDelegate) => true;
}
