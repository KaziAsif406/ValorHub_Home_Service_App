import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:template_flutter/services/chat_service.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({
    super.key,
    required this.profileName,
    required this.profileEmail,
    this.onViewRequests,
  });

  final String profileName;
  final String profileEmail;
  final VoidCallback? onViewRequests;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.contractor_primary,
            AppColors.contractor_secondary
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WELCOME BACK',
            style: TextStyle(
              color: AppColors.allSecondaryColor.withValues(alpha: 0.52),
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          UIHelper.verticalSpace(8.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Good morning, $profileName ',
                  style: TextStyle(
                    color: AppColors.allSecondaryColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: '👋',
                  style: TextStyle(
                    color: AppColors.allSecondaryColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          UIHelper.verticalSpace(10.h),
          Builder(builder: (context) {
            final String? uid = FirebaseAuth.instance.currentUser?.uid;
            if (uid == null) {
              return Text(
                'You have 0 new quote requests and 0 unread messages waiting for your attention.',
                style: TextStyle(
                  color: AppColors.allSecondaryColor.withValues(alpha: 0.88),
                  fontSize: 14.sp,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              );
            }

            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('quote_requests')
                  .where('contractorId', isEqualTo: uid)
                  .where('status', isEqualTo: 'pending')
                  .snapshots(),
              builder: (context, quoteSnap) {
                final int newRequests =
                    quoteSnap.hasData ? quoteSnap.data!.docs.length : 0;

                return StreamBuilder<int>(
                  stream: ChatService()
                      .unseenMessageCountStream(currentUserId: uid),
                  builder: (context, msgSnap) {
                    final int unread = msgSnap.hasData ? msgSnap.data! : 0;

                    return Text(
                      'You have $newRequests new quote request${newRequests == 1 ? '' : 's'} and $unread unread message${unread == 1 ? '' : 's'} waiting for your attention.',
                      style: TextStyle(
                        color:
                            AppColors.allSecondaryColor.withValues(alpha: 0.88),
                        fontSize: 14.sp,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                );
              },
            );
          }),
          UIHelper.verticalSpace(14.h),
          CustomButton(
            label: 'View Requests',
            onPressed: onViewRequests ?? () {},
            height: 35.h,
            width: 130.w,
            borderRadius: 14.r,
            color: AppColors.allSecondaryColor,
            textStyle: TextStyle(
              color: AppColors.contractor_primary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
