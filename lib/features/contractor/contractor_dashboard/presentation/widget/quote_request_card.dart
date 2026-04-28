import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/customer/quotes/data/quote_request_store.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class QuoteRequestCard extends StatelessWidget {
  const QuoteRequestCard({super.key, required this.request});

  final QuoteRequestModel request;

  @override
  Widget build(BuildContext context) {
    final String initials = _initials(request.fullName);
    final bool isCompleted = request.status == QuoteRequestStatus.completed;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.c0A0A0A),
        boxShadow: [
          BoxShadow(
            color: AppColors.c0A0A0A.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor:
                AppColors.contractor_primary.withValues(alpha: 0.12),
            child: Text(
              initials,
              style: TextStyle(
                color: AppColors.contractor_primary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          UIHelper.horizontalSpace(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        request.fullName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.c14181F,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color:
                            isCompleted ? AppColors.cDCFCE7 : AppColors.c0A0A0A,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        isCompleted ? 'Completed' : 'New',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: isCompleted
                              ? AppColors.c008236
                              : AppColors.contractor_primary,
                        ),
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(4.h),
                Text(
                  request.serviceCategory,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.c14181F,
                  ),
                ),
                UIHelper.verticalSpace(3.h),
                Text(
                  request.zipCode,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.c6A7181,
                  ),
                ),
                UIHelper.verticalSpace(3.h),
                Text(
                  _formatDate(request.submittedAt),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.c6A7181,
                  ),
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
      return 'Q';
    }

    if (words.length == 1) {
      return words.first.characters.first.toUpperCase();
    }

    return (words.first.characters.first + words.last.characters.first)
        .toUpperCase();
  }

  String _formatDate(DateTime date) {
    const List<String> monthNames = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }
}