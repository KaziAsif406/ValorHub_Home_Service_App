import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';

class NotificationTile extends StatelessWidget {
	const NotificationTile({
		super.key,
		required this.iconPath,
		required this.title,
		required this.description,
		required this.time,
		required this.isRead,
		this.onTap,
	});

	final String iconPath;
	final String title;
	final String description;
	final String time;
	final bool isRead;
	final VoidCallback? onTap;

	@override
	Widget build(BuildContext context) {
		final Color cardColor = isRead
				? AppColors.allSecondaryColor
				: AppColors.allPrimaryColor.withValues(alpha: 0.05);
		final Color iconBackground = isRead
				? AppColors.cF3F4F6
				: AppColors.allPrimaryColor.withValues(alpha: 0.10);
		final Color titleColor = isRead ? AppColors.c14181F : AppColors.c14181F;
		final Color bodyColor = isRead ? AppColors.c6A7181 : AppColors.c6A7181;
		final Color timeColor = AppColors.c6A7181;

		return Material(
			color: Colors.transparent,
			child: InkWell(
				borderRadius: BorderRadius.circular(12.r),
				onTap: onTap,
				child: Container(
					padding: EdgeInsets.all(16.w),
					decoration: BoxDecoration(
						color: cardColor,
						borderRadius: BorderRadius.circular(12.r),
					),
					child: Row(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Container(
								width: 36.w,
								height: 36.w,
								decoration: BoxDecoration(
									color: iconBackground,
									borderRadius: BorderRadius.circular(12.r),
								),
								child: Center(
									child: Image.asset(
										iconPath,
										width: 16.w,
										height: 16.w,
									),
								),
							),
							SizedBox(width: 12.w),
							Expanded(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Row(
											crossAxisAlignment: CrossAxisAlignment.center,
											children: [
												Expanded(
													child: Text(
														title,
														style: TextFontStyle.textStyle16c14181FInter600
																.copyWith(color: titleColor),
													),
												),
												SizedBox(width: 10.w),
												Text(
												  time,
												  style: TextFontStyle.textStyle10c6A7181Inter400
												    .copyWith(color: timeColor),
												),
												if (!isRead) ...[
													SizedBox(width: 12.w),
													Container(
														width: 8.w,
														height: 8.h,
														decoration: const BoxDecoration(
															color: AppColors.allPrimaryColor,
															shape: BoxShape.circle,
														),
													),
												],
											],
										),
										SizedBox(height: 2.h),
										Text(
											description,
											style: TextFontStyle.textStyle12c6A7181Inter400.copyWith(
												color: bodyColor,
												height: 1.45,
											),
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
