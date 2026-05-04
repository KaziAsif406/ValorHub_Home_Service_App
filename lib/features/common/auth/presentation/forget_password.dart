import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class ForgetPasswordScreen extends StatefulWidget {
	const ForgetPasswordScreen({super.key});

	@override
	State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
	final TextEditingController _emailController = TextEditingController();

	@override
	void dispose() {
		_emailController.dispose();
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
          onPressed: () {
            NavigationService.goBack;
          },
        ),
      ),
			body: SafeArea(
				child: SingleChildScrollView(
					padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
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
									'Enter Email Address',
									style: TextFontStyle.textStyle24c0A0A0AInter700.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
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
							CustomButton(
								label: 'Continue',
								onPressed: () {
                  NavigationService.navigateTo(Routes.otpScreen);
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
		);
	}
}
