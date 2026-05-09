import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';

class ContractorChatMessage {
	const ContractorChatMessage({
		required this.text,
		required this.time,
		required this.isMe,
    required this.lastMessage,
    required this.isSeen,
	});

	final String text;
	final String time;
	final bool isMe;
  final bool lastMessage;
  final bool isSeen;
}

class ContractorChatBubble extends StatefulWidget {
	const ContractorChatBubble({super.key, required this.message});

	final ContractorChatMessage message;

  @override
  State<ContractorChatBubble> createState() => _ContractorChatBubbleState();
}

class _ContractorChatBubbleState extends State<ContractorChatBubble> {
  bool showTime = false;

	@override
	Widget build(BuildContext context) {
		final isMe = widget.message.isMe;

		return GestureDetector(
      onTap: () {
        setState(() {
          showTime = !showTime;
        });
      },
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [

          /// TIME
          if (showTime)
            Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Center(
                child: Text(
                  widget.message.time,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

          /// BUBBLE
          Align(
            alignment:
                isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              // width: 0.82.sw,
              margin: isMe
                  ? widget.message.lastMessage
                      ? EdgeInsets.only(bottom: 4.h, left: 50.w)
                      : EdgeInsets.only(bottom: 14.h, left: 50.w)
                  : EdgeInsets.only(bottom: 14.h, right: 50.w),
              // EdgeInsets.only(bottom: 14.h),
              padding: EdgeInsets.fromLTRB(
                20.w,
                14.h,
                20.w,
                12.h,
              ),
              decoration: BoxDecoration(
                color: isMe
                    ? AppColors.contractor_primary
                    : AppColors.scaffoldColor,
                borderRadius: isMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(18.r),
                        topRight: Radius.circular(18.r),
                        bottomLeft: Radius.circular(18.r),
                        bottomRight: Radius.circular(0.r),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(18.r),
                        topRight: Radius.circular(18.r),
                        bottomLeft: Radius.circular(0.r),
                        bottomRight: Radius.circular(18.r),
                      ),
              ),
              child: Text(
                widget.message.text,
                style: (isMe
                        ? TextFontStyle
                            .textStyle18cFFFFFFInter400
                        : TextFontStyle
                            .textStyle18c14181FInter600)
                    .copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isMe && widget.message.lastMessage)
          Padding(
            padding: EdgeInsets.only(
              right: 4.w,
              // top: 6.h,
              bottom: 10.h,
            ),
            child: 
            Text(
              widget.message.isSeen
                  ? 'Seen'
                  : 'Sent',
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
	}
}

