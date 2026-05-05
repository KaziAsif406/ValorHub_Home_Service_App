import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:template_flutter/features/contractor/quote_requests/presentation/widget/request_card.dart';
import 'package:template_flutter/features/contractor/quote_requests/presentation/widget/selector_pill.dart';
import 'package:template_flutter/features/customer/quotes/data/quote_request_store.dart';
import 'package:template_flutter/features/customer/quotes/presentation/widget/request_details.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

enum _QuoteRequestFilter { all, pending, accepted, rejected }

class AllRequestsScreen extends StatefulWidget {
  const AllRequestsScreen({super.key});

  @override
  State<AllRequestsScreen> createState() => _AllRequestsScreenState();
}

class _AllRequestsScreenState extends State<AllRequestsScreen> {
  _QuoteRequestFilter _selectedFilter = _QuoteRequestFilter.all;

  @override
  Widget build(BuildContext context) {
    final String? contractorId = FirebaseAuth.instance.currentUser?.uid;

    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: contractorId == null
            ? _buildEmptyState()
            : StreamBuilder<List<QuoteRequestModel>>(
                stream: QuoteRequestStore.instance
                    .contractorRequestsStream(contractorId),
                initialData: QuoteRequestStore.instance.requests,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<QuoteRequestModel>> snapshot,
                ) {
                  final List<QuoteRequestModel> requests =
                      snapshot.data ?? QuoteRequestStore.instance.requests;
                  final List<QuoteRequestModel> filteredRequests =
                      _filterRequests(requests);

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(14.w, 18.h, 14.w, 0),
                          child: Text(
                            'Quote Requests',
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.c14181F,
                            ),
                          ),
                        ),
                        UIHelper.verticalSpace(18.h),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              UIHelper.horizontalSpace(12.w),
                              Row(
                                children: _buildFilterPills(requests),
                              ),
                              UIHelper.horizontalSpace(12.w),
                            ],
                          ),
                        ),
                        UIHelper.verticalSpace(18.h),
                        if (filteredRequests.isEmpty)
                          _buildEmptyState()
                        else
                          Padding(
                            padding: EdgeInsets.fromLTRB(14.w, 0.h, 14.w, 0),
                            child: Column(
                              children: filteredRequests.map((request) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: QuoteRequestCard(
                                    request: request,
                                    onView: () => showRequestDetailsBottomSheet(
                                      context,
                                      request,
                                    ),
                                    onAccept: () =>
                                        QuoteRequestStore.instance.updateStatus(
                                      request.id,
                                      QuoteRequestStatus.accepted,
                                    ),
                                    onReject: () =>
                                        QuoteRequestStore.instance.updateStatus(
                                      request.id,
                                      QuoteRequestStatus.rejected,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }

  List<Widget> _buildFilterPills(List<QuoteRequestModel> requests) {
    return <Widget>[
      QuoteSelectorPill(
        label: 'All',
        count: requests.length,
        selected: _selectedFilter == _QuoteRequestFilter.all,
        onTap: () => setState(() => _selectedFilter = _QuoteRequestFilter.all),
      ),
      UIHelper.horizontalSpace(10.w),
      QuoteSelectorPill(
        label: 'New',
        count: requests
            .where((QuoteRequestModel request) =>
                request.status == QuoteRequestStatus.pending)
            .length,
        selected: _selectedFilter == _QuoteRequestFilter.pending,
        onTap: () =>
            setState(() => _selectedFilter = _QuoteRequestFilter.pending),
      ),
      UIHelper.horizontalSpace(10.w),
      QuoteSelectorPill(
        label: 'Accepted',
        count: requests
            .where((QuoteRequestModel request) =>
                request.status == QuoteRequestStatus.accepted)
            .length,
        selected: _selectedFilter == _QuoteRequestFilter.accepted,
        onTap: () =>
            setState(() => _selectedFilter = _QuoteRequestFilter.accepted),
      ),
      UIHelper.horizontalSpace(10.w),
      QuoteSelectorPill(
        label: 'Rejected',
        count: requests
            .where((QuoteRequestModel request) =>
                request.status == QuoteRequestStatus.rejected)
            .length,
        selected: _selectedFilter == _QuoteRequestFilter.rejected,
        onTap: () =>
            setState(() => _selectedFilter = _QuoteRequestFilter.rejected),
      ),
    ];
  }

  List<QuoteRequestModel> _filterRequests(List<QuoteRequestModel> requests) {
    return requests.where((QuoteRequestModel request) {
      switch (_selectedFilter) {
        case _QuoteRequestFilter.all:
          return true;
        case _QuoteRequestFilter.pending:
          return request.status == QuoteRequestStatus.pending;
        case _QuoteRequestFilter.accepted:
          return request.status == QuoteRequestStatus.accepted;
        case _QuoteRequestFilter.rejected:
          return request.status == QuoteRequestStatus.rejected;
      }
    }).toList();
  }

  Widget _buildEmptyState() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 0),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(22.w),
          decoration: BoxDecoration(
            color: AppColors.scaffoldColor,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: AppColors.contractor_primary.withValues(alpha: 0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.c0A0A0A.withValues(alpha: 0.06),
                blurRadius: 16.r,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 62.w,
                height: 62.h,
                decoration: BoxDecoration(
                  color: AppColors.contractor_primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inbox_rounded,
                  color: AppColors.contractor_primary,
                  size: 30.sp,
                ),
              ),
              UIHelper.verticalSpace(14.h),
              Text(
                'No requests in this filter',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.c14181F,
                ),
              ),
              UIHelper.verticalSpace(6.h),
              Text(
                'Try a different selector or wait for the next quote request to arrive.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  height: 1.45,
                  color: AppColors.c6A7181,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}