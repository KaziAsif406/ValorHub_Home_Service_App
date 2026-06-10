import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template_flutter/services/auth_service.dart';
import 'package:template_flutter/constants/app_constants.dart';
import 'package:template_flutter/features/customer/contractors/data/contractor_model.dart';

Future<void> showAddReviewDialog(
    BuildContext context, ContractorData contractor) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: AddReviewDialog(contractor: contractor),
        ),
      );
    },
  );
}

class AddReviewDialog extends StatefulWidget {
  const AddReviewDialog({super.key, required this.contractor});

  final ContractorData contractor;

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  int _selectedRating = 1;
  final TextEditingController _commentController = TextEditingController();

  void _setRating(int rating) {
    setState(() {
      _selectedRating = rating;
    });
  }

  void _submitReview() {
    final comment = _commentController.text.trim();

    if (_selectedRating == 0 || comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add a rating and a short comment.'),
          backgroundColor: AppColors.cE7B008,
        ),
      );
      return;
    }

    final auth = AuthService();
    final user = auth.currentUser;
    if (user == null) {
      // prompt sign-in
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Sign in required'),
          content: const Text('Please sign in to add a review.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK')),
          ],
        ),
      );
      return;
    }

    final String customerId = user.uid;
    final String customerName = user.displayName ?? user.email ?? 'Customer';

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Add review document
    firestore.collection('contractor_reviews').add({
      'contractorId': widget.contractor.id,
      'customerId': customerId,
      'customerName': customerName,
      'rating': _selectedRating,
      'comment': comment,
      'createdAt': Timestamp.now(),
    }).then((_) async {
      // Update contractor aggregate (rating and reviews count) in a transaction
      final DocumentReference contractorRef = firestore
          .collection(kFirestoreUsersCollection)
          .doc(widget.contractor.id);
      await firestore.runTransaction((tx) async {
        final snapshot = await tx.get(contractorRef);
        if (!snapshot.exists) return;
        final data = snapshot.data() as Map<String, dynamic>? ?? {};
        final double oldRating =
            (data['rating'] is num) ? (data['rating'] as num).toDouble() : 0.0;
        final int oldReviews =
            (data['reviews'] is int) ? data['reviews'] as int : 0;
        final int newReviews = oldReviews + 1;
        final double newRating =
            ((oldRating * oldReviews) + _selectedRating) / newReviews;
        tx.update(contractorRef, {'rating': newRating, 'reviews': newReviews});
      });

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Thanks for your review — $_selectedRating star${_selectedRating > 1 ? 's' : ''}!'),
          backgroundColor: AppColors.allPrimaryColor,
        ),
      );
    }).catchError((e) {
      // ignore: avoid_print
      print('Failed to submit review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: ${e.toString()}')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Write a Review',
                  style: TextFontStyle.textStyle18c14181FInter600,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  height: 32.h,
                  width: 32.h,
                  decoration: BoxDecoration(
                    color: AppColors.c8E8E93.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.black, size: 20),
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(16.h),
          Text(
            'Rate the Service',
            style: TextFontStyle.textStyle16c14181FInter500,
          ),
          UIHelper.verticalSpace(16.h),
          Row(
            children: List.generate(
              5,
              (index) {
                final starIndex = index + 1;
                return GestureDetector(
                  onTap: () => _setRating(starIndex),
                  child: Padding(
                    padding: EdgeInsets.only(right: 6.w),
                    child: Icon(
                      starIndex <= _selectedRating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: AppColors.cE7B008,
                      size: 24.w,
                    ),
                  ),
                );
              },
            ),
          ),
          UIHelper.verticalSpace(16.h),
          Container(
            width: double.infinity,
            height: 88.h,
            decoration: BoxDecoration(
              color: AppColors.cE3E3E3.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: TextField(
              controller: _commentController,
              maxLines: 5,
              style: TextFontStyle.textStyle14c6A7181Inter400,
              decoration: InputDecoration(
                hintText: 'Tell us about your experience...',
                hintStyle: TextFontStyle.textStyle14c6A7181Inter400
                    .copyWith(color: AppColors.c64748B.withAlpha(120)),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          UIHelper.verticalSpace(14.h),
          CustomButton(
            label: 'Submit Review',
            onPressed: _submitReview,
            textStyle: TextFontStyle.textStyle14cFFFFFFInter600,
            borderRadius: 12.r,
            padding: EdgeInsets.symmetric(vertical: 14.h),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
