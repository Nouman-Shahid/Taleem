import 'dart:async';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../state/app_session.dart';
import '../theme.dart';
import '../widgets/animations.dart';
import 'add_child_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    final session = AppSession.instance;

    if (!session.isAuthed) {
      _go(const LoginScreen());
      return;
    }

    try {
      final me = await AuthService.me();
      await session.setAuth(token: session.token!, user: me.user);

      if (me.children.isEmpty) {
        if (!mounted) return;
        _go(const AddChildScreen(isFirstChild: true));
        return;
      }

      final stillExists = session.currentChild != null &&
          me.children.any((c) => c.id == session.currentChild!.id);
      if (!stillExists) {
        await session.setCurrentChild(me.children.first);
      }
      if (!mounted) return;
      _go(const HomeScreen());
    } catch (_) {
      await session.clear();
      if (!mounted) return;
      _go(const LoginScreen());
    }
  }

  void _go(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: kPurpleGradient),
        child: Stack(
          children: [
            Positioned(
              top: 60,
              left: 30,
              child: Icon(Icons.auto_awesome,
                  color: Colors.white.withValues(alpha: 0.4), size: 24),
            ),
            Positioned(
              top: 90,
              right: 40,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 160,
              left: 36,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 180,
              right: 32,
              child: Icon(Icons.auto_awesome,
                  color: Colors.white.withValues(alpha: 0.4), size: 20),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PopIn(
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.school_rounded,
                        size: 44,
                        color: AppColors.brandPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const FadeSlideIn(
                    delay: Duration(milliseconds: 300),
                    child: Text(
                      'TALEEM',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 450),
                    child: Text(
                      'تعلیم',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 600),
                    child: Text(
                      'Learn & Grow Together',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
