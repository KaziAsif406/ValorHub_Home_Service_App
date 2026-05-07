import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
// import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

// class ContractorChatComposer extends StatelessWidget {
// 	const ContractorChatComposer({
// 		super.key,
// 		required this.controller,
// 		this.onSend,
// 	});

// 	final TextEditingController controller;
// 	final VoidCallback? onSend;

// 	@override
// 	Widget build(BuildContext context) {
// 		return Container(
// 			decoration: BoxDecoration(
// 				color: AppColors.scaffoldColor,
// 				border: Border(
// 					top: BorderSide(
// 						color: AppColors.c000000.withValues(alpha: 0.08),
// 						width: 1,
// 					),
// 				),
// 			),
// 			padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
// 			child: SafeArea(
// 				top: false,
// 				child: Row(
// 					children: [
// 						InkWell(
// 							borderRadius: BorderRadius.circular(20.r),
// 							onTap: () {},
// 							child: Padding(
// 								padding: EdgeInsets.all(6.w),
// 								child: Image.asset(
// 									'assets/icons/attach.png',
// 									width: 18.w,
// 									height: 18.h,
// 								),
// 							),
// 						),
// 						UIHelper.horizontalSpace(8.w),
// 						InkWell(
// 							borderRadius: BorderRadius.circular(20.r),
// 							onTap: () {},
// 							child: Padding(
// 								padding: EdgeInsets.all(6.w),
// 								child: Image.asset(
// 									'assets/icons/emoji.png',
// 									width: 18.w,
// 									height: 18.h,
// 								),
// 							),
// 						),
// 						UIHelper.horizontalSpace(8.w),
// 						Expanded(
// 							child: CustomTextFormField(
//                 controller: controller,
//                 hintText: 'Type a message...',
//                 contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//               ),
// 						),
// 						UIHelper.horizontalSpace(8.w),
//             CustomButton(
//               width: 95.w,
//               label: 'Send',
//               onPressed: onSend,
//               height: 37.h,
//               padding: EdgeInsets.symmetric(horizontal: 16.w),
//               color: AppColors.contractor_primary,
//               leading: Image.asset(
//                 'assets/icons/send.png',
//                 width: 18.w,
//                 height: 18.h,
//               ),
//             )
// 					],
// 				),
// 			),
// 		);
// 	}
// }

class ContractorChatComposer extends StatefulWidget {
  const ContractorChatComposer({
    super.key,
    required this.controller,
    this.onSend,
  });

  final TextEditingController controller;
  final VoidCallback? onSend;

  @override
  State<ContractorChatComposer> createState() =>
      _ContractorChatComposerState();
}

class _ContractorChatComposerState
    extends State<ContractorChatComposer> {

  late FocusNode _focusNode;
  bool isFocused = false;
  bool _showLabel = true;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    _focusNode.addListener(() {
      final hasFocus = _focusNode.hasFocus;
      setState(() {
        isFocused = hasFocus;
        if (hasFocus) _showLabel = false;
      });

      // When losing focus, wait for the width animation to finish before
      // showing the label to avoid text appearing while the button is still
      // narrow and causing overflow.
      if (!hasFocus) {
        Future.delayed(const Duration(milliseconds: 60), () {
          if (mounted && !_focusNode.hasFocus) {
            setState(() {
              _showLabel = true;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

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
      padding: EdgeInsets.fromLTRB(
        14.w,
        14.h,
        14.w,
        14.h,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            /// HIDE ICONS WHEN FOCUSED
            if (!isFocused) ...[
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
            ] else ...[
              InkWell(
                borderRadius: BorderRadius.circular(20.r),
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: Image.asset(
                    'assets/icons/add.png',
                    width: 20.w,
                    height: 20.h,
                    color: AppColors.c636363.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
            /// EXPANDING TEXTFIELD
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                child: CustomTextFormField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  hintText: 'Type a message...',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
              ),
            ),
            UIHelper.horizontalSpace(8.w),
            /// ANIMATED SEND BUTTON
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: isFocused ? 47.w : 95.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: CustomButton(
                  label: _showLabel ? 'Send' : '',
                  gap: _showLabel,
                  onPressed: widget.onSend,
                  height: 37.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  color: AppColors.contractor_primary,
                  leading: Image.asset(
                    'assets/icons/send.png',
                    width: 18.w,
                    height: 18.h,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}