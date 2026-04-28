import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class DashboardInboxSection extends StatelessWidget {
  const DashboardInboxSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _PlaceholderSection(
      title: 'Inbox',
      subtitle:
          'Recent customer conversations and unread messages will appear here.',
      icon: Icons.inbox_outlined,
    );
  }
}

class _PlaceholderSection extends StatelessWidget {
  const _PlaceholderSection({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: AppColors.c09090B),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28.r,
              backgroundColor:
                  AppColors.contractor_primary.withValues(alpha: 0.12),
              child: Icon(
                icon,
                color: AppColors.contractor_primary,
                size: 30.sp,
              ),
            ),
            UIHelper.verticalSpace(14.h),
            Text(
              title,
              style: TextFontStyle.textStyle18c0A0A0AInter700,
            ),
            UIHelper.verticalSpace(8.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.c6A7181,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
