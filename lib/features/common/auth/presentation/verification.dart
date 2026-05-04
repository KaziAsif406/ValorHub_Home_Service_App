import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
import 'widgets/otp_input_field.dart';

class VerificationCodeScreen extends StatefulWidget {
	const VerificationCodeScreen({super.key});

	@override
	State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
	@override
	void dispose() {
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
									'Verification Code',
									style: TextFontStyle.textStyle24c0A0A0AInter700.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
								),
							),
              UIHelper.verticalSpace(8.h),
              Center(
                child: Text(
                  'Please confirm the security code received on your registered number.',
                  style: TextFontStyle.textStyle14c64748BInter400,
                  textAlign: TextAlign.center,
                ),
              ),
							UIHelper.verticalSpace(26.h),
							OTPInputField(
								otpLength: 4,
								onCompleted: (otp) {
									// To Do - Handle OTP verification
									// print('OTP entered: $otp');
								},
							),
							UIHelper.verticalSpace(24.h),
							CustomButton(
								label: 'Verify',
								onPressed: () {
                  NavigationService.navigateTo(Routes.resetPassword);
                },
								height: 40.h,
								borderRadius: 12.r,
								width: double.infinity,
								textStyle: TextFontStyle.textStyle16cFFFFFFInter700,
							),
              UIHelper.verticalSpace(64.h),
              Center(
                child: Text(
                  'Didn\'t receive the code?',
                  style: TextFontStyle.textStyle14c64748BInter400,
                ),
              ),
              UIHelper.verticalSpace(8.h),
              Center(
                child: TextButton(
                  onPressed: () {
                    // To Do - Implement resend code functionality
                  },
                  child: Text(
                    'Send Again',
                    style: TextFontStyle.textStyle14cBE1E2DInter400,
                  ),
                ),
              ),
						],
					),
				),
			),
		);
	}
}
