import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class ContactInformationSection extends StatelessWidget {
  const ContactInformationSection({
    super.key,
    required this.phone,
    required this.email,
    required this.serviceArea,
  });

  final String phone;
  final String email;
  final String serviceArea;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
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
            'Contact Information',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.c0A0A0A,
            ),
          ),
          UIHelper.verticalSpace(14.h),
          _ContactItem(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: phone,
          ),
          UIHelper.verticalSpace(14.h),
          _ContactItem(
            icon: Icons.email_outlined,
            label: 'Email',
            value: email,
          ),
          UIHelper.verticalSpace(14.h),
          _ContactItem(
            icon: Icons.location_on_outlined,
            label: 'Service Area',
            value: serviceArea,
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  const _ContactItem({
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
            gradient: LinearGradient(
              colors: [
                AppColors.contractor_primary.withValues(alpha: 0.11),
                AppColors.contractor_secondary.withValues(alpha: 0.21),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 18.sp,
            color: AppColors.contractor_primary,
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
