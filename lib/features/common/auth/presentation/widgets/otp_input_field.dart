import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';

class OTPInputField extends StatefulWidget {
  final int otpLength;
  final ValueChanged<String>? onCompleted;
  final TextInputType keyboardType;

  const OTPInputField({
    super.key,
    this.otpLength = 4,
    this.onCompleted,
    this.keyboardType = TextInputType.number,
  });

  @override
  State<OTPInputField> createState() => _OTPInputFieldState();
}

class _OTPInputFieldState extends State<OTPInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(widget.otpLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _handleTextChange(String value, int index) {
    if (value.isNotEmpty) {
      // Keep only the last character (in case of paste)
      if (value.length > 1) {
        _controllers[index].text = value[value.length - 1];
        return;
      }

      // Move to next field
      if (index < widget.otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // All fields filled - call onCompleted
        _focusNodes[index].unfocus();
        String otp = _controllers.map((c) => c.text).join();
        widget.onCompleted?.call(otp);
      }
    }
  }

  void _handleBackspace(String value, int index) {
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String getOTP() {
    return _controllers.map((c) => c.text).join();
  }

  void clearOTP() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.otpLength,
        (index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: SizedBox(
            width: 45.w,
            height: 48.h,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              onChanged: (value) {
                _handleTextChange(value, index);
              },
              onSubmitted: (value) {
                _handleBackspace(value, index);
              },
              keyboardType: widget.keyboardType,
              textAlign: TextAlign.center,
              maxLength: 1,
              inputFormatters: widget.keyboardType == TextInputType.number
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : [],
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: AppColors.cF6F6F6,
                contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 9.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(
                    color: AppColors.cF4F4F5,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(
                    color: AppColors.cF4F4F5,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColors.c686868.withValues(alpha: 0.40),
                    width: 2,
                  ),
                ),
              ),
              style: TextFontStyle.textStyle24c0A0A0AInter700,
              cursorColor: AppColors.c686868,
              cursorHeight: 2.h,
              cursorWidth: 18.w,
              cursorOpacityAnimates: true,
            ),
          ),
        ),
      ),
    );
  }
}
