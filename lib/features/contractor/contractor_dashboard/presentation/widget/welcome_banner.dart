import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({
    super.key,
    required this.profileName,
    required this.profileEmail,
  });

  final String profileName;
  final String profileEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.contractor_primary, Color(0xFF5D44FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WELCOME BACK',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          UIHelper.verticalSpace(8.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Good morning, $profileName ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: '👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          UIHelper.verticalSpace(4.h),
          Text(
            profileEmail,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.76),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          UIHelper.verticalSpace(10.h),
          Text(
            'You have 2 new quote requests and 3 unread messages waiting for your attention.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 14.sp,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
          UIHelper.verticalSpace(14.h),
          SizedBox(
            width: 182.w,
            child: CustomButton(
              label: 'View Requests',
              onPressed: () {},
              height: 46.h,
              borderRadius: 14.r,
              color: Colors.white,
              textStyle: TextStyle(
                color: AppColors.contractor_primary,
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
