import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Current user stream ──────────────────────────────
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // ── SIGN UP ──────────────────────────────────────────
  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user?.updateDisplayName(name.trim());
      await credential.user?.reload();
      // Send email verification right after sign up
      await credential.user?.sendEmailVerification();
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── SIGN IN ──────────────────────────────────────────
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── SIGN OUT ─────────────────────────────────────────
  Future<void> signOut() => _auth.signOut();

  // ── DELETE ACCOUNT ───────────────────────────────────
  Future<void> deleteAccount({required String password}) async {
    try {
      final User? user = _auth.currentUser;
      final String? email = user?.email;

      if (user == null || email == null) {
        throw 'No signed-in user found.';
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      await _auth.currentUser?.reload();
      final User? refreshedUser = _auth.currentUser;
      if (refreshedUser == null) {
        throw 'Unable to confirm signed-in user for deletion.';
      }

      await refreshedUser.delete();
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── PASSWORD RESET (sends email with link/code) ──────
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── CONFIRM PASSWORD RESET (with OTP code) ───────────
  Future<void> confirmPasswordReset({
    required String oobCode,   // the code from the reset email
    required String newPassword,
  }) async {
    try {
      await _auth.confirmPasswordReset(
        code: oobCode,
        newPassword: newPassword,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── VERIFY OTP CODE (before resetting) ───────────────
  Future<String> verifyResetCode(String oobCode) async {
    try {
      // Returns the email associated with the code
      return await _auth.verifyPasswordResetCode(oobCode);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── ERROR HANDLER ─────────────────────────────────────
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'requires-recent-login':
        return 'Please sign in again before deleting your account.';
      case 'invalid-action-code':
        return 'The reset code is invalid or expired.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return e.message ?? 'An error occurred.';
    }
  }
}