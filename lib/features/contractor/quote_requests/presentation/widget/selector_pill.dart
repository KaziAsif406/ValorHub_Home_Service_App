import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/gen/colors.gen.dart';

class QuoteSelectorPill extends StatelessWidget {
  const QuoteSelectorPill({
    super.key,
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.allPrimaryColor.withValues(alpha: 0.00),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.contractor_primary
                : AppColors.scaffoldColor,
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(
              color: selected
                  ? AppColors.contractor_primary.withValues(alpha: 0.00)
                  : AppColors.c0A0A0A.withValues(alpha: 0.12),
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: selected
            //         ? AppColors.contractor_primary.withValues(alpha: 0.20)
            //         : AppColors.c0A0A0A.withValues(alpha: 0.05),
            //     blurRadius: 14.r,
            //     offset: Offset(0, 6.h),
            //   ),
            // ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: selected ? AppColors.scaffoldColor : AppColors.contractor_primary,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.scaffoldColor.withValues(alpha: 0.28)
                      : AppColors.contractor_primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: selected
                        ? AppColors.scaffoldColor
                        : AppColors.contractor_primary,
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
