import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';



class FindLocationScreen extends StatefulWidget {
  const FindLocationScreen({super.key});

  @override
  State<FindLocationScreen> createState() => _FindLocationScreenState();
}



class _FindLocationScreenState extends State<FindLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: AppColors.c14181F),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 20.h, right: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Compare quotes from top-rated Addition & Remodeling Contractors',
                  style: TextFontStyle.textStyle18c14181FInter600,
                  textAlign: TextAlign.center,
                ),
                UIHelper.verticalSpace(16.h),
                Text(
                  'Enter the location of your project',
                  style: TextFontStyle.textStyle12c6A7181Inter400,
                ),
                UIHelper.verticalSpace(24.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.c6A7181.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CustomTextFormField(
                            width: 225.w,
                            height: 42.h,
                            hintText: 'Zip code',
                          ),
                          UIHelper.horizontalSpace(12.w),
                          Container(
                            width: 42.w,
                            height: 42.h,
                            decoration: BoxDecoration(
                              color: AppColors.scaffoldColor,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/icons/locator.png',
                                width: 24.w,
                                height: 24.h,
                              ),
                            ),
                          )
                        ],
                      ),
                      UIHelper.verticalSpace(8.h),
                      CustomButton(
                        width: double.infinity,
                        label: 'Find Contractor',
                        onPressed: () {
                          NavigationService.navigateTo(Routes.contractorsScreen);
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}