import 'package:flutter/material.dart';
import '../models/child.dart';
import '../services/api_client.dart';
import '../services/child_service.dart';
import '../state/app_session.dart';
import '../theme.dart';
import '../widgets/primary_button.dart';
import 'home_screen.dart';

class AddChildScreen extends StatefulWidget {
  final bool isFirstChild;

  const AddChildScreen({super.key, this.isFirstChild = false});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _name = TextEditingController();
  final _age = TextEditingController();
  String _gender = 'male';
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final age = int.tryParse(_age.text.trim());

    if (name.isEmpty) {
      _showError('Enter the child\'s name');
      return;
    }
    if (age == null || age < 1 || age > 20) {
      _showError('Enter a valid age (1–20)');
      return;
    }

    setState(() => _busy = true);
    try {
      final Child child = await ChildService.create(
        name: name,
        age: age,
        gender: _gender,
      );
      await AppSession.instance.setCurrentChild(child);

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    } on ApiException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('Could not save. Try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError(String msg) {
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
      appBar: widget.isFirstChild
          ? null
          : AppBar(
              backgroundColor: AppColors.surface(context),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('Add Child'),
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
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
                child: const Icon(Icons.child_care_rounded,
                    size: 38, color: Colors.white),
              ),
              const SizedBox(height: 18),
              Text(
                widget.isFirstChild ? 'Add Your First Child' : 'Add Another Child',
                style: AppTextStyles.h1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Text(
                'Each child gets their own learning progress',
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 28),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Child Name', style: AppTextStyles.label),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _name,
                enabled: !_busy,
                decoration: const InputDecoration(
                  hintText: 'Enter child\'s name',
                  prefixIcon: Icon(Icons.person_outline,
                      color: AppColors.textMuted, size: 20),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Age', style: AppTextStyles.label),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _age,
                keyboardType: TextInputType.number,
                enabled: !_busy,
                decoration: const InputDecoration(
                  hintText: 'Age (e.g. 6)',
                  prefixIcon: Icon(Icons.cake_outlined,
                      color: AppColors.textMuted, size: 20),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Gender', style: AppTextStyles.label),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _GenderTile(
                      label: 'Boy',
                      icon: Icons.face,
                      selected: _gender == 'male',
                      onTap: _busy ? null : () => setState(() => _gender = 'male'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _GenderTile(
                      label: 'Girl',
                      icon: Icons.face_3,
                      selected: _gender == 'female',
                      onTap: _busy ? null : () => setState(() => _gender = 'female'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: _busy ? 'Saving…' : 'Save & Continue',
                icon: Icons.check_rounded,
                onPressed: _busy ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenderTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  const _GenderTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? AppColors.purple100 : AppColors.cardBg(context),
            border: Border.all(
              color: selected ? AppColors.brandPurple : AppColors.border,
              width: selected ? 2 : 1.2,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 30,
                  color: selected ? AppColors.brandPurple : AppColors.textBody),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: selected ? AppColors.brandPurple : AppColors.textBody,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
