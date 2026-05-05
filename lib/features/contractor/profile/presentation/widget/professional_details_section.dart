import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class ProfessionalDetailsSection extends StatelessWidget {
  const ProfessionalDetailsSection({
    super.key,
    required this.licenseNumber,
    required this.yearsOfExperience,
    required this.completedProjects,
  });

  final String licenseNumber;
  final int yearsOfExperience;
  final int completedProjects;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.c636363.withValues(alpha: 0.21),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Professional Details',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.c0A0A0A,
            ),
          ),
          UIHelper.verticalSpace(14.h),
          _DetailItem(
            icon: Icons.card_membership_outlined,
            label: 'License Number',
            value: licenseNumber,
          ),
          UIHelper.verticalSpace(14.h),
          _DetailItem(
            icon: Icons.calendar_month_outlined,
            label: 'Years of Experience',
            value: '$yearsOfExperience Years',
          ),
          UIHelper.verticalSpace(14.h),
          _DetailItem(
            icon: Icons.business_center_outlined,
            label: 'Completed Projects',
            value: '$completedProjects Projects',
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppColors.c21C45D.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 18.sp,
            color: AppColors.c21C45D,
          ),
        ),
        UIHelper.horizontalSpace(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.c6A7181,
                ),
              ),
              UIHelper.verticalSpace(4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.c0A0A0A,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
