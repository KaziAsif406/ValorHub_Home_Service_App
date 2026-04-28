import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class ProfileActionRow extends StatelessWidget {
  const ProfileActionRow({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
    required this.iconColor,
    required this.textColor,
  });

  final String title;
  final String imagePath;
  final VoidCallback onTap;
  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 24.sp,
              height: 24.sp,
            ),
            UIHelper.horizontalSpace(16.w),
            Expanded(
              child: Text(
                title,
                style: TextFontStyle.textStyle14c14181FInter400.copyWith(
                  color: textColor,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 24.sp,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}