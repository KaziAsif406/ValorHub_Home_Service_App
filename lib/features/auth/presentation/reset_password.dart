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

class ResetPasswordScreen extends StatefulWidget {
	const ResetPasswordScreen({super.key});

	@override
	State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
	final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _auth = AuthService();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }
    setState(() => _isLoading = true);
    final oobCode = ModalRoute.of(context)!.settings.arguments as String;
    try {
      await _auth.confirmPasswordReset(
        oobCode: oobCode,
        newPassword: _passwordController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successful! Please sign in.')),
        );
        NavigationService.navigateToUntilReplacement(Routes.loginScreen);
        // Navigator.pushNamedAndRemoveUntil(context, '/signin', (_) => false);
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
    _confirmPasswordController.dispose();
		_passwordController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 20.sp,
            color: AppColors.c14181F,
          ),
          onPressed: () => NavigationService.goBack,
        ),
      ),
			body: SafeArea(
				child: SingleChildScrollView(
					padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
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
									'Reset Password',
									style: TextFontStyle.textStyle24c0A0A0AInter700.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
								),
							),
							UIHelper.verticalSpace(40.h),
							CustomTextFormField(
								label: 'New Password',
								labelStyle: TextFontStyle.textStyle15c0A0A0AInter400,
								hintText: 'Password',
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
								label: 'Confirm New Password',
								labelStyle: TextFontStyle.textStyle15c0A0A0AInter400,
								hintText: 'Confirm password',
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
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
								label: 'Confirm',
								onPressed: _resetPassword,
								height: 40.h,
								borderRadius: 12.r,
								width: double.infinity,
								textStyle: TextFontStyle.textStyle16cFFFFFFInter700,
							),
						],
					),
				),
			),
		);
	}
}
