import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_config.dart';
import 'config/theme_extensions.dart';
import 'services/app_state_provider.dart';
import 'services/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_navigation_screen.dart';

// Global navigator key for navigation from anywhere in the app
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const SoberPathApp());
}

class SoberPathApp extends StatelessWidget {
  const SoberPathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppStateProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: AppConfig.info.name,
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            theme: SoberPathThemeData.lightTheme(),
            darkTheme: SoberPathThemeData.darkTheme(),
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const AppInitializer(),
            routes: {
              '/checkIn': (context) => const MainNavigationScreen(initialIndex: 0),
              '/progress': (context) => const MainNavigationScreen(initialIndex: 2),
              '/support': (context) => const MainNavigationScreen(initialIndex: 3),
              '/home': (context) => const MainNavigationScreen(initialIndex: 0),
            },
          );
        },
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    // Defer initialization until after the build phase to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    final provider = Provider.of<AppStateProvider>(context, listen: false);
    await provider.initialize();

    if (mounted) {
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() {
    final provider = Provider.of<AppStateProvider>(context, listen: false);

    // Add delay for splash screen effect
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (provider.hasUserProfile) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainNavigationScreen(),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const OnboardingScreen(),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
