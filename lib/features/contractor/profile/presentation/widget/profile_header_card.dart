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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                  color: AppColors.c0A0A0A,
                ),
              ),
              GestureDetector(
                onTap: onEditPressed,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.contractor_primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 20.sp,
                    color: AppColors.contractor_primary,
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.2),
              ),
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
                          AppColors.contractor_primary.withValues(alpha: 0.15),
                      child: Text(
                        _initials(profileName),
                        style: TextStyle(
                          color: AppColors.contractor_primary,
                          fontSize: 16.sp,
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
                              color: AppColors.c0A0A0A,
                            ),
                          ),
                          UIHelper.verticalSpace(4.h),
                          Text(
                            professionalTitle,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.c6A7181,
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
                                  color: AppColors.c0A0A0A,
                                ),
                              ),
                              UIHelper.horizontalSpace(4.w),
                              Text(
                                '($reviewCount)',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.c6A7181,
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
                                    color: const Color(0xFF10B981)
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    'Verified',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF10B981),
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
