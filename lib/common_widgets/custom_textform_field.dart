import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import '/gen/colors.gen.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.height,
    this.width,
    this.label,
    this.labelStyle,
    this.hintText,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.minLines,
    this.contentPadding,
    this.focusNode,
    this.enabled = true,
    this.textInputAction,
    this.errorMaxLines,
    this.isDense = false,
    this.borderRadius = 12,
    this.enabledBorderColor = AppColors.c808080,
    this.focusedBorderColor = AppColors.c808080,
    this.errorBorderColor = Colors.red,
    this.showLabelAboveField = true,
  });

  final String? label;
  final TextStyle? labelStyle;
  final double? height;
  final double? width;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final int maxLines;
  final int? minLines;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final bool enabled;
  final TextInputAction? textInputAction;
  final int? errorMaxLines;
  final bool isDense;
  final double borderRadius;
  final Color enabledBorderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final bool showLabelAboveField;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  double? get _effectiveHeight => widget.height?.h;
  double? get _effectiveWidth => widget.width?.w;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _effectiveHeight,
      width: _effectiveWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show label above field only if showLabelAboveField is true
          if (widget.showLabelAboveField &&
              widget.label != null &&
              widget.label!.isNotEmpty) ...[
            Text(
              widget.label!,
              style: widget.labelStyle ?? 
              TextFontStyle.textStyle14c14181FInter500,
            ),
            SizedBox(height: 8.h),
          ],
          TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            obscureText: _obscureText,
            onChanged: widget.onChanged,
            keyboardType: widget.keyboardType,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            minLines: widget.minLines,
            focusNode: widget.focusNode,
            enabled: widget.enabled,
            textInputAction: widget.textInputAction,
            decoration: InputDecoration(
              // Use label in decoration if showLabelAboveField is false
              label: !widget.showLabelAboveField && widget.label != null
                  ? Text(widget.label!)
                  : null,
              labelStyle: widget.labelStyle,
              hintText: widget.hintText,
              hintStyle: TextFontStyle.textStyle14c64748BInter400,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.obscureText
                  ? GestureDetector(
                      onTap: _toggleObscure,
                      child: Icon(
                        _obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20.w,
                        color: AppColors.c808080,
                      )
                    )
                  : GestureDetector(
                      onTap: () {
                        if (widget.suffixIcon != null) {
                          // Handle suffix icon tap
                          widget.onSuffixIconTap?.call();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.cF8FAFC.withValues(alpha: 0.0),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        height: 20.h,
                        width: 20.w,
                        padding: EdgeInsets.all(10.w),
                        child: widget.suffixIcon,
                        
                      ),
                    ),
              contentPadding: widget.contentPadding ??
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              errorMaxLines: widget.errorMaxLines,
              isDense: widget.isDense,
              filled: true,
              fillColor: AppColors.cF8FAFC,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius.r),
                borderSide: BorderSide(
                  color: widget.enabledBorderColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius.r),
                borderSide: BorderSide(
                  color: widget.enabledBorderColor.withValues(alpha: 0.2),
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius.r),
                borderSide: BorderSide(
                  color: widget.enabledBorderColor.withValues(alpha: 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius.r),
                borderSide: BorderSide(
                  color: widget.focusedBorderColor,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius.r),
                borderSide: BorderSide(
                  color: widget.errorBorderColor,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius.r),
                borderSide: BorderSide(
                  color: widget.errorBorderColor,
                  width: 1.5,
                ),
              ),
              errorStyle: TextStyle(
                fontSize: 12.sp,
                color: widget.errorBorderColor,
              ),
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.c000000,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
