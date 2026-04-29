// lib/common_widgets/custom_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/gen/colors.gen.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = 358,
    this.height = 42,
    this.borderRadius = 11,
    this.color = AppColors.allPrimaryColor,
    this.textStyle,
    this.padding,
    this.leading,
    this.trailing,
    this.isOutlined = false,
    this.borderColor = AppColors.allPrimaryColor,
    this.gap = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final double borderRadius;
  final Color color;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Widget? leading;
  final Widget? trailing;
  final bool isOutlined;
  final Color borderColor;
  final bool gap;

  @override
  Widget build(BuildContext context) {
    final bgColor = isOutlined ? AppColors.scaffoldColor : color;
    final border = isOutlined ? Border.all(color: borderColor, width: 1.5.w) : null;
    final labelStyle = textStyle ??
        TextStyle(
          color: isOutlined ? color : AppColors.scaffoldColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        );

    return SizedBox(
      height: height.h,
      width: width?.w,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius.r),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius.r),
          child: Ink(
            decoration: BoxDecoration(
              color: bgColor,
              border: border,
              borderRadius: BorderRadius.circular(borderRadius.r),
            ),
            child: Padding(
              padding: padding ?? EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (leading != null) ...[
                    leading!,
                    SizedBox(width: gap ? 10.w : 0),
                  ],
                  Text(label, style: labelStyle),
                  if (trailing != null) ...[
                    SizedBox(width: gap ? 10.w : 0),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
