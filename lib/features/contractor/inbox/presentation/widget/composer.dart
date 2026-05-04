import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
// import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class ContractorChatComposer extends StatelessWidget {
	const ContractorChatComposer({
		super.key,
		required this.controller,
		this.onSend,
	});

	final TextEditingController controller;
	final VoidCallback? onSend;

	@override
	Widget build(BuildContext context) {
		return Container(
			decoration: BoxDecoration(
				color: AppColors.scaffoldColor,
				border: Border(
					top: BorderSide(
						color: AppColors.c000000.withValues(alpha: 0.08),
						width: 1,
					),
				),
			),
			padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
			child: SafeArea(
				top: false,
				child: Row(
					children: [
						InkWell(
							borderRadius: BorderRadius.circular(20.r),
							onTap: () {},
							child: Padding(
								padding: EdgeInsets.all(6.w),
								child: Image.asset(
									'assets/icons/attach.png',
									width: 18.w,
									height: 18.h,
								),
							),
						),
						UIHelper.horizontalSpace(8.w),
						InkWell(
							borderRadius: BorderRadius.circular(20.r),
							onTap: () {},
							child: Padding(
								padding: EdgeInsets.all(6.w),
								child: Image.asset(
									'assets/icons/emoji.png',
									width: 18.w,
									height: 18.h,
								),
							),
						),
						UIHelper.horizontalSpace(8.w),
						Expanded(
							child: CustomTextFormField(
                controller: controller,
                hintText: 'Type a message...',
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
						),
						UIHelper.horizontalSpace(8.w),
            CustomButton(
              width: 95.w,
              label: 'Send',
              onPressed: onSend,
              height: 37.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              color: AppColors.contractor_primary,
              leading: Image.asset(
                'assets/icons/send.png',
                width: 18.w,
                height: 18.h,
              ),
            )
					],
				),
			),
		);
	}
}