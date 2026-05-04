import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/features/contractor/home/presentation/widget/metric_card.dart';
import 'package:template_flutter/features/contractor/home/presentation/widget/quote_request_card.dart';
import 'package:template_flutter/features/contractor/home/presentation/widget/section_header.dart';
import 'package:template_flutter/features/contractor/home/presentation/widget/welcome_banner.dart';
import 'package:template_flutter/features/customer/quotes/data/quote_request_store.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class HomeOverviewSection extends StatelessWidget {
  const HomeOverviewSection({
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
          WelcomeBanner(
            profileName: profileName,
            profileEmail: profileEmail,
          ),
          UIHelper.verticalSpace(14.h),
          const _MetricsGrid(),
          UIHelper.verticalSpace(18.h),
          SectionHeader(
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
                  return QuoteRequestCard(request: request);
                },
              );
            },
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
    final List<MetricData> metrics = <MetricData>[
      MetricData(
        icon: Icons.description_outlined,
        iconColor: const Color(0xFF20356F),
        value: '12',
        title: 'New Requests',
        subtitle: '+3 this week',
        onTap: () {
          // Handle tap if needed
        },
      ),
      MetricData(
        icon: Icons.access_time_outlined,
        iconColor: Colors.orange,
        value: '28',
        title: 'Pending',
        subtitle: 'Awaiting reply',
        onTap: () {
          // Handle tap if needed
        },
      ),
      MetricData(
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
        value: '28',
        title: 'Completed Jobs',
        subtitle: '+5 this month',
        onTap: () {
          // Handle tap if needed
        },
      ),
      MetricData(
        icon: Icons.star_outline,
        iconColor: Colors.amber,
        value: '4.9',
        title: 'Overall Review',
        subtitle: 'From 127 reviews',
        onTap: () {
          // Handle tap if needed
        },
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
        final MetricData metric = metrics[index];
        return MetricCard(data: metric);
      },
    );
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
        border: Border.all(color: AppColors.c0A0A0A.withValues(alpha: 0.12)),
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
