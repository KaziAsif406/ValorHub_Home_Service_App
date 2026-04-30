import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/customer/contractors/data/contractor_model.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
import 'contractor_info.dart';

class CustomerReview {
  final String name;
  final double rating;
  final String comment;
  final String timeAgo;

  CustomerReview({
    required this.name,
    required this.rating,
    required this.comment,
    required this.timeAgo,
  });
}

class CustomerReviews extends StatelessWidget {
  final contractorData contractor;

  CustomerReviews({
    super.key,
    required this.contractor,
  });

  final List<CustomerReview> reviews = [
    CustomerReview(
      name: 'John D.',
      rating: 5,
      comment: 'Excellent work on our kitchen plumbing. Very professional and clean.',
      timeAgo: '2 weeks ago',
    ),
    CustomerReview(
      name: 'Emily S.',
      rating: 5,
      comment: 'Fast response and fair pricing. Will definitely hire again.',
      timeAgo: '1 month ago',
    ),
    CustomerReview(
      name: 'Robert L.',
      rating: 4,
      comment: 'Good quality work. Arrived on time and completed the job as promised.',
      timeAgo: '2 months ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: reviews.map((review) {
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.scaffoldColor.withValues(alpha: 20),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.c14181F.withValues(alpha: 0.2),
                blurRadius: 5.r,
                offset: Offset(0, 2.h),
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
                    review.name,
                    style: TextFontStyle.textStyle14c14181FInter600,
                  ),
                  Text(
                    review.timeAgo,
                    style: TextFontStyle.textStyle12c6A7181Inter400,
                  ),
                ],
              ),
              UIHelper.verticalSpace(6.h),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating.toInt()
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: AppColors.cE7B008,
                    size: 12.w,
                  );
                }),
              ),
              UIHelper.verticalSpace(6.h),
              Text(
                review.comment,
                style: TextFontStyle.textStyle12c6A7181Inter400.copyWith(
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
