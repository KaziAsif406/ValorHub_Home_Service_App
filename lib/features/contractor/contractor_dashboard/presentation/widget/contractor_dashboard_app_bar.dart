import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class ContractorDashboardAppBar extends StatelessWidget {
  const ContractorDashboardAppBar({
    super.key,
    required this.profileName,
    required this.onMenuPressed,
    required this.onInboxPressed,
  });

  final String profileName;
  final VoidCallback onMenuPressed;
  final VoidCallback onInboxPressed;

  @override
  Widget build(BuildContext context) {
    final String initials = _initials(profileName);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.c0A0A0A.withValues(alpha: 0.06),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onMenuPressed,
            icon: const Icon(Icons.menu_rounded, color: AppColors.c0A0A0A),
          ),
          Container(
            padding: EdgeInsets.all(7.w),
            decoration: BoxDecoration(
              color: AppColors.contractor_primary,
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Text(
              'VH',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          UIHelper.horizontalSpace(10.w),
          Expanded(
            child: Text(
              'VALOR HUB',
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.c0A0A0A,
                letterSpacing: 0.2,
              ),
            ),
          ),
          IconButton(
            onPressed: onInboxPressed,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded,
                    color: AppColors.c0A0A0A),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 34.w,
            height: 34.w,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.cF1F5F9,
              shape: BoxShape.circle,
            ),
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.contractor_primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String value) {
    final List<String> words = value
        .trim()
        .split(' ')
        .where((String part) => part.isNotEmpty)
        .toList();

    if (words.isEmpty) {
      return 'VH';
    }

    if (words.length == 1) {
      return words.first.characters.first.toUpperCase();
    }

    return (words.first.characters.first + words.last.characters.first)
        .toUpperCase();
  }
}
