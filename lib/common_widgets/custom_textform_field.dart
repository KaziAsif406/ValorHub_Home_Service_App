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
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.minLines,
    this.contentPadding,
    this.focusNode,
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
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final int maxLines;
  final int? minLines;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;

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
          if (widget.label != null && widget.label!.isNotEmpty) ...[
            Text(
              widget.label!,
              style:
                  widget.labelStyle ?? TextFontStyle.textStyle14c14181FInter500,
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
            decoration: InputDecoration(
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
                      ))
                  : widget.suffixIcon,
              contentPadding: widget.contentPadding ??
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              filled: true,
              fillColor: AppColors.cF8FAFC,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: AppColors.c808080,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.c808080.withValues(alpha: 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.c808080.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: AppColors.c808080,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              errorStyle: TextStyle(
                fontSize: 12.sp,
                color: Colors.red,
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
