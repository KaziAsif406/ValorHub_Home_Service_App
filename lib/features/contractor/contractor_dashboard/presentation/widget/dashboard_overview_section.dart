import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/customer/quotes/data/quote_request_store.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class DashboardOverviewSection extends StatelessWidget {
  const DashboardOverviewSection({
    super.key,
    required this.profileName,
    required this.profileEmail,
  });

  final String profileName;
  final String profileEmail;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WelcomeBanner(profileName: profileName),
          UIHelper.verticalSpace(14.h),
          const _MetricsGrid(),
          UIHelper.verticalSpace(18.h),
          _SectionHeader(
            title: 'Recent Quote Requests',
            actionText: 'See all',
            onActionTap: () {},
          ),
          UIHelper.verticalSpace(12.h),
          StreamBuilder<List<QuoteRequestModel>>(
            stream: QuoteRequestStore.instance.requestsStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<QuoteRequestModel>> snapshot) {
              final List<QuoteRequestModel> requests =
                  snapshot.data ?? QuoteRequestStore.instance.requests;

              if (requests.isEmpty) {
                return const _EmptyRequestsState();
              }

              return ListView.separated(
                itemCount: requests.length > 3 ? 3 : requests.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => UIHelper.verticalSpace(10.h),
                itemBuilder: (BuildContext context, int index) {
                  final QuoteRequestModel request = requests[index];
                  return _QuoteRequestCard(request: request);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({required this.profileName});

  final String profileName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.contractor_primary, Color(0xFF5D44FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WELCOME BACK',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 12.sp,
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
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: '👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          UIHelper.verticalSpace(10.h),
          Text(
            'You have 2 new quote requests and 3 unread messages waiting for your attention.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 14.sp,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
          UIHelper.verticalSpace(14.h),
          SizedBox(
            width: 182.w,
            child: CustomButton(
              label: 'View Requests',
              onPressed: () {},
              height: 46.h,
              borderRadius: 14.r,
              color: Colors.white,
              textStyle: TextStyle(
                color: AppColors.contractor_primary,
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid();

  @override
  Widget build(BuildContext context) {
    final List<_MetricData> metrics = <_MetricData>[
      _MetricData(
        icon: Icons.description_outlined,
        iconColor: AppColors.contractor_primary,
        value: '12',
        title: 'New Requests',
        subtitle: '+3 this week',
      ),
      _MetricData(
        icon: Icons.access_time_outlined,
        iconColor: Colors.orange,
        value: '28',
        title: 'Pending',
        subtitle: 'Awaiting reply',
      ),
      _MetricData(
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
        value: '28',
        title: 'Completed Jobs',
        subtitle: '+5 this month',
      ),
      _MetricData(
        icon: Icons.star_outline,
        iconColor: Colors.amber,
        value: '4.9',
        title: 'Overall Review',
        subtitle: 'From 127 reviews',
      ),
    ];

    return GridView.builder(
      itemCount: metrics.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1.12,
      ),
      itemBuilder: (BuildContext context, int index) {
        final _MetricData metric = metrics[index];
        return _MetricCard(data: metric);
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.data});

  final _MetricData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.c0A0A0A),
        boxShadow: [
          BoxShadow(
            color: AppColors.c0A0A0A.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: data.iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              data.icon,
              size: 18.sp,
              color: data.iconColor,
            ),
          ),
          const Spacer(),
          Text(
            data.value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.c0A0A0A,
            ),
          ),
          UIHelper.verticalSpace(4.h),
          Text(
            data.title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.c14181F,
            ),
          ),
          UIHelper.verticalSpace(3.h),
          Text(
            data.subtitle,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.c6A7181,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionText,
    required this.onActionTap,
  });

  final String title;
  final String actionText;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.c0A0A0A,
            ),
          ),
        ),
        TextButton(
          onPressed: onActionTap,
          child: Text(
            actionText,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.contractor_primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuoteRequestCard extends StatelessWidget {
  const _QuoteRequestCard({required this.request});

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

class _EmptyRequestsState extends StatelessWidget {
  const _EmptyRequestsState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.c0A0A0A),
      ),
      child: Text(
        'No quote requests yet.',
        style: TextStyle(
          fontSize: 13.sp,
          color: AppColors.c6A7181,
        ),
      ),
    );
  }
}

class _MetricData {
  _MetricData({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String title;
  final String subtitle;
}
