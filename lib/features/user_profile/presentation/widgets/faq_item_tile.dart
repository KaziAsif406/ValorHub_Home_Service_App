import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/constants/text_font_style.dart';
import '/gen/colors.gen.dart';

class FaqItemTile extends StatelessWidget {
  const FaqItemTile({
    super.key,
    required this.question,
    required this.answer,
    required this.isExpanded,
    this.onTap,
  });

  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.all(14.w),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.c14181F.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: TextFontStyle.textStyle14c14181FInter500,
                    ),
                  ),
                  Transform.rotate(
                    angle: isExpanded ? 3.14 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.allPrimaryColor,
                      size: 16.sp,
                    ),
                  ),
                ],
              ),
              if (isExpanded) ...[
                SizedBox(height: 12.h),
                Text(
                  answer,
                  style: TextFontStyle.textStyle12c64748BInter400,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
