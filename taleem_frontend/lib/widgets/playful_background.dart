import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A lively, continuously-moving decorative layer of floating stars, sparkles,
/// bubbles and rings — designed to keep young children (4–8) engaged while
/// still feeling crisp and premium (not vague color blobs).
///
/// Place as a full-size layer *behind* a screen's content, e.g.
/// `Stack(children: [const Positioned.fill(child: PlayfulBackground()), ...])`.
/// Set [onDark] = true when it sits over a dark/gradient header so the shapes
/// switch to a bright palette.
class PlayfulBackground extends StatefulWidget {
  final bool onDark;

  const PlayfulBackground({super.key, this.onDark = false});

  @override
  State<PlayfulBackground> createState() => _PlayfulBackgroundState();
}

class _PlayfulBackgroundState extends State<PlayfulBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 14))
        ..repeat();

  // type: 0 = filled dot, 1 = ring, 2 = star, 3 = sparkle
  static const List<List<double>> _defs = [
    // x,    y,    size, ampX, ampY, phase, spin, type, colorIndex
    [0.12, 0.09, 26, 10, 18, 0.0, 1, 2, 0],
    [0.86, 0.07, 18, 14, 12, 1.0, 0, 0, 1],
    [0.80, 0.22, 30, 12, 20, 2.0, 0.6, 3, 2],
    [0.16, 0.28, 16, 16, 14, 3.0, -0.6, 1, 3],
    [0.90, 0.50, 22, 10, 22, 1.5, 1, 2, 4],
    [0.07, 0.55, 24, 14, 16, 0.5, -1, 3, 2],
    [0.72, 0.72, 18, 12, 16, 2.5, 0, 0, 0],
    [0.26, 0.82, 30, 16, 20, 3.5, 0.6, 2, 1],
    [0.50, 0.40, 14, 18, 14, 4.2, -0.4, 0, 3],
    [0.40, 0.16, 20, 12, 18, 5.0, 0.8, 3, 4],
  ];

  static const List<Color> _bright = [
    Color(0xFF7B61FF),
    Color(0xFF0D9488),
    Color(0xFFDB2777),
    Color(0xFFCA8A04),
    Color(0xFF2563EB),
  ];

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = _c.value * 2 * math.pi;
          return Stack(
            children: [
              for (final d in _defs)
                _item(t, size, d),
            ],
          );
        },
      ),
    );
  }

  Widget _item(double t, Size size, List<double> d) {
    final phase = d[5];
    final spin = d[6];
    final type = d[7].toInt();
    final color = widget.onDark
        ? Colors.white
        : _bright[d[8].toInt() % _bright.length];

    final left = d[0] * size.width + math.sin(t + phase) * d[3];
    final top = d[1] * size.height + math.cos(t + phase) * d[4];
    final twinkle =
        0.55 + 0.45 * (0.5 + 0.5 * math.sin(t * 1.6 + phase));

    return Positioned(
      left: left,
      top: top,
      child: Transform.rotate(
        angle: t * spin,
        child: Opacity(
          opacity: (widget.onDark ? 0.55 : 0.40) * twinkle,
          child: _shape(type, d[2], color),
        ),
      ),
    );
  }

  Widget _shape(int type, double size, Color color) {
    switch (type) {
      case 1: // ring / bubble
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
          ),
        );
      case 2: // star
        return Icon(Icons.star_rounded, size: size, color: color);
      case 3: // sparkle
        return Icon(Icons.auto_awesome, size: size, color: color);
      default: // filled dot
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        );
    }
  }
}
