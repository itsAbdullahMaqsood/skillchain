import 'package:flutter/material.dart';
import 'package:skillchain/core/network/auth_interceptor.dart';
import 'package:skillchain/Pages/login/login_page.dart';
import 'package:skillchain/Pages/splash_screen.dart';
import 'package:skillchain/services/api_service.dart';
import 'package:skillchain/services/auth_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  final authService = AuthService();
  ApiService.configureAuth(
    AuthInterceptorCallbacks(
      getAccessToken: authService.getAccessToken,
      refreshToken: authService.refreshAccessToken,
      onLogoutRequired: () {
        authService.logout().then((_) {
          if (navigatorKey.currentContext != null) {
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (_) => false,
            );
          }
        });
      },
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Skill Chain',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(0, 15, 141, 243),
        ),
      ),
      home: const SplashScreen(),
      routes: {'/login': (context) => const LoginScreen()},
      debugShowCheckedModeBanner: false,
    );
  }
}
