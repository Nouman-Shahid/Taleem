import 'package:flutter/material.dart';
import '../models/progress_summary.dart';
import '../services/api_client.dart';
import '../state/app_session.dart';
import '../theme.dart';
import '../widgets/main_bottom_nav.dart';
import '../widgets/playful_background.dart';
import 'learning_center_screen.dart';
import 'profile_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with WidgetsBindingObserver {
  ProgressSummary _summary = ProgressSummary.empty();
  List<Map<String, dynamic>> _modules = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-fetch when the user returns to the app so progress stays current.
    if (state == AppLifecycleState.resumed) _load();
  }

  Future<void> _load() async {
    final child = AppSession.instance.currentChild;
    if (child == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final res = await ApiClient.get('/progress/${child.id}/summary')
          as Map<String, dynamic>;
      final overall =
          (res['overall'] as Map<String, dynamic>?) ?? const {};
      final modules = (res['modules'] as List? ?? const [])
          .cast<Map<String, dynamic>>();
      if (!mounted) return;
      setState(() {
        _summary = ProgressSummary.fromJson(overall);
        _modules = modules;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _onNavTap(int i) {
    if (i == 2) return;
    Navigator.popUntil(context, (r) => r.isFirst);
    if (i == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LearningCenterScreen()),
      );
    } else if (i == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    }
  }

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  String _prettyModuleName(String key) {
    switch (key) {
      case 'imla':
        return 'Imla Practice';
      case 'quiz_counting':
        return 'Counting Quiz';
      case 'quiz_english_alphabet':
        return 'English Alphabet Quiz';
      case 'quiz_urdu_alphabet':
        return 'Urdu Alphabet Quiz';
      default:
        return key
            .replaceAll('_', ' ')
            .split(' ')
            .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
            .join(' ');
    }
  }

  Color _moduleTint(String key) {
    if (key == 'imla') return AppColors.cardGreen;
    if (key.contains('counting')) return AppColors.cardYellow;
    if (key.contains('english')) return AppColors.cardPink;
    if (key.contains('urdu')) return AppColors.cardPurple;
    return AppColors.cardBlue;
  }

  Color _moduleIcon(String key) {
    if (key == 'imla') return AppColors.iconGreen;
    if (key.contains('counting')) return AppColors.iconYellow;
    if (key.contains('english')) return AppColors.iconPink;
    if (key.contains('urdu')) return AppColors.iconPurple;
    return AppColors.iconBlue;
  }

  IconData _moduleIconData(String key) {
    if (key == 'imla') return Icons.draw_rounded;
    if (key.contains('counting')) return Icons.format_list_numbered_rounded;
    if (key.contains('english')) return Icons.abc_rounded;
    if (key.contains('urdu')) return Icons.translate_rounded;
    return Icons.school_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final child = AppSession.instance.currentChild;
    return Scaffold(
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
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Progress',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      child != null
                          ? 'Tracking ${child.name}\'s journey'
                          : 'Pick a child profile to see progress',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _HeaderStat(
                            label: 'Accuracy',
                            value: '${_summary.accuracyPercent.round()}%',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _HeaderStat(
                            label: 'Lessons',
                            value: '${_summary.lessonsCompleted}',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _HeaderStat(
                            label: 'Badges',
                            value: '${_summary.badges}',
                          ),
                        ),
                      ],
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
              onRefresh: _load,
              color: AppColors.brandPurple,
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.brandPurple),
                    )
                  : _modules.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 80),
                            Icon(Icons.insights_rounded,
                                color: AppColors.textMuted, size: 56),
                            const SizedBox(height: 12),
                            Text(
                              'No activity yet',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.text(context),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Start a quiz or lesson to see progress here',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _modules.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (_, i) {
                            final m = _modules[i];
                            final key = m['module_type'] as String;
                            final score = _toInt(m['total_score']);
                            final total = _toInt(m['total_attempts']);
                            final pct = total > 0 ? score / total : 0.0;
                            return Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.cardBg(context),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: AppColors.borderSoft(context),
                                    width: 1),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: _moduleTint(key),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      _moduleIconData(key),
                                      color: _moduleIcon(key),
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _prettyModuleName(key),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.text(context),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '$score/$total',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: _moduleIcon(key),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: LinearProgressIndicator(
                                            value: pct.clamp(0.0, 1.0),
                                            minHeight: 6,
                                            backgroundColor: _moduleTint(key),
                                            valueColor: AlwaysStoppedAnimation(
                                                _moduleIcon(key)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: 2,
        onTap: _onNavTap,
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String label;
  final String value;
  const _HeaderStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

