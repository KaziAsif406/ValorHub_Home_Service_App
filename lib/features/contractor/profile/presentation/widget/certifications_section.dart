import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class CertificationsSection extends StatelessWidget {
  const CertificationsSection({
    super.key,
    required this.certifications,
  });

  final List<String> certifications;

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
            'Certifications & Insurance',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.c0A0A0A,
            ),
          ),
          UIHelper.verticalSpace(14.h),
          Column(
            children: List.generate(
              certifications.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                    bottom: index != certifications.length - 1 ? 12.h : 0),
                child: _CertificationItem(
                  title: certifications[index],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CertificationItem extends StatelessWidget {
  const _CertificationItem({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            color: const Color(0xFF10B981),
            shape: BoxShape.circle,
          ),
        ),
        UIHelper.horizontalSpace(12.w),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.c0A0A0A,
            ),
          ),
        ),
      ],
    );
  }
}
