import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/customer/quotes/data/quote_request_store.dart';
import 'package:template_flutter/features/customer/quotes/presentation/widget/request_list_tile.dart';
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
    final String? customerId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        title: Text(
          'My Requests',
          style: TextFontStyle.textStyle16c000000Inter700,
        ),
        backgroundColor: AppColors.scaffoldColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              color: AppColors.c000000),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: customerId == null
          ? _EmptyState()
          : StreamBuilder<List<QuoteRequestModel>>(
              stream:
                  QuoteRequestStore.instance.customerRequestsStream(customerId),
              builder: (BuildContext context,
                  AsyncSnapshot<List<QuoteRequestModel>> snapshot) {
                final List<QuoteRequestModel> requests =
                    snapshot.data ?? QuoteRequestStore.instance.requests;

                if (requests.isEmpty) {
                  return _EmptyState();
                }

                return Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    children: [
                      UIHelper.verticalSpace(10.h),
                      Expanded(
                        child: ListView.separated(
                          itemCount: requests.length,
                          separatorBuilder: (_, __) =>
                              UIHelper.verticalSpace(10.h),
                          itemBuilder: (BuildContext context, int index) {
                            final QuoteRequestModel request = requests[index];
                            return RequestListTile(
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
