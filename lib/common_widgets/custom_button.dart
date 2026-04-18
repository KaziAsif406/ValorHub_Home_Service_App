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
    this.enabled = true,
    this.leading,
    this.trailing,
    this.isOutlined = false,
    this.borderColor = AppColors.allPrimaryColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final double borderRadius;
  final Color color;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final bool enabled;
  final Widget? leading;
  final Widget? trailing;
  final bool isOutlined;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final bgColor = enabled
        ? (isOutlined ? AppColors.scaffoldColor : color)
        : AppColors.cE8E8E8;
    final border =
        isOutlined ? Border.all(color: borderColor, width: 1.5.w) : null;
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
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(borderRadius.r),
          child: Ink(
            decoration: BoxDecoration(
              color: bgColor,
              border: border,
              borderRadius: BorderRadius.circular(borderRadius.r),
              boxShadow: enabled
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Padding(
              padding: padding ?? EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (leading != null) ...[
                    leading!,
                    SizedBox(width: 10.w),
                  ],
                  Text(label, style: labelStyle),
                  if (trailing != null) ...[
                    SizedBox(width: 10.w),
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
