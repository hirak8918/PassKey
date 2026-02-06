import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/auth_service.dart';
import 'core/theme_provider.dart';
import 'core/storage_service.dart';
import 'ui/theme.dart';
import 'ui/screens/welcome_screen.dart';
import 'ui/screens/pin_screen.dart';
import 'ui/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enforce portrait mode for simplicity
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final storageService = StorageService();
  try {
    await storageService.init();
  } catch (e) {
    debugPrint('Initialization failed: $e');
    // Proceed anyway to let the app launch and show error UI if needed,
    // or just to keep the service connection alive for debugging.
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<StorageService>.value(value: storageService),
      ],
      child: const PassKeyApp(),
    ),
  );
}

class PassKeyApp extends StatefulWidget {
  const PassKeyApp({super.key});

  @override
  State<PassKeyApp> createState() => _PassKeyAppState();
}

class _PassKeyAppState extends State<PassKeyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // Immediate lock on background/inactive
      // final authService = Provider.of<AuthService>(context, listen: false);
      // if (authService.isAuthenticated) {
      //   authService.logout(); // Lock the app
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'PassKey',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, auth, _) {
        if (auth.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!auth.hasPin) {
          return const WelcomeScreen();
        }

        if (!auth.isAuthenticated) {
          return const PinScreen(isSetup: false);
        }

        return const HomeScreen();
      },
    );
  }
}
