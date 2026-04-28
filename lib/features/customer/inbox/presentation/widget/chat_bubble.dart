import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class ChatMessage {
	const ChatMessage({
		required this.text,
		required this.time,
		required this.isMe,
	});

	final String text;
	final String time;
	final bool isMe;
}

class ChatBubble extends StatelessWidget {
	const ChatBubble({super.key, required this.message});

	final ChatMessage message;

	@override
	Widget build(BuildContext context) {
		final isMe = message.isMe;

		return Align(
			alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
			child: Container(
				width: 0.82.sw,
				margin: EdgeInsets.only(bottom: 14.h),
				padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 12.h),
				decoration: BoxDecoration(
					color: isMe ? AppColors.allPrimaryColor : AppColors.scaffoldColor,
					borderRadius: isMe? BorderRadius.only(
						topLeft: Radius.circular(18.r),
						topRight: Radius.circular(18.r),
						bottomLeft: Radius.circular(18.r),
						bottomRight: Radius.circular(0.r) 
            ) 
            : BorderRadius.only(
            topLeft: Radius.circular(18.r),
            topRight: Radius.circular(18.r),
            bottomLeft: Radius.circular(0.r),
            bottomRight: Radius.circular(18.r),
					),
				),
				child: Column(
					crossAxisAlignment:
							isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
					children: [
						Text(
							message.text,
							style: (isMe
											? TextFontStyle.textStyle18cFFFFFFInter400
											: TextFontStyle.textStyle18c14181FInter600)
									.copyWith(
								fontSize: 14.sp,
								fontWeight: FontWeight.w500,
								height: 1.4,
							),
						),
						UIHelper.verticalSpace(8.h),
						Text(
							message.time,
							style: (isMe
											? TextFontStyle.textStyle16cFFFFFFInter500
											: TextFontStyle.textStyle16c64748BInter400)
									.copyWith(fontSize: 11.sp),
						),
					],
				),
			),
		);
	}
}

