// Request/response models for the signup flow (verify email, verify OTP, final signup).

// --- Verify Email ---
class VerifyEmailRequest {
  VerifyEmailRequest({required this.email});
  final String email;
  Map<String, dynamic> toJson() => {'email': email};
}

class VerifyEmailResponse {
  VerifyEmailResponse({required this.message});
  final String message;
  factory VerifyEmailResponse.fromJson(Map<String, dynamic> json) =>
      VerifyEmailResponse(message: json['message'] as String? ?? '');
}

// --- Verify OTP (Signup) ---
class VerifyOtpSignupRequest {
  VerifyOtpSignupRequest({required this.email, required this.otp});
  final String email;
  final String otp;
  Map<String, dynamic> toJson() => {'email': email, 'otp': otp};
}

class VerifyOtpSignupResponse {
  VerifyOtpSignupResponse({
    required this.message,
    required this.token,
    required this.expiresIn,
  });
  final String message;
  final String token;
  final int expiresIn;
  factory VerifyOtpSignupResponse.fromJson(Map<String, dynamic> json) =>
      VerifyOtpSignupResponse(
        message: json['message'] as String? ?? '',
        token: json['token'] as String? ?? '',
        expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 0,
      );
}

// --- Final Signup (multipart) ---
class SignupSuccessResponse {
  SignupSuccessResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });
  final Map<String, dynamic> user;
  final String accessToken;
  final String refreshToken;
  factory SignupSuccessResponse.fromJson(Map<String, dynamic> json) =>
      SignupSuccessResponse(
        user: Map<String, dynamic>.from(
          (json['user'] as Map<String, dynamic>? ?? {}),
        ),
        accessToken: json['accessToken'] as String? ?? '',
        refreshToken: json['refreshToken'] as String? ?? '',
      );
}

// --- Skills (for dropdown; loaded from backend) ---
class SkillItem {
  SkillItem({required this.id, required this.name});
  final String id;
  final String name;
  factory SkillItem.fromJson(Map<String, dynamic> json) => SkillItem(
        id: (json['id'] ?? json['_id'] ?? '').toString(),
        name: (json['name'] ?? json['title'] ?? '').toString(),
      );
}
