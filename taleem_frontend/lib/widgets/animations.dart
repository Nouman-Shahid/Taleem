import 'package:flutter/material.dart';

/// Fades + slides + subtly scales its [child] in on first build. Use [delay]
/// to stagger items for a smooth cascading entrance.
class FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offsetY;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 460),
    this.offsetY = 22,
  });

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _fade =
      CurvedAnimation(parent: _c, curve: Curves.easeOut);
  late final Animation<double> _scale =
      Tween<double>(begin: 0.94, end: 1.0).animate(
    CurvedAnimation(parent: _c, curve: Curves.easeOutBack),
  );
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: Offset(0, widget.offsetY / 100),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _c.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _c.forward();
      });
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(scale: _scale, child: widget.child),
      ),
    );
  }
}

/// Tactile press feedback: the [child] springs down slightly while held and
/// bounces back on release — the core "premium, non-static" interaction.
/// Replaces a plain InkWell/GestureDetector for tappable cards and buttons.
class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final BorderRadius? borderRadius;

  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.94,
    this.borderRadius,
  });

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool v) {
    if (widget.onTap == null) return;
    if (_down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? widget.pressedScale : 1.0,
        duration: Duration(milliseconds: _down ? 90 : 260),
        curve: _down ? Curves.easeOut : Curves.elasticOut,
        child: widget.child,
      ),
    );
  }
}

/// A playful pop-in (scale with an elastic overshoot). Good for hero elements
/// like trophies, success icons, dialogs.
class PopIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const PopIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 650),
  });

  @override
  State<PopIn> createState() => _PopInState();
}

class _PopInState extends State<PopIn> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _scale =
      CurvedAnimation(parent: _c, curve: Curves.elasticOut);
  late final Animation<double> _fade =
      CurvedAnimation(parent: _c, curve: const Interval(0, 0.4));

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

/// Gentle, continuous up-and-down bob — adds life to hero elements (logos,
/// mascots) without being distracting.
class Bob extends StatefulWidget {
  final Widget child;
  final double distance;
  final Duration period;

  const Bob({
    super.key,
    required this.child,
    this.distance = 7,
    this.period = const Duration(milliseconds: 2200),
  });

  @override
  State<Bob> createState() => _BobState();
}

class _BobState extends State<Bob> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.period)
        ..repeat(reverse: true);
  late final Animation<double> _a =
      CurvedAnimation(parent: _c, curve: Curves.easeInOut);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _a,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -widget.distance * _a.value),
        child: child,
      ),
      child: widget.child,
    );
  }
}

/// Gentle continuous "breathing" scale — draws the eye to a CTA without
/// being aggressive.
class Pulse extends StatefulWidget {
  final Widget child;
  final double minScale;
  final double maxScale;
  final Duration period;

  const Pulse({
    super.key,
    required this.child,
    this.minScale = 1.0,
    this.maxScale = 1.08,
    this.period = const Duration(milliseconds: 1500),
  });

  @override
  State<Pulse> createState() => _PulseState();
}

class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.period)
        ..repeat(reverse: true);
  late final Animation<double> _a = Tween<double>(
    begin: widget.minScale,
    end: widget.maxScale,
  ).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ScaleTransition(scale: _a, child: widget.child);
}

/// Premium page transition used app-wide: a fade combined with a soft upward
/// slide and slight scale (the Material "shared axis / fade-through" feel).
class PremiumPageTransitionsBuilder extends PageTransitionsBuilder {
  const PremiumPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    // Pure cross-fade: nothing translates or scales, so persistent chrome like
    // the bottom navigation bar stays perfectly still between screens.
    return FadeTransition(opacity: curved, child: child);
  }
}
