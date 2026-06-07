import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/primary_button.dart';

class ChildSelectionScreen extends StatefulWidget {
  const ChildSelectionScreen({super.key});

  @override
  State<ChildSelectionScreen> createState() => _ChildSelectionScreenState();
}

class _ChildSelectionScreenState extends State<ChildSelectionScreen> {
  int _selected = 0;

  final List<Map<String, dynamic>> _children = [
    {
      'name': 'Ahmed Ali',
      'age': 6,
      'icon': Icons.face,
      'tint': AppColors.cardPurple,
      'iconColor': AppColors.iconPurple,
    },
    {
      'name': 'Ayesha Khan',
      'age': 5,
      'icon': Icons.face_3,
      'tint': AppColors.cardPink,
      'iconColor': AppColors.iconPink,
    },
  ];

  void _addChild() {
    final nameCtrl = TextEditingController();
    final ageCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text('Add Child', style: AppTextStyles.h2),
              const SizedBox(height: 18),
              const Text('Full Name', style: AppTextStyles.label),
              const SizedBox(height: 8),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  hintText: 'Child name',
                  prefixIcon: Icon(Icons.person_outline,
                      color: AppColors.textMuted, size: 20),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Age', style: AppTextStyles.label),
              const SizedBox(height: 8),
              TextField(
                controller: ageCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Age',
                  prefixIcon: Icon(Icons.cake_outlined,
                      color: AppColors.textMuted, size: 20),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Add Child',
                icon: Icons.check_rounded,
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty) return;
                  setState(() {
                    _children.add({
                      'name': nameCtrl.text.trim(),
                      'age': int.tryParse(ageCtrl.text) ?? 5,
                      'icon': Icons.face,
                      'tint': AppColors.cardTeal,
                      'iconColor': AppColors.iconTeal,
                    });
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Child Profiles'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              const Text('Who is learning today?', style: AppTextStyles.h2),
              const SizedBox(height: 6),
              const Text('Select a profile to continue', style: AppTextStyles.body),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: _children.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    if (i == _children.length) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _addChild,
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppColors.purple100,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: AppColors.brandPurple.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(Icons.add_rounded,
                                      color: AppColors.brandPurple, size: 26),
                                ),
                                const SizedBox(width: 14),
                                const Text(
                                  'Add New Child',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.brandPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    final c = _children[i];
                    final isSelected = i == _selected;
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => setState(() => _selected = i),
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.brandPurple
                                  : AppColors.border,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: c['tint'] as Color,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                alignment: Alignment.center,
                                child: Icon(c['icon'] as IconData,
                                    color: c['iconColor'] as Color, size: 28),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c['name'] as String,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.text(context),
                                        )),
                                    const SizedBox(height: 2),
                                    Text('Age ${c['age']}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textMuted,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: const BoxDecoration(
                                    color: AppColors.brandPurple,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check_rounded,
                                      color: Colors.white, size: 18),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: PrimaryButton(
                  label: 'Continue',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
