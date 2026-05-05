import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/features/customer/quotes/data/quote_request_store.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class QuoteRequestCard extends StatefulWidget {
  const QuoteRequestCard({
    super.key,
    required this.request,
    required this.onView,
    required this.onAccept,
    required this.onReject,
  });

  final QuoteRequestModel request;
  final VoidCallback onView;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  State<QuoteRequestCard> createState() => _QuoteRequestCardState();
}

class _QuoteRequestCardState extends State<QuoteRequestCard> {
  @override
  Widget build(BuildContext context) {
    final String initials = _initials(widget.request.fullName);
    final bool isNew = widget.request.status == QuoteRequestStatus.pending;
    final bool isAccepted = widget.request.status == QuoteRequestStatus.accepted;
    final bool isRejected = widget.request.status == QuoteRequestStatus.rejected;
    final String statusLabel = isAccepted
      ? 'Accepted'
      : isRejected
        ? 'Rejected'
        : 'New';
    final Color statusBackground = isAccepted
      ? AppColors.cDCFCE7
      : isRejected
        ? AppColors.allPrimaryColor.withValues(alpha: 0.12)
        : AppColors.contractor_primary.withValues(alpha: 0.12);
    final Color statusForeground = isAccepted
      ? AppColors.c008236
      : isRejected
        ? AppColors.allPrimaryColor
        : AppColors.contractor_primary;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.contractor_primary.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.c0A0A0A.withValues(alpha: 0.06),
            blurRadius: 5.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor:
                    AppColors.contractor_primary.withValues(alpha: 0.12),
                child: Text(
                  initials,
                  style: TextStyle(
                    color: AppColors.contractor_primary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
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
                            widget.request.fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.c14181F,
                            ),
                          ),
                        ),
                        UIHelper.horizontalSpace(8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: statusBackground,
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Text(
                            statusLabel,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: statusForeground,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.request.serviceCategory,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.c14181F.withValues(alpha: 0.80),
                      ),
                    ),
                    UIHelper.verticalSpace(2.h),
                    Text(
                      widget.request.id.substring(0, 8).toUpperCase(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.c14181F.withValues(alpha: 0.40),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(15.h),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 12.sp,
                color: AppColors.c14181F.withValues(alpha: 0.70),
              ),
              UIHelper.horizontalSpace(4.w),
              Text(
                '${widget.request.location} - ${widget.request.zipCode}',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.c14181F.withValues(alpha: 0.70),
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(4.h),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 12.sp,
                color: AppColors.c14181F.withValues(alpha: 0.70),
              ),
              UIHelper.horizontalSpace(4.w),
              Text(
                _formatDate(widget.request.submittedAt),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.c14181F.withValues(alpha: 0.70),
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(4.h),
          Text(
            widget.request.projectDetails,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              height: 1.5,
              color: AppColors.c14181F.withValues(alpha: 0.70),
            ),
          ),
          UIHelper.verticalSpace(14.h),
          if (isNew) ...[
            UIHelper.verticalSpace(14.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: 'View',
                    onPressed: widget.onView,
                    color: AppColors.cCCCCCC.withValues(alpha: 0.22),
                    textStyle: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.contractor_primary,
                    ),
                    borderRadius: 14.r,
                    padding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.visibility_outlined,
                      color: AppColors.contractor_primary,
                      size: 18.sp,
                    ),
                  ),
                ),
                UIHelper.horizontalSpace(10.w),
                Expanded(
                  child: CustomButton(
                    label: 'Accept',
                    onPressed: widget.onAccept,
                    isOutlined: false,
                    color: AppColors.c3FAD46,
                    borderColor: AppColors.contractor_primary,
                    textStyle: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.scaffoldColor,
                    ),
                    borderRadius: 14.r,
                    padding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.check_rounded,
                      color: AppColors.scaffoldColor,
                      size: 18.sp,
                    ),
                  ),
                ),
                UIHelper.horizontalSpace(10.w),
                CustomButton(
                  width: 40.w,
                  label: '',
                  gap: false,
                  onPressed: widget.onReject,
                  color: AppColors.allPrimaryColor.withValues(alpha: 0.12),
                  borderRadius: 14.r,
                  padding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.close_rounded,
                    color: AppColors.allPrimaryColor,
                    size: 25.sp,
                  ),
                ),
              ],
            ),
          ],
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