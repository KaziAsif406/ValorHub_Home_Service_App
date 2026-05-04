import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
import 'common_widgets/custom_button.dart';
import 'gen/colors.gen.dart';
import 'helpers/all_routes.dart';

final class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UIHelper.verticalSpace(60.h),
              Text(
                'Best Helping\nHands for you',
                textAlign: TextAlign.center,
                style: TextFontStyle.textStyle30c282828Inter700,
              ),
              UIHelper.verticalSpace(16.h),
              Text(
                'With Our On-Demand Services App,\nWe Give Better Services To You.',
                textAlign: TextAlign.center,
                style: TextFontStyle.textStyle13c282828Inter500,
              ),
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/welcome_image.png',
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ),
              UIHelper.verticalSpace(24.h),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  label: 'Gets Started',
                  textStyle: TextFontStyle.textStyle16cFFFFFFInter600,
                  onPressed: () {
                    NavigationService.navigateToReplacement(Routes.onboardingFlow);
                  },
                  height: 42.h,
                  borderRadius: 12.r,
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
