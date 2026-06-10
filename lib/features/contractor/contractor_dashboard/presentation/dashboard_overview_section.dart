import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template_flutter/features/customer/quotes/data/quote_request_store.dart';
import 'package:template_flutter/features/contractor/contractor_dashboard/presentation/widget/metric_card.dart';
import 'package:template_flutter/features/contractor/contractor_dashboard/presentation/widget/quote_request_card.dart';
import 'package:template_flutter/features/contractor/contractor_dashboard/presentation/widget/section_header.dart';
import 'package:template_flutter/features/contractor/contractor_dashboard/presentation/widget/welcome_banner.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
import 'package:template_flutter/services/chat_service.dart';

class DashboardOverviewSection extends StatelessWidget {
  const DashboardOverviewSection({
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
    final String? contractorId = FirebaseAuth.instance.currentUser?.uid;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WelcomeBanner(
            profileName: profileName,
            profileEmail: profileEmail,
            onViewRequests: onViewRequests,
          ),
          UIHelper.verticalSpace(14.h),
          _MetricsGrid(contractorId: contractorId),
          UIHelper.verticalSpace(18.h),
          SectionHeader(
            title: 'Recent Quote Requests',
            actionText: 'View all',
            onActionTap: () {},
          ),
          UIHelper.verticalSpace(12.h),
          StreamBuilder<List<QuoteRequestModel>>(
            stream: contractorId == null
                ? Stream<List<QuoteRequestModel>>.value(
                    const <QuoteRequestModel>[],
                  )
                : QuoteRequestStore.instance
                    .contractorRequestsStream(contractorId),
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
  const _MetricsGrid({this.contractorId});

  final String? contractorId;

  @override
  Widget build(BuildContext context) {
    final Widget newRequestsCard = StreamBuilder<List<QuoteRequestModel>>(
      stream: contractorId == null
          ? Stream<List<QuoteRequestModel>>.value(const <QuoteRequestModel>[])
          : QuoteRequestStore.instance.contractorRequestsStream(contractorId!),
      builder: (context, snapshot) {
        final List<QuoteRequestModel> requests =
            snapshot.data ?? <QuoteRequestModel>[];
        final int newCount = requests
            .where((r) => r.status == QuoteRequestStatus.pending)
            .length;

        final MetricData metric = MetricData(
          icon: Icons.description_outlined,
          iconColor: const Color(0xFF20356F),
          value: newCount.toString(),
          title: 'New Requests',
          subtitle: '+${newCount > 0 ? newCount : 0} this week',
          onTap: () {},
        );

        return MetricCard(data: metric);
      },
    );

    // Pending card: count of unseen chat messages
    final Widget pendingCard = StreamBuilder<int>(
      stream: contractorId == null || contractorId!.isEmpty
          ? Stream<int>.value(0)
          : ChatService()
              .unseenMessageCountStream(currentUserId: contractorId!),
      builder: (context, snapshot) {
        int unseenCount = 0;
        if (snapshot.hasError) {
          // ignore: avoid_print
          print('DEBUG: pendingCard stream error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          unseenCount = snapshot.data ?? 0;
        }

        final MetricData metric = MetricData(
          icon: Icons.access_time_outlined,
          iconColor: Colors.orange,
          value: unseenCount.toString(),
          title: 'Unseen Messages',
          subtitle: 'Awaiting response',
          onTap: () {},
        );

        return MetricCard(data: metric);
      },
    );

    final Widget completedCard = MetricCard(
      data: MetricData(
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
        value: '28',
        title: 'Completed Jobs',
        subtitle: '+5 this month',
        onTap: () {},
      ),
    );
    final Widget reviewCard = contractorId == null
        ? MetricCard(
            data: MetricData(
              icon: Icons.star_outline,
              iconColor: Colors.amber,
              value: '0.0',
              title: 'Overall Review',
              subtitle: 'No reviews yet',
              onTap: () {},
            ),
          )
        : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('contractor_reviews')
                .where('contractorId', isEqualTo: contractorId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return MetricCard(
                  data: MetricData(
                    icon: Icons.star_outline,
                    iconColor: Colors.amber,
                    value: '0.0',
                    title: 'Overall Review',
                    subtitle: 'Error',
                    onTap: () {},
                  ),
                );
              }

              if (!snapshot.hasData) {
                return MetricCard(
                  data: MetricData(
                    icon: Icons.star_outline,
                    iconColor: Colors.amber,
                    value: '...',
                    title: 'Overall Review',
                    subtitle: 'Loading',
                    onTap: () {},
                  ),
                );
              }

              final docs = snapshot.data!.docs;
              final int count = docs.length;
              double avg = 0.0;
              if (count > 0) {
                final double sum = docs.map((d) {
                  final dynamic r = d.data()['rating'];
                  return (r is num) ? r.toDouble() : 0.0;
                }).fold(0.0, (double a, double b) => a + b);
                avg = sum / count;
              }

              final MetricData metric = MetricData(
                icon: Icons.star_outline,
                iconColor: Colors.amber,
                value: avg > 0 ? avg.toStringAsFixed(1) : '0.0',
                title: 'Overall Review',
                subtitle: count > 0 ? 'From $count reviews' : 'No reviews yet',
                onTap: () {},
              );

              return MetricCard(data: metric);
            },
          );

    final List<Widget> children = [
      newRequestsCard,
      pendingCard,
      completedCard,
      reviewCard,
    ];

    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
      childAspectRatio: 1.12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
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
