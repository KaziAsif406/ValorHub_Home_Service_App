import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/quotes/data/quote_request_store.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  static const List<String> _monthNames = <String>[
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        title: Text(
          'My Requests',
          style: TextFontStyle.textStyle16c000000Inter700,
        ),
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              color: AppColors.c000000),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<List<QuoteRequestModel>>(
        stream: QuoteRequestStore.instance.requestsStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<QuoteRequestModel>> snapshot) {
          final List<QuoteRequestModel> requests =
              snapshot.data ?? QuoteRequestStore.instance.requests;

          if (requests.isEmpty) {
            return _EmptyState();
          }

          return Padding(
            padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Recent Quote Requests',
                        style:
                            TextFontStyle.textStyle24c0A0A0AInter700.copyWith(
                          fontSize: 24.sp,
                        ),
                      ),
                    ),
                    Text(
                      'View All',
                      style: TextFontStyle.textStyle12cBE1E2DInter600,
                    ),
                  ],
                ),
                UIHelper.verticalSpace(10.h),
                Expanded(
                  child: ListView.separated(
                    itemCount: requests.length,
                    separatorBuilder: (_, __) => UIHelper.verticalSpace(10.h),
                    itemBuilder: (BuildContext context, int index) {
                      final QuoteRequestModel request = requests[index];
                      return _RequestTile(
                        request: request,
                        dateLabel: _formatDate(request.submittedAt),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${_monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _RequestTile extends StatelessWidget {
  const _RequestTile({
    required this.request,
    required this.dateLabel,
  });

  final QuoteRequestModel request;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = request.status == QuoteRequestStatus.completed;
    final Color statusTextColor =
        isCompleted ? AppColors.c0F9918 : AppColors.cE7B008;
    final Color statusBgColor = isCompleted
        ? AppColors.c0FCC5D.withValues(alpha: 0.16)
        : AppColors.cF59F0A.withValues(alpha: 0.14);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.c000E65.withValues(alpha: 0.8),
          width: 1.w,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 19.r,
            backgroundColor: AppColors.c0F9918.withValues(alpha: 0.12),
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
                    isCompleted ? 'Completed' : 'Pending',
                    style: TextFontStyle.textStyle10c000000Inter500.copyWith(
                      color: statusTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          UIHelper.horizontalSpace(12.w),
          SizedBox(
            width: 66.w,
            height: 34.h,
            child: CustomButton(
              label: 'View',
              onPressed: () => _showRequestDetails(context, request),
              isOutlined: true,
              borderColor: AppColors.allPrimaryColor,
              color: AppColors.allPrimaryColor,
              textStyle: TextFontStyle.textStyle12cBE1E2DInter600,
              borderRadius: 12.r,
              padding: EdgeInsets.zero,
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

  void _showRequestDetails(BuildContext context, QuoteRequestModel request) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.scaffoldColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Request Details',
                style: TextFontStyle.textStyle16c000000Inter700,
              ),
              UIHelper.verticalSpace(14.h),
              _DetailRow(label: 'Full Name', value: request.fullName),
              _DetailRow(label: 'Email', value: request.email),
              _DetailRow(label: 'Phone', value: request.phone),
              _DetailRow(label: 'Zip Code', value: request.zipCode),
              _DetailRow(label: 'Service', value: request.serviceCategory),
              _DetailRow(
                label: 'Contractor',
                value: request.contractorName ?? 'Not specified',
              ),
              _DetailRow(
                label: 'Project Details',
                value: request.projectDetails,
                isExpanded: true,
              ),
              UIHelper.verticalSpace(8.h),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  label: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                  height: 36.h,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.isExpanded = false,
  });

  final String label;
  final String value;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextFontStyle.textStyle12c6A7181Inter500,
          ),
          UIHelper.verticalSpace(4.h),
          Text(
            value,
            maxLines: isExpanded ? 4 : 1,
            overflow: isExpanded ? TextOverflow.fade : TextOverflow.ellipsis,
            style: TextFontStyle.textStyle14c14181FInter500,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.request_quote_outlined,
              size: 42.sp,
              color: AppColors.c6A7181,
            ),
            UIHelper.verticalSpace(10.h),
            Text(
              'No quote requests yet',
              style: TextFontStyle.textStyle16c14181FInter600,
            ),
            UIHelper.verticalSpace(6.h),
            Text(
              'Submit a request from any contractor profile and it will appear here during this app run.',
              textAlign: TextAlign.center,
              style: TextFontStyle.textStyle12c6A7181Inter400,
            ),
          ],
        ),
      ),
    );
  }
}
