import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
import 'package:template_flutter/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _auth = AuthService();
  bool _isLoading = false;

  bool _isCustomer = true;
  bool _agreeToTerms = false;

  Future<void> _signUp() async {
    setState(() => _isLoading = true);
    try {
      await _auth.signOut();
      await _auth.signUp(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        userType: _isCustomer ? 'customer' : 'contractor',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created! Check your email to verify.'),
          ),
        );
        NavigationService.navigateTo(Routes.loginScreen);
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
                CustomTextFormField(
                  label: 'Full Name',
                  labelStyle: TextFontStyle.textStyle15c0A0A0AInter400,
                  hintText: 'John Smith',
                  controller: _nameController,
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
                      )),
                ),
                UIHelper.verticalSpace(24.h),
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
                  hintText: 'Create a password',
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
                CustomTextFormField(
                  label: 'Confirm Password',
                  labelStyle: TextFontStyle.textStyle15c0A0A0AInter400,
                  hintText: 'Confirm your password',
                  controller: _confirmPasswordController,
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
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      _agreeToTerms = !_agreeToTerms;
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
                            });
                          },
                          activeColor: _isCustomer
                              ? AppColors.allPrimaryColor
                              : AppColors.contractor_primary,
                          side: const BorderSide(color: AppColors.c808080),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.5.r),
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
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
                                    : TextFontStyle.textStyle13cBE1E2DInter400
                                        .copyWith(
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
                                    : TextFontStyle.textStyle13cBE1E2DInter400
                                        .copyWith(
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
                ),
                UIHelper.verticalSpace(24.h),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        label: 'Create Account',
                        onPressed: _agreeToTerms ? _signUp : null,
                        height: 40.h,
                        borderRadius: 12.r,
                        color: _isCustomer
                            ? AppColors.allPrimaryColor
                            : AppColors.contractor_primary,
                        width: double.infinity,
                        textStyle: TextFontStyle.textStyle16cFFFFFFInter700,
                      ),
                UIHelper.verticalSpace(42.h),
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
                            onTap: () {
                              NavigationService.navigateTo(Routes.loginScreen);
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
          onTap: onTap,
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
