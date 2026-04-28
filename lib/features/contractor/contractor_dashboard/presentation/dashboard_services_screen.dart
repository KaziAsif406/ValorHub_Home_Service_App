import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class DashboardServicesSection extends StatelessWidget {
  const DashboardServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_ServiceData> services = <_ServiceData>[
      _ServiceData(
          'Kitchen Remodeling', '12 active requests', Icons.kitchen_outlined),
      _ServiceData(
          'Bathroom Plumbing', '8 active requests', Icons.plumbing_outlined),
      _ServiceData('Electrical Repair', '6 active requests',
          Icons.electrical_services_outlined),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My services',
            style: TextFontStyle.textStyle20c0A0A0AInter700.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          UIHelper.verticalSpace(6.h),
          Text(
            'Manage the services your customers request most often.',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.c6A7181,
            ),
          ),
          UIHelper.verticalSpace(16.h),
          ...services.map(
            (_ServiceData service) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: AppColors.c0A0A0A),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor:
                          AppColors.contractor_primary.withValues(alpha: 0.12),
                      child: Icon(
                        service.icon,
                        color: AppColors.contractor_primary,
                        size: 20.sp,
                      ),
                    ),
                    UIHelper.horizontalSpace(12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.title,
                            style: TextFontStyle.textStyle15c0A0A0AInter700,
                          ),
                          UIHelper.verticalSpace(4.h),
                          Text(
                            service.subtitle,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.c6A7181,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppColors.c6A7181),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceData {
  _ServiceData(this.title, this.subtitle, this.icon);

  final String title;
  final String subtitle;
  final IconData icon;
}
