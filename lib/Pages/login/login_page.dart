import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skillchain/core/network/api_exception.dart';
import 'package:skillchain/Pages/forgot%20password/forgot_password_screen.dart';
import 'package:skillchain/Pages/home/home_shell.dart';
import 'package:skillchain/Pages/signup/signup_email_page.dart';
import 'package:skillchain/services/auth_service.dart';
import 'package:skillchain/services/google_sign_in_service.dart';
import 'package:skillchain/services/login_api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _loginApi = LoginApiService();
  final _googleSignIn = GoogleSignInService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool rememberMe = true;
  bool obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  /// DEBUG: Shows id_token in a popup with Copy button for Swagger testing.
  static Future<bool> _showIdTokenDialog(BuildContext context, String idToken) async {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Google ID Token (for Swagger)'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SelectableText(
                idToken,
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: idToken));
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy'),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    ).then((v) => v ?? false);
  }

  /// Maps common Google Sign-In platform error codes to user-friendly messages.
  static String? _platformErrorToMessage(String code) {
    switch (code) {
      case 'sign_in_failed':
        return 'Google sign-in failed. Check that SHA-1 is added to your Android OAuth client in Google Cloud.';
      case '10':
        return 'Configuration error: Add SHA-1 to Google Cloud Console for this app.';
      case '12501':
        return 'Sign-in was cancelled.';
      case '7':
        return 'No network connection.';
      default:
        return null;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    _errorMessage = null;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await _loginApi.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      await _authService.persistAuthFromLogin(response);
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeShell()),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    _errorMessage = null;
    setState(() => _isLoading = true);

    try {
      final idToken = await _googleSignIn.signInAndGetIdToken();
      if (!mounted) return;
      if (idToken == null) {
        setState(() => _isLoading = false);
        return; // User cancelled, no error
      }

      // DEBUG: Show id_token popup for Swagger testing (remove in production)
      final proceed = await _showIdTokenDialog(context, idToken);
      if (!mounted) return;
      if (!proceed) {
        setState(() => _isLoading = false);
        return;
      }

      final response = await _loginApi.loginWithGoogle(idToken: idToken);
      await _authService.persistAuthFromLogin(response);
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeShell()),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    } on PlatformException catch (e) {
      developer.log(
        'Google sign-in PlatformException: ${e.code} - ${e.message}',
      );
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage =
            _platformErrorToMessage(e.code) ?? e.message ?? 'Sign-in failed.';
      });
    } catch (e, st) {
      developer.log('Google sign-in error: $e', stackTrace: st);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Google sign-in failed. Please try again. (Check console for details)';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            /// 🔗 Logo
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.shade500,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SvgPicture.asset(
                'assets/images/Vector.svg',
                width: 30,
                height: 30,
              ),
            ),

            const SizedBox(height: 16),

            /// App Title
            const Text(
              "Skill Chain",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            /// Subtitle
            const Text(
              "Seamless Skill Exchange",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            /// Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Manage the global network of skill sharing.\n"
                "Connect, monitor, and grow the Skill Chain ecosystem from one central hub.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.9)),
              ),
            ),
            const SizedBox(height: 15),

            /// 🔐 Login Card - Expanded to fill remaining space
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          // height: double.infinity,
                          child: const Center(
                            child: Text(
                              "Login to get started",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// Email
                        const Text("Email Address"),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: "admin@gmail.com",
                            suffixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                          validator: (value) {
                            final s = value?.trim() ?? '';
                            if (s.isEmpty) return 'Email is required';
                            if (!RegExp(
                              r'^[\w.-]+@[\w.-]+\.\w+$',
                            ).hasMatch(s)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          onChanged: (_) {
                            if (_errorMessage != null) {
                              setState(() => _errorMessage = null);
                            }
                          },
                        ),

                        const SizedBox(height: 16),

                        /// Password
                        const Text("Password"),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: obscurePassword,
                          decoration: InputDecoration(
                            hintText: "password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                          onChanged: (_) {
                            if (_errorMessage != null) {
                              setState(() => _errorMessage = null);
                            }
                          },
                        ),

                        if (_errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ],

                        const SizedBox(height: 10),

                        /// Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text("Forgot password? Reset it here"),
                          ),
                        ),

                        /// Remember Me
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value!;
                                });
                              },
                            ),
                            const Text("Remember me"),
                          ],
                        ),

                        const SizedBox(height: 10),

                        /// Sign In Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    "Sign In →",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// Google Sign In
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : _handleGoogleSignIn,
                            icon: SvgPicture.asset(
                              'assets/images/google.svg',
                              width: 20,
                              height: 20,
                            ),
                            label: const Text('Sign in with Google'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// Signup
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupEmailPage(),
                                ),
                              );
                            },
                            child: const Text("Don't have an account? Sign up"),
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Center(
                          child: Text(
                            "© 2024 Skill Chain. All rights reserved.",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
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
    );
  }
}
