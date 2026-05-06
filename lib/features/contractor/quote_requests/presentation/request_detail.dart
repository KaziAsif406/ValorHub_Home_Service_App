import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/customer/quotes/data/quote_request_store.dart';
import 'package:template_flutter/gen/colors.gen.dart';
// import 'package:template_flutter/helpers/all_routes.dart';
// import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class RequestDetailsScreen extends StatelessWidget {
	const RequestDetailsScreen({super.key, required this.request});

	final QuoteRequestModel request;

	@override
	Widget build(BuildContext context) {
		final bool isAccepted = request.status == QuoteRequestStatus.accepted;
		final bool isRejected = request.status == QuoteRequestStatus.rejected;
		final String statusLabel = isAccepted
				? 'Accepted'
				: isRejected
						? 'Rejected'
						: 'Pending';
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

		return Scaffold(
			backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        elevation: 1,
        title: Text(
          'Request Details',
          style: TextFontStyle.textStyle18c000000Inter700,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              color: AppColors.c000000),
          onPressed: () => Navigator.pop(context),
        ),
      ),
			body: SafeArea(
				child: SingleChildScrollView(
					child: Padding(
						padding: EdgeInsets.all(14.w),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								// GestureDetector(
								// 	onTap: () => Navigator.of(context).pop(),
								// 	child: Row(
								// 		mainAxisSize: MainAxisSize.min,
								// 		children: [
								// 			Icon(
								// 				Icons.arrow_back_ios_new_rounded,
								// 				color: AppColors.c6A7181,
								// 				size: 20.sp,
								// 			),
								// 			UIHelper.horizontalSpace(6.w),
								// 			Text(
								// 				'Back to requests',
								// 				style: TextStyle(
								// 					fontSize: 16.sp,
								// 					fontWeight: FontWeight.w400,
								// 					color: AppColors.c6A7181,
								// 				),
								// 			),
								// 		],
								// 	),
								// ),
								UIHelper.verticalSpace(14.h),
								Container(
									width: double.infinity,
									padding: EdgeInsets.all(16.w),
									decoration: BoxDecoration(
										color: AppColors.scaffoldColor,
										borderRadius: BorderRadius.circular(24.r),
										border: Border.all(
											color: AppColors.contractor_primary.withValues(alpha: 0.14),
										),
										boxShadow: [
											BoxShadow(
												color: AppColors.c0A0A0A.withValues(alpha: 0.06),
												blurRadius: 10.r,
												offset: Offset(0, 3.h),
											),
										],
									),
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Row(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Expanded(
														child: Column(
															crossAxisAlignment: CrossAxisAlignment.start,
															children: [
																Text(
																	request.id,
																	style: TextFontStyle.textStyle14c6A7181Inter400,
																),
																UIHelper.verticalSpace(4.h),
																Text(
																	request.serviceCategory,
																	style: TextFontStyle.textStyle20c14181FInter700,
																),
															],
														),
													),
													Container(
														margin: EdgeInsets.only(top: 12.h),
														padding: EdgeInsets.symmetric(
															horizontal: 10.w,
															vertical: 6.h,
														),
														decoration: BoxDecoration(
															color: statusBackground,
															borderRadius: BorderRadius.circular(999.r),
														),
														child: Text(
															statusLabel,
															style: TextFontStyle.textStyle12c14181FInter600.copyWith(
                                color: statusForeground,
                              ),
														),
													),
												],
											),
											UIHelper.verticalSpace(18.h),
											Text(
												'CLIENT NAME',
												style: TextFontStyle.textStyle12c6A7181Inter400,
											),
											UIHelper.verticalSpace(8.h),
											Text(
												request.fullName,
												style: TextFontStyle.textStyle16c14181FInter500,
											),
											UIHelper.verticalSpace(20.h),
											Text(
												'DESCRIPTION',
												style: TextFontStyle.textStyle12c6A7181Inter400,
											),
											UIHelper.verticalSpace(8.h),
											Text(
												request.projectDetails,
												style: TextFontStyle.textStyle16c14181FInter500,
											),
											UIHelper.verticalSpace(20.h),
											Row(
												children: [
													Expanded(
														child: _InfoTile(
															icon: Icons.location_on_outlined,
															label: 'LOCATION',
															value: '${request.location},${request.zipCode}',
														),
													),
													UIHelper.horizontalSpace(12.w),
													Expanded(
														child: _InfoTile(
															icon: Icons.calendar_month_outlined,
															label: 'SUBMITTED',
															value: _formatRelativeDate(request.submittedAt),
														),
													),
													UIHelper.horizontalSpace(12.w),
													Expanded(
														child: _InfoTile(
															icon: Icons.attach_money_rounded,
															label: 'BUDGET',
															// value: _budgetLabel(request),
                              value: '${request.budget}\$',
														),
													),
												],
											),
										],
									),
								),
								UIHelper.verticalSpace(18.h),
								Container(
									width: double.infinity,
									padding: EdgeInsets.all(16.w),
									decoration: BoxDecoration(
										color: AppColors.scaffoldColor,
										borderRadius: BorderRadius.circular(14.r),
										border: Border.all(
											color: AppColors.contractor_primary.withValues(alpha: 0.14),
										),
										boxShadow: [
											BoxShadow(
												color: AppColors.c0A0A0A.withValues(alpha: 0.05),
												blurRadius: 10.r,
												offset: Offset(0, 3.h),
											),
										],
									),
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Text(
												'Actions',
												style: TextFontStyle.textStyle16c14181FInter600,
											),
											UIHelper.verticalSpace(26.h),
											CustomButton(
												label: 'Start Conversation',
												onPressed: () {
                          
                        },
												height: 40.h,
                        width: 190.w,
												borderRadius: 12.r,
												color: AppColors.contractor_primary,
												textStyle: TextFontStyle.textStyle14c101828Inter500.copyWith(
                          color: AppColors.scaffoldColor,
                        ),
												leading: Icon(
														Icons.chat_bubble_outline_rounded,
														color: AppColors.scaffoldColor,
														size: 16.sp,
												),
											),
										],
									),
								),
							],
						),
					),
				),
			),
		);
	}

	String _formatRelativeDate(DateTime date) {
		final DateTime now = DateTime.now();
		final Duration difference = now.difference(date);
		if (difference.inDays <= 0) {
			return 'Today';
		}
		if (difference.inDays == 1) {
			return 'Yesterday';
		}
		if (difference.inDays < 7) {
			return '${difference.inDays} days ago';
		}
		return '${date.month}/${date.day}/${date.year}';
	}
}


class _InfoTile extends StatelessWidget {
	const _InfoTile({
		required this.icon,
		required this.label,
		required this.value,
	});

	final IconData icon;
	final String label;
	final String value;

	@override
	Widget build(BuildContext context) {
		return Container(
      height: 95.h,
      width: 100.w,
			padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
			decoration: BoxDecoration(
				color: AppColors.c6A7181.withValues(alpha: 0.10),
				borderRadius: BorderRadius.circular(12.r),
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Row(
						children: [
							Icon(icon, size: 14.sp, color: AppColors.c6A7181),
							UIHelper.horizontalSpace(5.w),
							Expanded(
								child: Text(
									label,
									maxLines: 1,
									// overflow: TextOverflow.ellipsis,
									style: TextFontStyle.textStyle10c6A7181Inter400,
								),
							),
						],
					),
					UIHelper.verticalSpace(8.h),
					Text(
						value,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
						style: TextStyle(
							fontSize: 14.sp,
							fontWeight: FontWeight.w500,
							// height: 1.24,
							color: AppColors.c14181F,
              height: 1.5,
						),
					),
				],
			),
		);
	}
}
