import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'state/app_session.dart';
import 'state/theme_controller.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSession.instance.load();
  await ThemeController.load();
  runApp(const TaleemApp());
}

class TaleemApp extends StatelessWidget {
  const TaleemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (_, mode, _) {
        return MaterialApp(
          title: 'Taleem',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: mode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
