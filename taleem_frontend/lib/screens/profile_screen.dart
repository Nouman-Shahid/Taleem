import 'package:flutter/material.dart';
import '../models/progress_summary.dart';
import '../services/auth_service.dart';
import '../services/child_service.dart';
import '../services/progress_service.dart';
import '../state/app_session.dart';
import '../theme.dart';
import '../widgets/child_picker_modal.dart';
import '../widgets/main_bottom_nav.dart';
import '../widgets/playful_background.dart';
import 'app_settings_screen.dart';
import 'help_support_screen.dart';
import 'learning_center_screen.dart';
import 'login_screen.dart';
import 'progress_screen.dart';
import 'terms_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProgressSummary? _summary;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    final child = AppSession.instance.currentChild;
    if (child == null) {
      debugPrint('[Profile] _loadSummary: no current child');
      setState(() {
        _summary = ProgressSummary.empty();
        _loading = false;
      });
      return;
    }
    debugPrint('[Profile] _loadSummary for child=${child.id} (${child.name})');
    try {
      final s = await ProgressService.summary(child.id);
      debugPrint('[Profile] summary received: '
          'lessons=${s.lessonsCompleted} badges=${s.badges} acc=${s.accuracyPercent}%');
      if (!mounted) return;
      setState(() {
        _summary = s;
        _loading = false;
      });
    } catch (e) {
      debugPrint('[Profile] _loadSummary FAILED: $e');
      if (!mounted) return;
      setState(() {
        _summary = ProgressSummary.empty();
        _loading = false;
      });
    }
  }

  Future<void> _switchChild() async {
    try {
      final children = await ChildService.list();
      if (!mounted) return;
      final picked = await showChildPickerModal(context, children);
      if (picked != null) {
        await AppSession.instance.setCurrentChild(picked);
        setState(() => _loading = true);
        _loadSummary();
      }
    } catch (_) {}
  }

  void _onNavTap(int i) {
    if (i == 3) return;
    Navigator.popUntil(context, (r) => r.isFirst);
    if (i == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LearningCenterScreen()),
      );
    } else if (i == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProgressScreen()),
      );
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();
    await AppSession.instance.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  String _memberSince() {
    final created = AppSession.instance.user?.createdAt;
    if (created == null) return '—';
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[created.month - 1]} ${created.year}';
  }

  @override
  Widget build(BuildContext context) {
    final user = AppSession.instance.user;
    final child = AppSession.instance.currentChild;
    final summary = _summary ?? ProgressSummary.empty();

    return Scaffold(
      backgroundColor: AppColors.surface(context),
      body: Column(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              gradient: kPurpleGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Stack(
              children: [
                const Positioned.fill(
                    child: PlayfulBackground(onDark: true)),
                SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded,
                              color: Colors.white, size: 24),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: _switchChild,
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    gradient: kPurpleGradient,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.person_outline_rounded,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        user?.name ?? 'Parent',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColors.text(context),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        user?.email ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: AppColors.iconPurple,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (child != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          'Active: ${child.name} · Tap to switch',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: AppColors.textMuted,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.swap_horiz_rounded,
                                  color: AppColors.brandPurple,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadSummary,
              color: AppColors.brandPurple,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const _SectionTitle('Your Stats'),
                      const Spacer(),
                      if (_loading)
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.brandPurple),
                        )
                      else
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            setState(() => _loading = true);
                            _loadSummary();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.refresh_rounded,
                                color: AppColors.brandPurple, size: 18),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.emoji_events_rounded,
                          tint: const Color(0xFFFEF3C7),
                          iconColor: const Color(0xFFCA8A04),
                          value: '${summary.badges}',
                          label: 'Badges',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.menu_book_rounded,
                          tint: const Color(0xFFDBEAFE),
                          iconColor: const Color(0xFF2563EB),
                          value: '${summary.lessonsCompleted}',
                          label: 'Lessons',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.gps_fixed_rounded,
                          tint: const Color(0xFFD1FAE5),
                          iconColor: const Color(0xFF059669),
                          value: '${summary.accuracyPercent.round()}%',
                          label: 'Score',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  const _SectionTitle('Account Details'),
                  const SizedBox(height: 12),
                  _DetailCard(
                    icon: Icons.mail_outline_rounded,
                    tint: AppColors.cardPurple,
                    iconColor: AppColors.iconPurple,
                    label: 'Email',
                    value: user?.email ?? '—',
                  ),
                  const SizedBox(height: 10),
                  _DetailCard(
                    icon: Icons.calendar_today_rounded,
                    tint: AppColors.cardTeal,
                    iconColor: AppColors.iconTeal,
                    label: 'Member Since',
                    value: _memberSince(),
                  ),
                  const SizedBox(height: 26),
                  const _SectionTitle('Settings'),
                  const SizedBox(height: 12),
                  _SettingsItem(
                    icon: Icons.settings_outlined,
                    label: 'App Settings',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AppSettingsScreen()),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _SettingsItem(
                    icon: Icons.gavel_rounded,
                    label: 'Terms & Conditions',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TermsScreen()),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _SettingsItem(
                    icon: Icons.help_outline_rounded,
                    label: 'Help & Support',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const HelpSupportScreen()),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: _logout,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout_rounded,
                                color: AppColors.error, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: 3,
        onTap: _onNavTap,
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
        color: AppColors.text(context),
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color tint;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.tint,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: tint,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textBody,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final Color tint;
  final Color iconColor;
  final String label;
  final String value;

  const _DetailCard({
    required this.icon,
    required this.tint,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: tint,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBg(context),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.chipBg(context),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: AppColors.textBody, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: AppColors.textMuted, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
