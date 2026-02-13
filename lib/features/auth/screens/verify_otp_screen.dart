import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skillchain/features/auth/services/password_service.dart';
import 'package:skillchain/features/auth/screens/reset_password_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key, required this.email});

  final String email;

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordService = PasswordService();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final resetToken = await _passwordService.verifyOtp(
        widget.email,
        _otpController.text.trim(),
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(resetToken: resetToken),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e is Exception ? e.toString().replaceFirst('Exception: ', '') : 'Something went wrong',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  Future<void> _resendOtp() async {
    setState(() => _isLoading = true);
    try {
      await _passwordService.forgotPassword(widget.email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'OTP sent again. Check your email and spam folder.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green.shade700,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e is Exception ? e.toString().replaceFirst('Exception: ', '') : 'Something went wrong',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
            const Text(
              'Skill Chain',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Verify OTP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Enter the 6-digit code sent to ${widget.email}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.grey.shade700),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                            'Enter OTP',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            '6-digit code from your email',
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text('OTP'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: InputDecoration(
                            hintText: '000000',
                            counterText: '',
                            suffixIcon: const Icon(Icons.pin_outlined),
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
                            if (s.length != 6) return 'Enter 6 digits';
                            if (!RegExp(r'^\d{6}$').hasMatch(s)) return 'OTP must be 6 digits';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _isLoading ? null : _resendOtp,
                          child: Text(
                            "Didn't receive the code? Resend OTP",
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
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
                            onPressed: _isLoading ? null : _verifyOtp,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text('Verify OTP'),
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
