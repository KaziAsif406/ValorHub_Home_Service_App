import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../gen/colors.gen.dart';

Widget socialLoginButton({
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return Container(
    width: 60.w,
    height: 60.h,
    decoration: BoxDecoration(
      color: AppColors.scaffoldColor,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: AppColors.cE8E8E8),
      boxShadow: [
        BoxShadow(
          color: AppColors.c000000.withValues(alpha: 0.05),
          blurRadius: 8.r,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onPressed,
        child: Icon(
          icon,
          size: 24.sp,
          color: AppColors.c000000,
        ),
      ),
    ),
  );
}
