import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class ResetPasswordInsideProfileScreen extends StatefulWidget {
	const ResetPasswordInsideProfileScreen({super.key});

	@override
	State<ResetPasswordInsideProfileScreen> createState() => _ResetPasswordInsideProfileScreenState();
}

class _ResetPasswordInsideProfileScreenState extends State<ResetPasswordInsideProfileScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

	@override
	void dispose() {
    _currentPasswordController.dispose();
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
        title: Text(
          'Change Password',
          style: TextFontStyle.textStyle18c14181FInter600,
        ),
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
					padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
					child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.scaffoldColor,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.c000000.withValues(alpha: 0.12),
                  blurRadius: 8.r,
                  offset: Offset(0, 3.h),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  label: 'Old Password',
                    labelStyle: TextFontStyle.textStyle15c0A0A0AInter400,
                    hintText: 'Password',
                    controller: _currentPasswordController,
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
                CustomButton(
                  label: 'Confirm',
                  onPressed: () {
                    NavigationService.navigateToReplacement(Routes.loginScreen);
                  },
                  height: 40.h,
                  borderRadius: 12.r,
                  width: double.infinity,
                  textStyle: TextFontStyle.textStyle16cFFFFFFInter700,
                ),
              ],
            ),
          ),
				),
			),
		);
	}
}
