import 'package:google_sign_in/google_sign_in.dart';

import 'package:skillchain/config/auth_config.dart';

/// Handles Google Sign-In and returns the ID token for backend exchange.
class GoogleSignInService {
  GoogleSignInService() {
    _googleSignIn = GoogleSignIn(
      serverClientId: AuthConfig.webClientId,
      scopes: ['email', 'profile'],
    );
  }

  late final GoogleSignIn _googleSignIn;

  /// Signs in with Google and returns the ID token, or null if user cancelled.
  Future<String?> signInAndGetIdToken() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null; // User cancelled

      final auth = await account.authentication;
      return auth.idToken;
    } catch (_) {
      rethrow;
    }
  }

  /// Signs out (call when user explicitly logs out of Google).
  Future<void> signOut() => _googleSignIn.signOut();
}
