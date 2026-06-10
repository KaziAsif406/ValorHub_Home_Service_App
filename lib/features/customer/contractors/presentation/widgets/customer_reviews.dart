import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/customer/contractors/data/contractor_model.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

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
  final ContractorData contractor;

  const CustomerReviews({super.key, required this.contractor});

  Stream<QuerySnapshot<Map<String, dynamic>>> _reviewsStream(
      String contractorId) {
    return FirebaseFirestore.instance
        .collection('contractor_reviews')
        .where('contractorId', isEqualTo: contractorId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _reviewsStream(contractor.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Unable to load reviews.'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ??
            <QueryDocumentSnapshot<Map<String, dynamic>>>[];
        if (docs.isEmpty) {
          return Text('No reviews yet.',
              style: TextFontStyle.textStyle14c6A7181Inter400);
        }

        return Column(
          children: docs.map((doc) {
            final data = doc.data();
            final String name = (data['customerName'] as String?) ?? 'Customer';
            final double rating = (data['rating'] is num)
                ? (data['rating'] as num).toDouble()
                : 0.0;
            final String comment = (data['comment'] as String?) ?? '';
            final Timestamp? ts = data['createdAt'] as Timestamp?;
            final String timeAgo =
                ts != null ? timeago.format(ts.toDate()) : 'Just now';

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
                        name,
                        style: TextFontStyle.textStyle14c14181FInter600,
                      ),
                      Text(
                        timeAgo,
                        style: TextFontStyle.textStyle12c6A7181Inter400,
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(6.h),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating.toInt()
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: AppColors.cE7B008,
                        size: 12.w,
                      );
                    }),
                  ),
                  UIHelper.verticalSpace(6.h),
                  Text(
                    comment,
                    style: TextFontStyle.textStyle12c6A7181Inter400.copyWith(
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
