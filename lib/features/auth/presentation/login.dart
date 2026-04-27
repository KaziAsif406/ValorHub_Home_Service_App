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
import 'package:template_flutter/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
	const LoginScreen({super.key});

	@override
	State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
	final TextEditingController _emailController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();
  final _auth = AuthService();
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    try {
      final cred = await _auth.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Optional: block unverified users
      if (!cred.user!.emailVerified) {
        await _auth.signOut();
        throw 'Please verify your email before signing in.';
      }
      if (mounted) {
        await AppPrefs.setLoggedIn(true);
        final String profileName =
            cred.user?.displayName?.trim().isNotEmpty == true
                ? cred.user!.displayName!.trim()
                : _emailController.text.trim();
        final String profileEmail =
            cred.user?.email?.trim().isNotEmpty == true
                ? cred.user!.email!.trim()
                : _emailController.text.trim();

        NavigationService.navigateToReplacementWithArgs(
          Routes.navigationScreen,
          {
            'name': profileName,
            'email': profileEmail,
          },
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
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
                CustomTextFormField(
                  label: 'Email Address',
                  labelStyle: TextFontStyle.textStyle15c0A0A0AInter400,
                  hintText: 'your.email@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
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
                ),
                UIHelper.verticalSpace(24.h),
                CustomTextFormField(
                  label: 'Password',
                  labelStyle: TextFontStyle.textStyle15c0A0A0AInter400,
                  hintText: 'Enter your password',
                  controller: _passwordController,
                        obscureText: true,
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
                ),
                UIHelper.verticalSpace(24.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: 
                          TextButton.styleFrom(
                      minimumSize: Size(2.w, 2.h),
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                            NavigationService.navigateTo(Routes.forgotPWScreen);
                          },
                    child: Text(
                      'Forgot password?',
                      style: TextFontStyle.textStyle13cBE1E2DInter400,
                    ),
                  ),
                ),
                UIHelper.verticalSpace(24.h),
                      _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : CustomButton(
                  label: 'Sign In',
                  onPressed: _signIn,
                  height: 40.h,
                  borderRadius: 12.r,
                  width: double.infinity,
                  textStyle: TextFontStyle.textStyle16cFFFFFFInter700,
                ),
                UIHelper.verticalSpace(32.h),
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
                            onTap: () {
                              NavigationService.navigateTo(Routes.signUpScreen);
                            },
                            child: Text(
                              'Create account',
                              style: TextFontStyle.textStyle13cBE1E2DInter400.copyWith(
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
		);
	}
}
