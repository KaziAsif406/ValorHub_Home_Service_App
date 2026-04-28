import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class DashboardReviewsSection extends StatelessWidget {
  const DashboardReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_ReviewData> reviews = <_ReviewData>[
      _ReviewData('Sarah Mitchell', 'Bathroom remodel', 5.0,
          'Excellent work and quick turnaround.'),
      _ReviewData('James Parker', 'Kitchen sink replacement', 4.9,
          'Professional, punctual, and clean.'),
      _ReviewData('Olivia Brown', 'Electrical inspection', 4.8,
          'Explained everything clearly.'),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reviews',
            style: TextFontStyle.textStyle20c0A0A0AInter700.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          UIHelper.verticalSpace(14.h),
          ...reviews.map(
            (_ReviewData review) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: AppColors.c0A0A0A),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18.r,
                          backgroundColor: AppColors.contractor_primary
                              .withValues(alpha: 0.12),
                          child: Text(
                            _initials(review.name),
                            style: TextStyle(
                              color: AppColors.contractor_primary,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        UIHelper.horizontalSpace(10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.name,
                                style: TextFontStyle.textStyle15c0A0A0AInter700,
                              ),
                              Text(
                                review.service,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.c6A7181,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star_rounded,
                                color: Colors.amber, size: 18.sp),
                            UIHelper.horizontalSpace(2.w),
                            Text(
                              review.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.c0A0A0A,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    UIHelper.verticalSpace(12.h),
                    Text(
                      review.comment,
                      style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.4,
                        color: AppColors.c14181F,
                      ),
                    ),
                  ],
                ),
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
      return 'R';
    }

    if (words.length == 1) {
      return words.first.characters.first.toUpperCase();
    }

    return (words.first.characters.first + words.last.characters.first)
        .toUpperCase();
  }
}

class _ReviewData {
  _ReviewData(this.name, this.service, this.rating, this.comment);

  final String name;
  final String service;
  final double rating;
  final String comment;
}
