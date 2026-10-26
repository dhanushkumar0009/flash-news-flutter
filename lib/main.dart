import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'services/bookmark_service.dart';
import 'services/theme_service.dart';
import 'theme/app_theme.dart';
import 'widgets/web_shell.dart';

Future<void> main() async {
  // Required before touching shared_preferences, because that talks to the
  // Android side through a platform channel.
  WidgetsFlutterBinding.ensureInitialized();

  await ThemeService.instance.load();
  await BookmarkService.instance.load();

  runApp(const FlashNewsApp());
}

class FlashNewsApp extends StatelessWidget {
  const FlashNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuilds the whole app when the theme is toggled, which is why the
    // switch on the home app bar changes every screen at once.
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.instance.mode,
      builder: (BuildContext context, ThemeMode mode, Widget? _) {
        return MaterialApp(
          title: 'Flash News',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: mode,
          // Only does anything in a wide browser window: it draws the app in a
          // phone-shaped frame. On Android the child is returned unchanged.
          builder: (BuildContext context, Widget? child) =>
              WebShell(child: child ?? const SizedBox.shrink()),
          home: const SplashScreen(),
        );
      },
    );
  }
}
