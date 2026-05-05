import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({super.key, required this.data, this.onTap});

  final MetricData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.scaffoldColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.c0A0A0A.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: AppColors.c0A0A0A.withValues(alpha: 0.05),
              blurRadius: 5.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: data.iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    data.icon,
                    size: 18.sp,
                    color: data.iconColor,
                  ),
                ),
                Spacer(),
                Image.asset(
                  'assets/icons/redirect.png',
                  width: 16.w,
                  height: 16.h,
                )
              ],
            ),
            UIHelper.verticalSpace(12.h),
            Text(
              data.value,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.c0A0A0A,
              ),
            ),
            UIHelper.verticalSpace(4.h),
            Text(
              data.title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.c14181F,
              ),
            ),
            UIHelper.verticalSpace(3.h),
            Text(
              data.subtitle,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.c6A7181,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MetricData {
  MetricData({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}