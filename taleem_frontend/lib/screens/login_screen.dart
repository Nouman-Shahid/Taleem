import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../state/app_session.dart';
import '../theme.dart';
import '../widgets/child_picker_modal.dart';
import '../widgets/primary_button.dart';
import 'add_child_screen.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool obscure = true;
  bool _busy = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = emailCtrl.text.trim();
    final password = passCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter email and password');
      return;
    }

    setState(() => _busy = true);
    try {
      final result = await AuthService.login(email: email, password: password);
      await AppSession.instance.setAuth(token: result.token, user: result.user);

      final me = await AuthService.me();

      if (!mounted) return;

      if (me.children.isEmpty) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AddChildScreen(isFirstChild: true)),
          (_) => false,
        );
        return;
      }

      if (me.children.length == 1) {
        await AppSession.instance.setCurrentChild(me.children.first);
      } else {
        if (!mounted) return;
        final picked = await showChildPickerModal(context, me.children);
        if (picked != null) {
          await AppSession.instance.setCurrentChild(picked);
        } else {
          await AppSession.instance.setCurrentChild(me.children.first);
        }
      }

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    } on ApiException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('Could not connect. Check your network and try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  gradient: kPurpleGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.purple500.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.school_rounded,
                    size: 40, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text('Welcome to TALEEM', style: AppTextStyles.h1),
              const SizedBox(height: 6),
              const Text(
                'Learn Islam in a simple and modern way',
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Email Address', style: AppTextStyles.label),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                enabled: !_busy,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.mail_outline,
                      color: AppColors.textMuted, size: 20),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Password', style: AppTextStyles.label),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passCtrl,
                obscureText: obscure,
                enabled: !_busy,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline,
                      color: AppColors.textMuted, size: 20),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => obscure = !obscure),
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              PrimaryButton(
                label: _busy ? 'Logging in…' : 'Login',
                onPressed: _busy ? null : _login,
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ",
                      style: TextStyle(color: AppColors.textBody, fontSize: 14)),
                  GestureDetector(
                    onTap: _busy
                        ? null
                        : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterScreen()),
                            ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: AppColors.brandPurple,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
