import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/constants/text_font_style.dart';
import '/gen/colors.gen.dart';



class AnalyticsCard extends StatelessWidget {
  const AnalyticsCard({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.c14181F.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: AppColors.c000000.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextFontStyle.textStyle10c6A7181Inter500,
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextFontStyle.textStyle24c0A0A0AInter700,
          ),
        ],
      ),
    );
  }
}