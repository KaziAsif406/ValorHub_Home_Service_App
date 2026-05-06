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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _auth = AuthService();
  bool _isLoading = false;
  bool _didShowRouteMessage = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didShowRouteMessage) {
      return;
    }

    final Object? arguments = ModalRoute.of(context)?.settings.arguments;
    final String? message = arguments is Map<String, dynamic>
        ? arguments['message'] as String?
        : null;

    if (message != null && message.trim().isNotEmpty) {
      _didShowRouteMessage = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      });
    }
  }

  Future<void> _signIn() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      final cred = await _auth.signIn(
        email: AuthValidationHelper.formatEmail(_emailController.text),
        password: _passwordController.text,
      );
      
      // Block unverified users
      if (!cred.user!.emailVerified) {
        await _auth.signOut();
        throw 'Please verify your email before signing in.';
      }
      
      if (mounted) {
        final String profileName = cred.user?.displayName?.trim().isNotEmpty == true
            ? cred.user!.displayName!.trim()
            : _emailController.text.trim();
        final String profileEmail = cred.user?.email?.trim().isNotEmpty == true
            ? cred.user!.email!.trim()
            : _emailController.text.trim();
        final String userType = await _auth.getUserTypeByUserId(cred.user!.uid);
        await AppPrefs.setLoggedIn(true);

        final Map<String, dynamic> routeArgs = {
          'name': profileName,
          'email': profileEmail,
          kKeyUserType: userType,
        };

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

  Future<String?> _promptGoogleUserType() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Choose account type'),
          content: const Text(
            'Select how you want to use this Google account.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(kUserTypeCustomer),
              child: const Text('Customer'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(kUserTypeContractor),
              child: const Text('Contractor'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signInWithGoogle() async {
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

      if (userType != kUserTypeCustomer && userType != kUserTypeContractor) {
        final String? selectedType = await _promptGoogleUserType();
        if (selectedType == null) {
          await _auth.signOut();
          return;
        }

        userType = selectedType;
        profileCompleted = userType == kUserTypeCustomer;
        await _auth.saveGoogleUserProfile(
          userId: user.uid,
          email: profileEmail,
          name: profileName,
          userType: userType,
          profileCompleted: profileCompleted,
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
    _emailController.dispose();
    _passwordController.dispose();
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 54.h),
                  Center(
                    child: Image.asset(
                      'assets/icons/logo.png',
                      width: 126.w,
                      height: 82.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  UIHelper.verticalSpace(16.h),
                  Center(
                    child: Text(
                      'Welcome Back',
                      style: TextFontStyle.textStyle24c0A0A0AInter700.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  UIHelper.verticalSpace(8.h),
                  Center(
                    child: Text(
                      'Sign in to your account to continue',
                      style: TextFontStyle.textStyle14c64748BInter400,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  UIHelper.verticalSpace(40.h),
                  // Email Field
                  CustomTextFormField(
                    controller: _emailController,
                    label: 'Email Address',
                    labelStyle: TextFontStyle.textStyle15c0A0A0AInter400,
                    hintText: 'your.email@example.com',
                    keyboardType: TextInputType.emailAddress,
                    enabled: !_isLoading,
                    textInputAction: TextInputAction.next,
                    errorMaxLines: 2,
                    isDense: true,
                    borderRadius: 12,
                    enabledBorderColor: AppColors.cE8E8E8,
                    focusedBorderColor: AppColors.allPrimaryColor,
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
                    hintText: 'Enter your password',
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    enabled: !_isLoading,
                    textInputAction: TextInputAction.done,
                    errorMaxLines: 2,
                    isDense: true,
                    borderRadius: 12,
                    enabledBorderColor: AppColors.cE8E8E8,
                    focusedBorderColor: AppColors.allPrimaryColor,
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
                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size(2.w, 2.h),
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: _isLoading
                          ? null
                          : () {
                              NavigationService.navigateTo(Routes.forgotPWScreen);
                            },
                      child: Text(
                        'Forgot password?',
                        style: TextFontStyle.textStyle13cBE1E2DInter400,
                      ),
                    ),
                  ),
                  UIHelper.verticalSpace(24.h),
                  // Sign In Button
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.allPrimaryColor,
                            ),
                          ),
                        )
                      : CustomButton(
                          label: 'Sign In',
                          onPressed: _isLoading ? null : _signIn,
                          height: 40.h,
                          borderRadius: 12.r,
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
                  // Google Sign-In Button
                  CustomButton(
                    label: 'Continue with Google',
                    onPressed: _isLoading ? null : _signInWithGoogle,
                    height: 40.h,
                    borderRadius: 12.r,
                    width: double.infinity,
                    isOutlined: true,
                    borderColor: AppColors.scaffoldColor.withValues(alpha: 0.0),
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
                  UIHelper.verticalSpace(32.h),
                  // Sign Up Link
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Don\'t have an account? ',
                            style: TextFontStyle.textStyle13c64748BInter400,
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: _isLoading
                                  ? null
                                  : () {
                                      NavigationService.navigateTo(
                                          Routes.signUpScreen);
                                    },
                              child: Text(
                                'Create account',
                                style: TextFontStyle.textStyle13cBE1E2DInter400
                                    .copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  UIHelper.verticalSpace(28.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
