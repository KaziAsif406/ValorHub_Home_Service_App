import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class SurveyAnswerSelectorTile extends StatelessWidget {
	const SurveyAnswerSelectorTile({
		super.key,
		required this.label,
		required this.isSelected,
		required this.onTap,
	});

	final String label;
	final bool isSelected;
	final VoidCallback onTap;

	@override
	Widget build(BuildContext context) {
		return Material(
			color: Colors.transparent,
			borderRadius: BorderRadius.circular(16.r),
			child: InkWell(
				borderRadius: BorderRadius.circular(16.r),
				onTap: onTap,
				child: AnimatedContainer(
					duration: const Duration(milliseconds: 180),
					curve: Curves.easeOut,
					height: 45.h,
					padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
					decoration: BoxDecoration(
						color: isSelected ? AppColors.secondaryColor : AppColors.scaffoldColor,
						borderRadius: BorderRadius.circular(16.r),
						border: Border.all(
							color: isSelected
									? Colors.transparent
									: AppColors.cC9C3C3,
							width: 1.w,
						),
					),
					child: Row(
						children: [
							AnimatedContainer(
								duration: const Duration(milliseconds: 180),
								curve: Curves.easeOut,
								width: 16.w,
								height: 16.w,
								decoration: BoxDecoration(
									shape: BoxShape.circle,
									border: Border.all(
										color: isSelected
												? AppColors.allPrimaryColor
												: AppColors.cC9C3C3,
										width: 2.2.w,
									),
								),
								alignment: Alignment.center,
								child: Container(
									width: 8.w,
									height: 8.w,
									decoration: BoxDecoration(
										shape: BoxShape.circle,
										color: isSelected
												? AppColors.allPrimaryColor
												: Colors.transparent,
									),
								),
							),
							UIHelper.horizontalSpace(20.w),
							Expanded(
								child: Text(
									label,
									style: TextFontStyle.textStyle14c6A7181Inter400.copyWith(
                    fontSize: 15.sp,
                  ),
								),
							),
						],
					),
				),
			),
		);
	}
}
