import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template_flutter/services/auth_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class DashboardReviewsSection extends StatelessWidget {
  const DashboardReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = AuthService().currentUser?.uid;

    if (currentUserId == null) {
      return Center(
        child: Text('Please sign in to see your reviews.',
            style: TextFontStyle.textStyle14c6A7181Inter400),
      );
    }

    final Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
        .instance
        .collection('contractor_reviews')
        .where('contractorId', isEqualTo: currentUserId)
        .snapshots();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Unable to load reviews.'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ??
            <QueryDocumentSnapshot<Map<String, dynamic>>>[];
        // sort by createdAt desc
        docs.sort((a, b) {
          final Timestamp? ta = a.data()['createdAt'] as Timestamp?;
          final Timestamp? tb = b.data()['createdAt'] as Timestamp?;
          final int va = ta?.millisecondsSinceEpoch ?? 0;
          final int vb = tb?.millisecondsSinceEpoch ?? 0;
          return vb.compareTo(va);
        });

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reviews',
                style: TextFontStyle.textStyle20c0A0A0AInter700.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              UIHelper.verticalSpace(14.h),
              ...docs.map((doc) {
                final data = doc.data();
                final String name =
                    (data['customerName'] as String?) ?? 'Customer';
                final double rating = (data['rating'] is num)
                    ? (data['rating'] as num).toDouble()
                    : 0.0;
                final String comment = (data['comment'] as String?) ?? '';
                final Timestamp? ts = data['createdAt'] as Timestamp?;
                final String timeAgo =
                    ts != null ? timeago.format(ts.toDate()) : '';

                return Padding(
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
                                _initials(name),
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
                                    name,
                                    style: TextFontStyle
                                        .textStyle15c0A0A0AInter700,
                                  ),
                                  if (timeAgo.isNotEmpty)
                                    Text(
                                      timeAgo,
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
                                  rating.toStringAsFixed(1),
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
                          comment,
                          style: TextStyle(
                            fontSize: 13.sp,
                            height: 1.4,
                            color: AppColors.c14181F,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
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
