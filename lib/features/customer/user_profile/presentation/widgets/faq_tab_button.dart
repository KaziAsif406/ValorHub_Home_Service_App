import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import '/gen/colors.gen.dart';

class FaqTabButton extends StatelessWidget {
  const FaqTabButton({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.allPrimaryColor : AppColors.cF4F4F5,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          label,
          style: TextFontStyle.textStyle12cFFFFFFInter600.copyWith(
            color: selected ? AppColors.cFFFBEB : AppColors.c333C4D,
          ),
        ),
      ),
    );
  }
}
