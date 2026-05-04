import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';



class RequestQuote extends StatelessWidget {
  const RequestQuote({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request a Quote',
          style: TextFontStyle.textStyle16c000000Inter700,
        ),
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: AppColors.c000000),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, // 👈 important
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  label: 'Full Name',
                  hintText: 'Enter your full name',
                ),
                UIHelper.verticalSpace(16.h),
        
                CustomTextFormField(
                  label: 'Email',
                  hintText: 'Enter your email address',
                  keyboardType: TextInputType.emailAddress,
                ),
                UIHelper.verticalSpace(16.h),
        
                CustomTextFormField(
                  label: 'Phone',
                  hintText: '(555) 123-4567',
                  keyboardType: TextInputType.phone,
                ),
                UIHelper.verticalSpace(16.h),
        
                CustomTextFormField(
                  label: 'Zip Code',
                  hintText: '75001',
                  keyboardType: TextInputType.number,
                ),
                UIHelper.verticalSpace(16.h),
        
                CustomTextFormField(
                  label: 'Service Category',
                  hintText: 'Select a Service',
                ),
                UIHelper.verticalSpace(24.h),
                
                CustomTextFormField(
                  label: 'Project Details',
                  hintText: 'Describe your project...',
                  maxLines: 5,
                  
                ),
                UIHelper.verticalSpace(16.h),
        
        
                Text(
                  'Upload Images (Optional)',
                  style: TextFontStyle.textStyle14c14181FInter500,
                ),
                SizedBox(height: 8.h),
                DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    color: AppColors.c6A7181.withValues(alpha: 0.3),
                    strokeWidth: 2,
                    dashPattern: [6, 4], 
                    radius: Radius.circular(12.r),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 136.h,
                    padding: EdgeInsets.symmetric(vertical: 32.h),
                    decoration: BoxDecoration(
                      color: AppColors.allSecondaryColor,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icons/upload.png',
                          width: 24.w,
                          height: 24.h,
                        ),
                        UIHelper.verticalSpace(8.h),
                        Text(
                          'Tap to upload photos',
                          style: TextFontStyle.textStyle12c6A7181Inter500,
                        ),
                        UIHelper.verticalSpace(4.h),
                        Text(
                          'PNG, JPG up to 10MB',
                          style: TextFontStyle.textStyle10c6A7181Inter500,
                        ),
                      ],
                    ),
                  ),
                ),
                UIHelper.verticalSpace(16.h),
        
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      width: 152.w,
                      height: 34.h,
                      label: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                      isOutlined: true,
                    ),
        
                    UIHelper.horizontalSpace(8.w),
        
                    CustomButton(
                      width: 152.w,
                      height: 34.h,
                      label: 'Submit Request',
                      onPressed: () {
                        NavigationService.navigateToReplacement(Routes.quoteSentScreen);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}