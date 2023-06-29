import 'package:capture_app/app_config_provider.dart';
import 'package:capture_app/pages/password_change.dart';
import 'package:capture_app/pages/profile_screen.dart';
import 'package:capture_app/pages/register_screen.dart';
import 'package:capture_app/pages/scan_page.dart';
import 'package:capture_app/pages/settings.dart';
import 'package:capture_app/utils/no_login.dart';
import 'package:capture_app/utils/protected.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import './pages/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppConfigProvider>(
      create: (_) => AppConfigProvider(secureStorage),
      child: MaterialApp(
        title: 'Power Monitor',
        routes: {
          '/login': (context) => const NologinRoute(child: LoginScreen()),
          '/register': (context) => const RegisterScreen(),
          '/scan': (context) => const ProtectedRoute(child: ScanPage()),
          '/profile': (context) => const ProtectedRoute(child: ProfileScreen()),
          '/settings': (context) => const ProtectedRoute(child: SettingsPage()),
          '/change_password': (context) =>
              const ProtectedRoute(child: ChangePasswordPage())
        },
        initialRoute: '/login',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0Xff44bac2)),
          useMaterial3: true,
        ),
      ),
    );
  }
}
