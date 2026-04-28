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
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: onMenuPressed,
            icon: const Icon(Icons.menu_rounded, color: AppColors.c0A0A0A),
            iconSize: 26.sp,
          ),
          UIHelper.horizontalSpace(10.w),
          Image.asset(
            'assets/icons/logo_home.png',
            height: 28.h,
          ),
          Spacer(),
          IconButton(
            onPressed: onInboxPressed,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded,
                    color: AppColors.c0A0A0A,
                    size: 28),
                Positioned(
                  right: 2,
                  top: 0,
                  child: Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: const BoxDecoration(
                      color: AppColors.allPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
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
