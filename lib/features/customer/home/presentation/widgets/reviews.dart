import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  static final List<_ReviewData> _reviews = [
    _ReviewData(
      content: 'Found an amazing plumber within hours. Great service!',
      author: 'Sarah M.',
    ),
    _ReviewData(
      content:
          'The contractor handled my remodel professionally. Highly recommend.',
      author: 'James K.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'What Homeowners Say',
            style: TextFontStyle.textStyle16c0A0A0AInter700,
          ),
        ),
        UIHelper.verticalSpace(16.h),
        SizedBox(
          height: 125.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _reviews.length,
            separatorBuilder: (_, __) => SizedBox(width: 16.w),
            itemBuilder: (context, index) {
              final review = _reviews[index];
              return _ReviewCard(review: review);
            },
          ),
        ),
      ],
    );
  }
}

class _ReviewData {
  const _ReviewData({required this.content, required this.author});

  final String content;
  final String author;
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final _ReviewData review;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260.w,
      height: 125.h,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (index) => Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: Image.asset(
                  'assets/icons/gold_star.png',
                  width: 14.w,
                  height: 14.h,
                ),
              ),
            ),
          ),
          UIHelper.verticalSpace(10.h),
          Text(
            '"${review.content}"',
            style: TextFontStyle.textStyle12c6A7181Inter400,
          ),
          UIHelper.verticalSpace(12.h),
          Text(
            review.author,
            style: TextFontStyle.textStyle12c14181FInter600,
          ),
        ],
      ),
    );
  }
}
