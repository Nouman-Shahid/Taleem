import 'package:flutter/material.dart';
import '../state/theme_controller.dart';
import '../theme.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('App Settings'),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: ThemeController.mode,
          builder: (_, current, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle('Appearance'),
                  const SizedBox(height: 12),
                  _ThemeOptionTile(
                    icon: Icons.light_mode_rounded,
                    iconColor: AppColors.iconYellow,
                    bgColor: const Color(0xFFFEF3C7),
                    title: 'Light Mode',
                    subtitle: 'Bright interface',
                    selected: current == ThemeMode.light,
                    onTap: () => ThemeController.setMode(ThemeMode.light),
                  ),
                  const SizedBox(height: 10),
                  _ThemeOptionTile(
                    icon: Icons.dark_mode_rounded,
                    iconColor: AppColors.iconIndigo,
                    bgColor: const Color(0xFFE0E7FF),
                    title: 'Dark Mode',
                    subtitle: 'Easier on the eyes at night',
                    selected: current == ThemeMode.dark,
                    onTap: () => ThemeController.setMode(ThemeMode.dark),
                  ),
                  const SizedBox(height: 10),
                  _ThemeOptionTile(
                    icon: Icons.brightness_auto_rounded,
                    iconColor: AppColors.iconPurple,
                    bgColor: AppColors.cardPurple,
                    title: 'System Default',
                    subtitle: 'Follow your phone settings',
                    selected: current == ThemeMode.system,
                    onTap: () => ThemeController.setMode(ThemeMode.system),
                  ),
                  const SizedBox(height: 28),
                  const _SectionTitle('About'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _AboutRow(label: 'App Name', value: 'Taleem'),
                        const Divider(height: 24),
                        _AboutRow(label: 'Version', value: '1.0.0'),
                        const Divider(height: 24),
                        _AboutRow(label: 'Build', value: 'Final Year Project'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyLarge?.color,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? AppColors.brandPurple
                  : (isDark ? const Color(0xFF2E2E44) : AppColors.border),
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: AppColors.brandPurple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Colors.white, size: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  final String label;
  final String value;
  const _AboutRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
