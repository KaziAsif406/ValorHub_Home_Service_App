import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.profileName,
    required this.professionalTitle,
    required this.rating,
    required this.reviewCount,
    required this.isVerified,
    required this.onEditPressed,
  });

  final String profileName;
  final String professionalTitle;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.contractor_primary,
            AppColors.contractor_secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.scaffoldColor,
                ),
              ),
              GestureDetector(
                onTap: onEditPressed,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldColor.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.edit_square,
                    size: 17.sp,
                    color: AppColors.scaffoldColor,
                  ),
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.scaffoldColor.withValues(alpha: 0.40),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32.r,
                      backgroundColor:
                          AppColors.contractor_primary.withValues(alpha: 0.95),
                      child: Text(
                        _initials(profileName),
                        style: TextStyle(
                          color: AppColors.scaffoldColor.withValues(alpha: 0.75),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    UIHelper.horizontalSpace(14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profileName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.scaffoldColor.withValues(alpha: 0.85),
                            ),
                          ),
                          UIHelper.verticalSpace(4.h),
                          Text(
                            professionalTitle,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.scaffoldColor.withValues(alpha: 0.75),
                            ),
                          ),
                          UIHelper.verticalSpace(8.h),
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 16.sp,
                                color: const Color(0xFFFDB913),
                              ),
                              UIHelper.horizontalSpace(4.w),
                              Text(
                                rating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.scaffoldColor.withValues(alpha: 0.85),
                                ),
                              ),
                              UIHelper.horizontalSpace(4.w),
                              Text(
                                '($reviewCount)',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.scaffoldColor.withValues(alpha: 0.85),
                                ),
                              ),
                              UIHelper.horizontalSpace(8.w),
                              if (isVerified)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.c008236,
                                    borderRadius: BorderRadius.circular(36.r),
                                  ),
                                  child: Text(
                                    'Verified',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.scaffoldColor,
                                      letterSpacing: 0.9,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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
