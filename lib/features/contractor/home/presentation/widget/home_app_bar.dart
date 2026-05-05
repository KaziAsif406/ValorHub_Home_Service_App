import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class ContractorHomeAppBar extends StatelessWidget {
  const ContractorHomeAppBar({
    super.key,
    required this.profileName,
    required this.onInboxPressed,
  });

  final String profileName;
  final VoidCallback onInboxPressed;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor.withValues(alpha: 0.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
}
