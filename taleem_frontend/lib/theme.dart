import 'package:flutter/material.dart';
import 'widgets/animations.dart';

class AppColors {
  static const Color brandPurple = Color(0xFF7B61FF);
  static const Color purple100 = Color(0xFFF3E8FF);
  static const Color purple200 = Color(0xFFE9D5FF);
  static const Color purple300 = Color(0xFFD8B4FE);
  static const Color purple400 = Color(0xFFC084FC);
  static const Color purple500 = Color(0xFFA855F7);
  static const Color purple600 = Color(0xFF9333EA);
  static const Color purple700 = Color(0xFF7E22CE);

  static const Color background = Color(0xFFFAF5FF);
  static const Color card = Colors.white;

  static const Color textDark = Color(0xFF1F2937);
  static const Color textBody = Color(0xFF4B5563);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);

  static const Color cardPurple = Color(0xFFF3E8FF);
  static const Color cardOrange = Color(0xFFFFEDD5);
  static const Color cardPink = Color(0xFFFCE7F3);
  static const Color cardTeal = Color(0xFFCCFBF1);
  static const Color cardYellow = Color(0xFFFEF9C3);
  static const Color cardBlue = Color(0xFFDBEAFE);
  static const Color cardGreen = Color(0xFFD1FAE5);
  static const Color cardIndigo = Color(0xFFE0E7FF);

  static const Color iconPurple = Color(0xFF9333EA);
  static const Color iconOrange = Color(0xFFEA580C);
  static const Color iconPink = Color(0xFFDB2777);
  static const Color iconTeal = Color(0xFF0D9488);
  static const Color iconYellow = Color(0xFFCA8A04);
  static const Color iconBlue = Color(0xFF2563EB);
  static const Color iconGreen = Color(0xFF059669);
  static const Color iconIndigo = Color(0xFF4F46E5);

  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);

  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleRed = Color(0xFFEA4335);
  static const Color googleYellow = Color(0xFFFBBC05);
  static const Color googleGreen = Color(0xFF34A853);

  // ---- Theme-aware helpers (use these in screens for dark-mode support) ----
  static const Color darkSurface = Color(0xFF0F0F1A);
  static const Color darkCard = Color(0xFF1A1A2E);
  static const Color darkBorder = Color(0xFF2E2E44);

  static Color surface(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? darkSurface : Colors.white;

  static Color cardBg(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? darkCard : Colors.white;

  static Color text(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? Colors.white : textDark;

  static Color textSoft(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark
          ? const Color(0xFFCBD5E1)
          : textBody;

  static Color borderSoft(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? darkBorder : border;

  static Color chipBg(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark
          ? const Color(0xFF1F1F31)
          : const Color(0xFFF3F4F6);
}

const LinearGradient kPurpleGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [AppColors.purple400, AppColors.purple500, AppColors.purple600],
);

const LinearGradient kPurpleSoftGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFFFAF5FF), Color(0xFFF3E8FF)],
);

class AppTextStyles {
  static const TextStyle h1 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.2,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    height: 1.25,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.brandPurple,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brandPurple,
      primary: AppColors.brandPurple,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: PremiumPageTransitionsBuilder(),
        TargetPlatform.iOS: PremiumPageTransitionsBuilder(),
      },
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textDark),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
      centerTitle: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.brandPurple, width: 1.8),
      ),
    ),
  );
}

ThemeData buildDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.brandPurple,
    scaffoldBackgroundColor: const Color(0xFF0F0F1A),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brandPurple,
      brightness: Brightness.dark,
      primary: AppColors.brandPurple,
      surface: const Color(0xFF1A1A2E),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: PremiumPageTransitionsBuilder(),
        TargetPlatform.iOS: PremiumPageTransitionsBuilder(),
      },
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      centerTitle: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1F1F31),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF2E2E44), width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF2E2E44), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.brandPurple, width: 1.8),
      ),
    ),
  );
}
