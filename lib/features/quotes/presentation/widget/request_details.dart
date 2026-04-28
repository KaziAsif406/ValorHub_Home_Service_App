import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/quotes/data/quote_request_store.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

void showRequestDetailsBottomSheet(
  BuildContext context,
  QuoteRequestModel request,
) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.scaffoldColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (BuildContext context) {
      return RequestDetailsSheet(request: request);
    },
  );
}

class RequestDetailsSheet extends StatelessWidget {
  const RequestDetailsSheet({
    super.key,
    required this.request,
  });

  final QuoteRequestModel request;

  @override
  Widget build(BuildContext context) {
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
          RequestDetailRow(label: 'Full Name', value: request.fullName),
          RequestDetailRow(label: 'Email', value: request.email),
          RequestDetailRow(label: 'Phone', value: request.phone),
          RequestDetailRow(label: 'Zip Code', value: request.zipCode),
          RequestDetailRow(label: 'Service', value: request.serviceCategory),
          RequestDetailRow(
            label: 'Contractor',
            value: request.contractorName ?? 'Not specified',
          ),
          RequestDetailRow(
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
  }
}

class RequestDetailRow extends StatelessWidget {
  const RequestDetailRow({
    super.key,
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
