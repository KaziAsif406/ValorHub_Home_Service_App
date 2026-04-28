import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class DashboardProfileSection extends StatelessWidget {
  const DashboardProfileSection({
    super.key,
    required this.profileName,
    required this.profileEmail,
    required this.onSignOut,
  });

  final String profileName;
  final String profileEmail;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile',
            style: TextFontStyle.textStyle20c0A0A0AInter700.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          UIHelper.verticalSpace(14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.c0A0A0A),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28.r,
                  backgroundColor:
                      AppColors.contractor_primary.withValues(alpha: 0.12),
                  child: Text(
                    _initials(profileName),
                    style: TextStyle(
                      color: AppColors.contractor_primary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                UIHelper.verticalSpace(14.h),
                Text(
                  profileName,
                  style: TextFontStyle.textStyle18c0A0A0AInter700,
                ),
                UIHelper.verticalSpace(4.h),
                Text(
                  profileEmail,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.c6A7181,
                  ),
                ),
                UIHelper.verticalSpace(18.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: 'Edit profile',
                        onPressed: () {},
                        height: 42.h,
                        borderRadius: 12.r,
                        color: AppColors.contractor_primary,
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    UIHelper.horizontalSpace(10.w),
                    Expanded(
                      child: CustomButton(
                        label: 'Sign out',
                        onPressed: onSignOut,
                        height: 42.h,
                        borderRadius: 12.r,
                        color: Colors.white,
                        isOutlined: true,
                        borderColor: AppColors.contractor_primary,
                        textStyle: TextStyle(
                          color: AppColors.contractor_primary,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String value) {
    final List<String> words = value
        .trim()
        .split(' ')
        .where((String part) => part.isNotEmpty)
        .toList();

    if (words.isEmpty) {
      return 'VH';
    }

    if (words.length == 1) {
      return words.first.characters.first.toUpperCase();
    }

    return (words.first.characters.first + words.last.characters.first)
        .toUpperCase();
  }
}
