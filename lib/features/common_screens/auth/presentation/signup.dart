import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/app_preferences.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
import 'package:template_flutter/constants/app_constants.dart';
import 'package:template_flutter/services/auth_service.dart';
import 'package:template_flutter/helpers/auth_validation_helper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _auth = AuthService();
  bool _isLoading = false;
  String? _termsError;

  bool _isCustomer = true;
  bool _agreeToTerms = false;

  Future<void> _signUp() async {
    // Clear terms error when attempting submit
    setState(() => _termsError = null);

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate terms checkbox
    if (!_agreeToTerms) {
      setState(() {
        _termsError = AuthValidationHelper.validateTermsCheckbox(false);
      });
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _auth.signOut();
      await _auth.signUp(
        name: _nameController.text.trim(),
        email: AuthValidationHelper.formatEmail(_emailController.text),
        password: _passwordController.text,
        userType: _isCustomer ? kUserTypeCustomer : kUserTypeContractor,
      );
      if (mounted) {
        if (_isCustomer) {
          NavigationService.navigateToReplacementWithArgs(
            Routes.loginScreen,
            <String, dynamic>{
              'message': 'Account created! Check your email to verify.',
            },
          );
        } else {
          NavigationService.navigateToReplacementWithArgs(
            Routes.basicInfoScreen,
            <String, dynamic>{
              'name': _nameController.text.trim(),
              'email': AuthValidationHelper.formatEmail(_emailController.text),
            },
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      final String errorMessage = AuthValidationHelper.mapFirebaseException(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppColors.c14181F,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signUpWithGoogle() async {
    setState(() => _termsError = null);
    setState(() => _isLoading = true);
    try {
      final cred = await _auth.signInWithGoogle();
      final user = cred.user;
      if (user == null) {
        throw 'Unable to sign in with Google.';
      }

      final profile = await _auth.getUserProfileByUserId(user.uid);
      final String profileName = (profile?['displayName'] as String?)
                  ?.trim()
                  .isNotEmpty ==
              true
          ? (profile?['displayName'] as String).trim()
          : (user.displayName?.trim().isNotEmpty == true
              ? user.displayName!.trim()
              : user.email?.trim() ?? 'User');
      final String profileEmail = user.email?.trim().isNotEmpty == true
          ? user.email!.trim()
          : 'user@example.com';

      String userType = (profile?[kKeyUserType] as String? ?? '')
          .trim()
          .toLowerCase();
      bool profileCompleted = (profile?[kKeyProfileCompleted] as bool?) == true;

      // Track whether we created a new profile for this Google account
      bool createdNewAccount = false;
      if (userType != kUserTypeCustomer && userType != kUserTypeContractor) {
        userType = _isCustomer ? kUserTypeCustomer : kUserTypeContractor;
        profileCompleted = userType == kUserTypeCustomer;
        await _auth.saveGoogleUserProfile(
          userId: user.uid,
          email: profileEmail,
          name: profileName,
          userType: userType,
          profileCompleted: profileCompleted,
        );
        createdNewAccount = true;
      }

      // If this was a newly-created Google account, show a confirmation dialog
      if (createdNewAccount && mounted) {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('Account created'),
            content: const Text('Your account was successfully created.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: kUserTypeCustomer == userType
                    ? const Text('Go to Home')
                    : const Text('Complete Profile'),
              ),
            ],
          ),
        );
      }

      await AppPrefs.setLoggedIn(true);
      final Map<String, dynamic> routeArgs = {
        'name': profileName,
        'email': profileEmail,
        kKeyUserType: userType,
      };

      if (userType == kUserTypeContractor && !profileCompleted) {
        if (mounted) {
          NavigationService.navigateToReplacementWithArgs(
            Routes.basicInfoScreen,
            routeArgs,
          );
        }
        return;
      }

      if (mounted) {
        if (userType == kUserTypeContractor) {
          NavigationService.navigateToReplacementWithArgs(
            Routes.contractorDashboardScreen,
            routeArgs,
          );
        } else {
          NavigationService.navigateToReplacementWithArgs(
            Routes.navigationScreen,
            routeArgs,
          );
        }
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      final String message = e.toString();
      if (message.contains('cancelled')) {
        return;
      }
      final String errorMessage = AuthValidationHelper.mapFirebaseException(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppColors.c14181F,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UIHelper.verticalSpace(36.h),
                  Center(
                    child: Image.asset(
                      'assets/icons/logo.png',
                      width: 126.w,
                      height: 82.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  UIHelper.verticalSpace(32.h),
                  Center(
                    child: Text(
                      'Create Account',
                      style: TextFontStyle.textStyle24c0A0A0AInter700.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  UIHelper.verticalSpace(8.h),
                  Center(
                    child: Text(
                      'Join our platform to get started',
                      style: TextFontStyle.textStyle14c64748BInter400,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  UIHelper.verticalSpace(24.h),
                  // Account Type Selection
                  Row(
                    children: [
                      Expanded(
                        child: _buildAccountTypeButton(
                          label: 'Customer',
                          selected: _isCustomer,
                          onTap: () {
                            setState(() {
                              _isCustomer = true;
                            });
                          },
                        ),
                      ),
                      UIHelper.horizontalSpace(16.w),
                      Expanded(
                        child: _buildAccountTypeButton(
                          label: 'Contractor',
                          selected: !_isCustomer,
                          onTap: () {
                            setState(() {
                              _isCustomer = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(48.h),
                  // Full Name Field
                  CustomTextFormField(
                    controller: _nameController,
                    label: 'Full Name',
                    labelStyle: TextFontStyle.textStyle15c0A0A0AInter400,
                    hintText: 'John Smith',
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    errorMaxLines: 2,
                    isDense: true,
                    borderRadius: 12,
                    enabledBorderColor: AppColors.cE8E8E8,
                    focusedBorderColor: _isCustomer
                        ? AppColors.allPrimaryColor
                        : AppColors.contractor_primary,
                    errorBorderColor: AppColors.c14181F,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Image.asset(
                        'assets/icons/profile.png',
                        width: 20.w,
                        height: 20.h,
                      ),
                    ),
                    validator: AuthValidationHelper.validateName,
                    showLabelAboveField: false,
                  ),
                  UIHelper.verticalSpace(24.h),
                  // Email Field
                  CustomTextFormField(
                    controller: _emailController,
                    label: 'Email Address',
                    labelStyle: TextFontStyle.textStyle15c0A0A0AInter400,
                    hintText: 'your.email@example.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    errorMaxLines: 2,
                    isDense: true,
                    borderRadius: 12,
                    enabledBorderColor: AppColors.cE8E8E8,
                    focusedBorderColor: _isCustomer
                        ? AppColors.allPrimaryColor
                        : AppColors.contractor_primary,
                    errorBorderColor: AppColors.c14181F,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Image.asset(
                        'assets/icons/mail.png',
                        width: 20.w,
                        height: 20.h,
                      ),
                    ),
                    validator: AuthValidationHelper.validateEmail,
                    showLabelAboveField: false,
                  ),
                  UIHelper.verticalSpace(24.h),
                  // Password Field
                  CustomTextFormField(
                    controller: _passwordController,
                    label: 'Password',
                    labelStyle: TextFontStyle.textStyle15c0A0A0AInter400,
                    hintText: 'Create a password',
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (_) {
                      // Trigger re-validation of confirm password when password changes
                      _formKey.currentState?.validate();
                    },
                    textInputAction: TextInputAction.next,
                    errorMaxLines: 2,
                    isDense: true,
                    borderRadius: 12,
                    enabledBorderColor: AppColors.cE8E8E8,
                    focusedBorderColor: _isCustomer
                        ? AppColors.allPrimaryColor
                        : AppColors.contractor_primary,
                    errorBorderColor: AppColors.c14181F,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Image.asset(
                        'assets/icons/lock.png',
                        width: 20.w,
                        height: 20.h,
                      ),
                    ),
                    validator: AuthValidationHelper.validatePassword,
                    showLabelAboveField: false,
                  ),
                  UIHelper.verticalSpace(24.h),
                  // Confirm Password Field
                  CustomTextFormField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    labelStyle: TextFontStyle.textStyle15c0A0A0AInter400,
                    hintText: 'Confirm your password',
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    errorMaxLines: 2,
                    isDense: true,
                    borderRadius: 12,
                    enabledBorderColor: AppColors.cE8E8E8,
                    focusedBorderColor: _isCustomer
                        ? AppColors.allPrimaryColor
                        : AppColors.contractor_primary,
                    errorBorderColor: AppColors.c14181F,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Image.asset(
                        'assets/icons/lock.png',
                        width: 20.w,
                        height: 20.h,
                      ),
                    ),
                    validator: (value) => AuthValidationHelper.validateConfirmPassword(
                      value,
                      _passwordController.text,
                    ),
                    showLabelAboveField: false,
                  ),
                  UIHelper.verticalSpace(24.h),
                  // Terms & Conditions Checkbox
                  _buildTermsCheckbox(),
                  if (_termsError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        _termsError!,
                        style: TextFontStyle.textStyle13c64748BInter400.copyWith(
                          color: AppColors.c14181F,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  UIHelper.verticalSpace(24.h),
                  // Sign Up Button
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _isCustomer
                                  ? AppColors.allPrimaryColor
                                  : AppColors.contractor_primary,
                            ),
                          ),
                        )
                        : CustomButton(
                          label: 'Create Account',
                          onPressed: _isLoading ? null : _signUp,
                          height: 40.h,
                          borderRadius: 12.r,
                          color: _isCustomer
                              ? AppColors.allPrimaryColor
                              : AppColors.contractor_primary,
                          width: double.infinity,
                          textStyle: TextFontStyle.textStyle16cFFFFFFInter700,
                        ),
                  UIHelper.verticalSpace(16.h),
                  Row(
                    children: [
                      UIHelper.horizontalSpace(24.w),
                      Expanded(
                        child: Divider(
                          color: AppColors.c808080.withValues(alpha: 0.32),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          'Or',
                          style: TextFontStyle.textStyle14c64748BInter400,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.c808080.withValues(alpha: 0.32),
                          thickness: 1,
                        ),
                      ),
                      UIHelper.horizontalSpace(24.w),
                    ],
                  ),
                  UIHelper.verticalSpace(5.h),
                  // Google Sign-Up Button
                  CustomButton(
                    label: 'Sign up with Google',
                    onPressed: _isLoading ? null : _signUpWithGoogle,
                    height: 40.h,
                    borderRadius: 12.r,
                    width: double.infinity,
                    isOutlined: true,
                    borderColor:
                        AppColors.scaffoldColor.withValues(alpha: 0.0),
                    leading: Image.asset(
                      'assets/icons/google.png',
                      width: 25.w,
                      height: 25.h,
                    ),
                    textStyle: TextStyle(
                      color: AppColors.c14181F,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  UIHelper.verticalSpace(42.h),
                  // Sign In Link
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Already have an account? ',
                            style: TextFontStyle.textStyle13c64748BInter400,
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: _isLoading
                                  ? null
                                  : () {
                                      NavigationService.navigateTo(
                                          Routes.loginScreen);
                                    },
                              child: Text(
                                'Sign in',
                                style: _isCustomer
                                    ? TextFontStyle.textStyle13cBE1E2DInter400
                                    : TextFontStyle.textStyle13cBE1E2DInter400
                                        .copyWith(
                                        color: AppColors.contractor_primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  UIHelper.verticalSpace(20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build terms & conditions checkbox with error state
  Widget _buildTermsCheckbox() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _agreeToTerms = !_agreeToTerms;
          _termsError = null; // Clear error on interaction
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 24.w,
            height: 24.h,
            child: Checkbox(
              value: _agreeToTerms,
              onChanged: (value) {
                setState(() {
                  _agreeToTerms = value ?? false;
                  _termsError = null; // Clear error on interaction
                });
              },
              activeColor: _isCustomer
                  ? AppColors.allPrimaryColor
                  : AppColors.contractor_primary,
              side: BorderSide(
                color: _termsError != null
                    ? AppColors.c14181F
                    : AppColors.c808080,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.5.r),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          UIHelper.horizontalSpace(8.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'I agree to the ',
                    style: TextFontStyle.textStyle13c64748BInter400,
                  ),
                  TextSpan(
                    text: 'Terms of Service',
                    style: _isCustomer
                        ? TextFontStyle.textStyle13cBE1E2DInter400
                        : TextFontStyle.textStyle13cBE1E2DInter400.copyWith(
                            color: AppColors.contractor_primary,
                            fontWeight: FontWeight.w600,
                          ),
                  ),
                  TextSpan(
                    text: ' and ',
                    style: TextFontStyle.textStyle13c64748BInter400,
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: _isCustomer
                        ? TextFontStyle.textStyle13cBE1E2DInter400
                        : TextFontStyle.textStyle13cBE1E2DInter400.copyWith(
                            color: AppColors.contractor_primary,
                            fontWeight: FontWeight.w600,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTypeButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 46.h,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: _isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Ink(
            decoration: BoxDecoration(
              color: _isCustomer
                  ? selected
                      ? AppColors.allPrimaryColor
                      : AppColors.cF8FAFC
                  : selected
                      ? AppColors.contractor_primary
                      : AppColors.cF8FAFC,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                label,
                style: selected
                    ? TextFontStyle.textStyle15cFFFFFFInter700
                    : TextFontStyle.textStyle15c0A0A0AInter700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
