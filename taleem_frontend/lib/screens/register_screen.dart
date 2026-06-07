import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../state/app_session.dart';
import '../theme.dart';
import '../widgets/primary_button.dart';
import 'add_child_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool obscure = true;
  bool _busy = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final password = passCtrl.text;

    if (name.isEmpty || email.isEmpty || password.length < 6) {
      _showError('Enter your name, a valid email, and a 6+ char password');
      return;
    }

    setState(() => _busy = true);
    try {
      final result =
          await AuthService.register(name: name, email: email, password: password);
      await AppSession.instance.setAuth(token: result.token, user: result.user);

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AddChildScreen(isFirstChild: true)),
        (_) => false,
      );
    } on ApiException catch (e) {
      String msg = e.message;
      if (e.body != null && e.body!['errors'] is Map) {
        final errors = e.body!['errors'] as Map;
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) msg = first.first.toString();
      }
      _showError(msg);
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
      appBar: AppBar(
        backgroundColor: AppColors.surface(context),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
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
              const Text('Create Account', style: AppTextStyles.h1),
              const SizedBox(height: 6),
              const Text(
                'Sign up to start your learning journey',
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Full Name', style: AppTextStyles.label),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameCtrl,
                enabled: !_busy,
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                  prefixIcon: Icon(Icons.person_outline,
                      color: AppColors.textMuted, size: 20),
                ),
              ),
              const SizedBox(height: 16),
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
                  hintText: 'At least 6 characters',
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
              const SizedBox(height: 24),
              PrimaryButton(
                label: _busy ? 'Creating account…' : 'Sign Up',
                onPressed: _busy ? null : _register,
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ',
                      style: TextStyle(color: AppColors.textBody, fontSize: 14)),
                  GestureDetector(
                    onTap: _busy ? null : () => Navigator.pop(context),
                    child: const Text(
                      'Login',
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
