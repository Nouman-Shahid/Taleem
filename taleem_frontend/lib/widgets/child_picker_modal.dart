import 'package:flutter/material.dart';
import '../models/child.dart';
import '../screens/add_child_screen.dart';
import '../services/child_service.dart';
import '../state/app_session.dart';
import '../theme.dart';

Future<Child?> showChildPickerModal(
  BuildContext context,
  List<Child> children, {
  bool dismissible = true,
}) {
  return showModalBottomSheet<Child>(
    context: context,
    isScrollControlled: true,
    isDismissible: dismissible,
    enableDrag: dismissible,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _ChildPickerSheet(children: children),
  );
}

class _ChildPickerSheet extends StatefulWidget {
  final List<Child> children;

  const _ChildPickerSheet({required this.children});

  @override
  State<_ChildPickerSheet> createState() => _ChildPickerSheetState();
}

class _ChildPickerSheetState extends State<_ChildPickerSheet> {
  late final List<Child> _children = List<Child>.from(widget.children);
  int? _deletingId;

  Future<void> _confirmDelete(Child c) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove child?'),
        content: Text(
          'This will permanently delete ${c.name} and all of their progress. '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _delete(c);
  }

  Future<void> _delete(Child c) async {
    setState(() => _deletingId = c.id);
    try {
      await ChildService.delete(c.id);
      if (!mounted) return;
      setState(() {
        _children.removeWhere((e) => e.id == c.id);
        _deletingId = null;
      });
      // If the removed child was the active one, switch to another (or none).
      if (AppSession.instance.currentChild?.id == c.id) {
        await AppSession.instance
            .setCurrentChild(_children.isNotEmpty ? _children.first : null);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${c.name} removed'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _deletingId = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not remove child. Please try again.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentId = AppSession.instance.currentChild?.id;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
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
            const SizedBox(height: 16),
            const Text('Who is learning today?', style: AppTextStyles.h2),
            const SizedBox(height: 4),
            const Text('Tap a child to continue, or remove a profile',
                style: AppTextStyles.body),
            const SizedBox(height: 16),
            if (_children.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Text('No children yet. Add one below.',
                    style: AppTextStyles.body),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.45,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _children.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final c = _children[i];
                    final selected = c.id == currentId;
                    final isGirl = c.gender == 'female';
                    final deleting = _deletingId == c.id;
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: deleting ? null : () => Navigator.pop(context, c),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: selected
                                  ? AppColors.brandPurple
                                  : AppColors.border,
                              width: selected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isGirl
                                      ? AppColors.cardPink
                                      : AppColors.cardPurple,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  isGirl ? Icons.face_3 : Icons.face,
                                  color: isGirl
                                      ? AppColors.iconPink
                                      : AppColors.iconPurple,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.text(context),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Age ${c.age}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textMuted,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (selected)
                                Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: AppColors.brandPurple,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check_rounded,
                                      color: Colors.white, size: 16),
                                ),
                              deleting
                                  ? const SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.error),
                                      ),
                                    )
                                  : IconButton(
                                      tooltip: 'Remove',
                                      onPressed: () => _confirmDelete(c),
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: AppColors.error,
                                        size: 22,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddChildScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.purple100,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.brandPurple.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.add_rounded,
                            color: AppColors.brandPurple, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Add New Child',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.brandPurple,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
