import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class ContractorChatOverviewTile extends StatelessWidget {
	const ContractorChatOverviewTile({
		super.key,
		required this.name,
		required this.serviceCategory,
		required this.lastMessage,
		required this.timeLabel,
		required this.initials,
		this.unreadCount = 0,
		this.isOnline = false,
		this.isSelected = false,
		this.onTap,
	});

	final String name;
	final String serviceCategory;
	final String lastMessage;
	final String timeLabel;
	final String initials;
	final int unreadCount;
	final bool isOnline;
	final bool isSelected;
	final VoidCallback? onTap;

	@override
	Widget build(BuildContext context) {
		return Material(
			color: Colors.transparent,
			child: InkWell(
				onTap: onTap,
				child: AnimatedContainer(
					duration: const Duration(milliseconds: 220),
					curve: Curves.easeOutCubic,
					padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
					decoration: BoxDecoration(
						color: isSelected
								? AppColors.contractor_secondary.withValues(alpha: 0.10)
								: Colors.transparent,
					),
					child: Row(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Stack(
								clipBehavior: Clip.none,
								children: [
									Container(
										width: 44.w,
										height: 44.h,
										alignment: Alignment.center,
										decoration: BoxDecoration(
											color: const Color(0xFFE6E7ED),
											shape: BoxShape.circle,
										),
										child: Text(
											initials,
											style: TextFontStyle.textStyle12cBE1E2DInter500.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.contractor_primary,
                      ),
										),
									),
									if (isOnline)
										Positioned(
											right: -1.w,
											bottom: -1.h,
											child: Container(
												width: 13.w,
												height: 13.h,
												decoration: BoxDecoration(
													color: const Color(0xFF2DB36A),
													shape: BoxShape.circle,
													border: Border.all(
														color: AppColors.scaffoldColor,
														width: 2.w,
													),
												),
											),
										),
								],
							),
							UIHelper.horizontalSpace(12.w),
							Expanded(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Row(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
												Expanded(
													child: Text(
														name,
														maxLines: 1,
														overflow: TextOverflow.ellipsis,
														style: TextFontStyle.textStyle14c14181FInter600,
													),
												),
												UIHelper.horizontalSpace(8.w),
												Text(
													timeLabel,
													style:
															TextFontStyle.textStyle12c6A7181Inter400.copyWith(
														fontSize: 12.sp,
													),
												),
                        UIHelper.horizontalSpace(12.w),
                        if (unreadCount > 0) ...[
													UIHelper.horizontalSpace(8.w),
													Container(
														constraints: BoxConstraints(minWidth: 20.w),
														height: 20.h,
														alignment: Alignment.center,
														padding: EdgeInsets.symmetric(horizontal: 6.w),
														decoration: const BoxDecoration(
															color: AppColors.contractor_primary,
															shape: BoxShape.circle,
														),
														child: Text(
															unreadCount > 99 ? '99+' : unreadCount.toString(),
															style: TextFontStyle.textStyle12cFFFFFFInter600,
														),
													),
												],
											],
										),
										UIHelper.verticalSpace(2.h),
										Text(
											serviceCategory,
											maxLines: 1,
											overflow: TextOverflow.ellipsis,
											style: TextFontStyle.textStyle13cBE1E2DInter400.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.contractor_primary,
                      ),
										),
										UIHelper.verticalSpace(2.h),
										Text(
											lastMessage,
											maxLines: 2,
											overflow: TextOverflow.ellipsis,
											style: TextFontStyle.textStyle12c6A7181Inter400,
										),
									],
								),
							),
						],
					),
				),
			),
		);
	}
}
