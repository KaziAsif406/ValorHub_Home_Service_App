import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:template_flutter/constants/app_constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Current user stream ──────────────────────────────
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // ── SIGN UP ──────────────────────────────────────────
  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
    required String userType,
  }) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();
      final normalizedUserType = userType.trim().toLowerCase();
      if (normalizedUserType != kUserTypeCustomer &&
          normalizedUserType != kUserTypeContractor) {
        throw 'Invalid user type selected.';
      }

      final credential = await _auth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      final userId = credential.user?.uid;
      if (userId == null || userId.isEmpty) {
        throw 'Unable to create user profile. Missing user id.';
      }
      try {
        await credential.user?.updateDisplayName(name.trim());
        await _saveUserProfile(
          userId: userId,
          email: normalizedEmail,
          userType: normalizedUserType,
          name: name.trim(),
        );
        await credential.user?.reload();
        // Send email verification right after sign up
        await credential.user?.sendEmailVerification();
        return credential;
      } catch (error) {
        await credential.user?.delete();
        rethrow;
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (error) {
      throw error.toString();
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
      throw 'No account found with this email.';
    }
  }

  Future<String> getUserTypeByUserId(String userId) async {
    final snapshot = await _firestore
        .collection(kFirestoreUsersCollection)
        .doc(userId)
        .get();

    if (!snapshot.exists) {
      throw 'No user profile found for this email.';
    }

    final data = snapshot.data();
    final String? userType = data?[kKeyUserType] as String?;
    final normalizedUserType = (userType ?? '').trim().toLowerCase();

    if (normalizedUserType != kUserTypeCustomer &&
        normalizedUserType != kUserTypeContractor) {
      throw 'User type is missing for this account.';
    }

    return normalizedUserType;
  }

  // ── SIGN OUT ─────────────────────────────────────────
  Future<void> signOut() async => _auth.signOut();

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
    required String oobCode, // the code from the reset email
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
      case 'account-does-not-exist':
        return 'No account found with this email.';
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

  Future<void> _saveUserProfile({
    required String userId,
    required String email,
    required String userType,
    required String name,
  }) async {
    await _firestore.collection(kFirestoreUsersCollection).doc(userId).set(
      {
        kEmail: email,
        kKeyUserType: userType,
        'displayName': name,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}
