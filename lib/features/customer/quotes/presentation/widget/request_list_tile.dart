import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/customer/quotes/data/quote_request_store.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

import 'request_details.dart';

class RequestListTile extends StatelessWidget {
  const RequestListTile({
    super.key,
    required this.request,
    required this.dateLabel,
  });

  final QuoteRequestModel request;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = request.status == QuoteRequestStatus.completed;
    final bool isAccepted = request.status == QuoteRequestStatus.accepted;
    final bool isRejected = request.status == QuoteRequestStatus.rejected;
    final String statusLabel = isCompleted
        ? 'Completed'
        : isAccepted
            ? 'Accepted'
            : isRejected
                ? 'Rejected'
                : 'Pending';
    final Color statusTextColor = isCompleted
        ? AppColors.c008236
        : isAccepted
            ? AppColors.c008236
            : isRejected
                ? AppColors.allPrimaryColor
                : AppColors.cA65F00;
    final Color statusBgColor = isCompleted
        ? AppColors.cDCFCE7
        : isAccepted
            ? AppColors.cDCFCE7
            : isRejected
                ? AppColors.allPrimaryColor.withValues(alpha: 0.12)
                : AppColors.cFEF9C2;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.c0A0A0A.withValues(alpha: 0.18),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.c0A0A0A.withValues(alpha: 0.05),
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 19.r,
            backgroundColor: AppColors.c0A0A0A.withValues(alpha: 0.12),
            child: Text(
              _initials(request.contractorName ?? request.serviceCategory),
              style: TextFontStyle.textStyle12cBE1E2DInter600,
            ),
          ),
          UIHelper.horizontalSpace(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.contractorName ?? request.serviceCategory,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextFontStyle.textStyle14c14181FInter600,
                ),
                UIHelper.verticalSpace(4.h),
                Text(
                  '${request.serviceCategory} • $dateLabel',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextFontStyle.textStyle12c6A7181Inter400,
                ),
                UIHelper.verticalSpace(6.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextFontStyle.textStyle10c000000Inter500.copyWith(
                      color: statusTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          UIHelper.horizontalSpace(12.w),
          CustomButton(
            height: 32.h,
            width: 72.w,
            label: 'View',
            onPressed: () => showRequestDetailsBottomSheet(context, request),
            isOutlined: true,
            borderColor: AppColors.allPrimaryColor.withValues(alpha: 0.5),
            color: AppColors.allPrimaryColor,
            textStyle: TextFontStyle.textStyle12cBE1E2DInter600,
            borderRadius: 12.r,
            padding: EdgeInsets.zero,
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
}
