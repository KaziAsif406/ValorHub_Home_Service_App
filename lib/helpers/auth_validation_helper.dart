import 'package:firebase_auth/firebase_auth.dart';

/// Production-ready authentication validation and error mapping helper
class AuthValidationHelper {
  // ─── EMAIL VALIDATION ───────────────────────────────────
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    // Basic email regex pattern
    const String emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final RegExp emailRegex = RegExp(emailPattern);
    
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    
    return null; // Valid
  }

  // ─── PASSWORD VALIDATION ────────────────────────────────
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null; // Valid
  }

  // ─── CONFIRM PASSWORD VALIDATION ────────────────────────
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null; // Valid
  }

  // ─── NAME VALIDATION ────────────────────────────────────
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    return null; // Valid
  }

  // ─── TERMS CHECKBOX VALIDATION ──────────────────────────
  static String? validateTermsCheckbox(bool isChecked) {
    if (!isChecked) {
      return 'You must agree to the Terms of Service and Privacy Policy';
    }
    return null; // Valid
  }

  // ─── FIREBASE EXCEPTION MAPPING ────────────────────────
  /// Maps Firebase exceptions to user-friendly error messages
  static String mapFirebaseException(dynamic exception) {
    if (exception is FirebaseAuthException) {
      return _mapFirebaseAuthException(exception);
    }
    
    final String message = exception.toString();
    
    // Handle network errors
    if (message.contains('network') || message.contains('connection')) {
      return 'Network error. Please check your internet connection.';
    }
    
    // Default fallback
    return message.isNotEmpty 
        ? message 
        : 'An unexpected error occurred. Please try again.';
  }

  /// Maps specific Firebase Authentication error codes
  static String _mapFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      // Sign-Up specific errors
      case 'email-already-in-use':
        return 'This email is already registered. Please use a different email or sign in.';
      case 'invalid-email':
        return 'Invalid email address. Please check and try again.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters with a mix of letters and numbers.';
      case 'operation-not-allowed':
        return 'Account creation is currently disabled. Please try again later.';

      // Sign-In specific errors
      case 'user-not-found':
        return 'No account found with this email. Please create an account first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid email or password. Please try again.';

      // Common errors
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'account-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'requires-recent-login':
        return 'Your session has expired. Please sign in again.';

      // Network/Connection errors
      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';

      // Default
      default:
        return e.message ?? 'An authentication error occurred. Please try again.';
    }
  }

  /// Check if the password meets strength requirements
  static Map<String, bool> checkPasswordStrength(String password) {
    return {
      'isLongEnough': password.length >= 6,
      'hasUppercase': password.contains(RegExp(r'[A-Z]')),
      'hasLowercase': password.contains(RegExp(r'[a-z]')),
      'hasNumbers': password.contains(RegExp(r'[0-9]')),
      'hasSpecialChar': password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
    };
  }

  /// Format email for consistent validation (trim and lowercase)
  static String formatEmail(String email) {
    return email.trim().toLowerCase();
  }

  /// Check if all required fields are filled before enabling submit button
  static bool isFormValid({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required bool agreeToTerms,
    bool isSignUp = true,
  }) {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return false;
    }
    
    if (isSignUp && (confirmPassword.isEmpty || !agreeToTerms)) {
      return false;
    }
    
    return true;
  }
}
