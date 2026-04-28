import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';


class QuoteSent extends StatelessWidget {
  const QuoteSent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Container(
            height: 550.h,
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.allSecondaryColor,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10.r,
                  offset: Offset(0, 1.h),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image.asset('assets/images/quote_sent.png', width: 200.w, height: 200.h),
                // UIHelper.verticalSpace(24.h),
                Center(
                  child: Container(
                    width: 64.w,
                    height: 64.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.c21C45D.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/icons/green_tick.png', 
                      width: 32.w, 
                      height: 32.h
                    ),
                  ),
                ),
                UIHelper.verticalSpace(20.h),
                Center(
                  child: Text(
                    'Quote Request Sent!',
                    style: TextFontStyle.textStyle20c14181FInter700,
                  ),
                ),
                UIHelper.verticalSpace(8.h),
                Center(
                  child: Text(
                    'Your request has been submitted successfully',
                    style: TextFontStyle.textStyle14c6A7181Inter400,
                    textAlign: TextAlign.center,
                  ),
                ),
                UIHelper.verticalSpace(28.h),
                Container(
                  width: double.infinity,
                  height: 68.h,
                  padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: AppColors.cF3F4F6.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '⏱ Expected response within 24 hours',
                        style: TextFontStyle.textStyle12c6A7181Inter500,
                        textAlign: TextAlign.center,
                      ),
                      UIHelper.verticalSpace(4.h),
                      Text(
                        '📧 Confirmation sent to your email',
                        style: TextFontStyle.textStyle12c6A7181Inter500,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                UIHelper.verticalSpace(8.h),
                Text(
                  'What Happens Next',
                  style: TextFontStyle.textStyle14c14181FInter600,
                ),
                UIHelper.verticalSpace(12.h),
                Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.allPrimaryColor.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: 
                    Image.asset('assets/icons/clipboard.png', width: 16.w, height: 16.h),
                    ),
                    UIHelper.horizontalSpace(16.w),
                    Expanded(
                      child: Text(
                        'The contractor will review your request and project details',
                        style: TextFontStyle.textStyle12c6A7181Inter400,
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(12.h),
                Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.allPrimaryColor.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset('assets/icons/mail_red.png', width: 16.w, height: 16.h),
                    ),
                    UIHelper.horizontalSpace(16.w),
                    Expanded(
                      child: Text(
                        'You\'ll receive a personalized quote via email',
                        style: TextFontStyle.textStyle12c6A7181Inter400,
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(12.h),
                Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.allPrimaryColor.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset('assets/icons/clock_red.png', width: 16.w, height: 16.h),
                    ),
                    UIHelper.horizontalSpace(16.w),
                    Expanded(
                      child: Text(
                        'Review the quote and schedule your project',
                        style: TextFontStyle.textStyle12c6A7181Inter400,
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(28.h),
                CustomButton(
                  width: double.infinity,
                  height: 34.h,
                  label: 'Go To Home',
                  onPressed: () {
                    NavigationService.navigateToReplacement(Routes.navigationScreen);
                  },
                ),
                UIHelper.verticalSpace(8.h),
                CustomButton(
                  width: double.infinity,
                  height: 34.h,
                  label: 'View Dashboard',
                  onPressed: () {
                    // Not defined yet, so just navigate to home for now
                    NavigationService.navigateToReplacement(Routes.navigationScreen);
                  },
                  isOutlined: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}