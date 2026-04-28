import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class InboxHeader extends StatelessWidget {
	const InboxHeader({
		super.key,
		required this.name,
		required this.service,
		required this.isOnline,
		required this.initials,
		required this.onBack,
		this.onCall,
		this.onMore,
	});

	final String name;
	final String service;
	final bool isOnline;
	final String initials;
	final VoidCallback onBack;
	final VoidCallback? onCall;
	final VoidCallback? onMore;

	@override
	Widget build(BuildContext context) {
		return Container(
			color: AppColors.scaffoldColor,
			padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
			child: Row(
				children: [
					InkWell(
						borderRadius: BorderRadius.circular(24.r),
						onTap: onBack,
						child: Padding(
							padding: EdgeInsets.all(6.w),
							child: Image.asset(
								'assets/icons/back.png',
								width: 20.w,
								height: 20.h,
							),
						),
					),
					UIHelper.horizontalSpace(12.w),
					Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6E7ED),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  initials,
                  style: TextFontStyle.textStyle14cBE1E2DInter700,
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
								Text(
									name,
									maxLines: 1,
									overflow: TextOverflow.ellipsis,
									style: TextFontStyle.textStyle16c14181FInter600,
								),
								UIHelper.verticalSpace(2.h),
								Text(
									'${isOnline ? 'Online' : 'Offline'} - $service',
									maxLines: 1,
									overflow: TextOverflow.ellipsis,
									style: TextFontStyle.textStyle13c64748BInter400,
								),
							],
						),
					),
					UIHelper.horizontalSpace(8.w),
					InkWell(
						borderRadius: BorderRadius.circular(24.r),
						onTap: onCall,
						child: Padding(
							padding: EdgeInsets.all(6.w),
							child: Image.asset(
								'assets/icons/phone.png',
								width: 20.w,
								height: 20.h,
							),
						),
					),
          UIHelper.horizontalSpace(12.w),
					InkWell(
						borderRadius: BorderRadius.circular(24.r),
						onTap: onMore,
						child: Padding(
							padding: EdgeInsets.all(6.w),
							child: Icon(
								Icons.more_vert,
								color: AppColors.c6A7181,
								size: 24.sp,
							),
						),
					),
				],
			),
		);
	}
}
