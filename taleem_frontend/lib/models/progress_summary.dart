class ProgressSummary {
  final int totalScore;
  final int totalAttempts;
  final double accuracyPercent;
  final int lessonsCompleted;
  final int badges;

  ProgressSummary({
    required this.totalScore,
    required this.totalAttempts,
    required this.accuracyPercent,
    required this.lessonsCompleted,
    required this.badges,
  });

  factory ProgressSummary.fromJson(Map<String, dynamic> overall) {
    return ProgressSummary(
      totalScore: _i(overall['total_score']),
      totalAttempts: _i(overall['total_attempts']),
      accuracyPercent: _d(overall['accuracy_percent']),
      lessonsCompleted: _i(overall['lessons_completed']),
      badges: _i(overall['badges']),
    );
  }

  static int _i(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  static double _d(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  static ProgressSummary empty() => ProgressSummary(
        totalScore: 0,
        totalAttempts: 0,
        accuracyPercent: 0,
        lessonsCompleted: 0,
        badges: 0,
      );
}
