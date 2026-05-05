import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
// import 'package:template_flutter/helpers/helper_methods.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final TextEditingController _zipCodeController = TextEditingController();

  @override
  void dispose() {
    _zipCodeController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    final zipCode = _zipCodeController.text.trim();

    if (zipCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a zip code.')),
      );
      return;
    }

    NavigationService.navigateToWithArgs(
      Routes.locationSurveyScreen,
      {
        'category': '',
        'zipCode': zipCode,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.allSecondaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.c14181F.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      // padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 26.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/home_header.jpeg',
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: Container(
                  width: double.infinity,
                  height: 200.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.c000000.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 60.h,
                left: 20.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find a Trusted Service Professional',
                      style: TextFontStyle.textStyle20cFFFFFFInter700,
                    ),
                    UIHelper.verticalSpace(8.h),
                    Text(
                      'Get free quotes from top-rated contractors',
                      style: TextFontStyle.textStyle14cFFFFFFInter400
                          .copyWith(color: AppColors.scaffoldColor.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                CustomTextFormField(
                  hintText: 'What service do you need?',
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.c6A7181,
                    size: 20.sp,
                  )
                ),
                UIHelper.verticalSpace(8.h),
                Row(
                  children: [
                    Flexible(
                      child: CustomTextFormField(
                        controller: _zipCodeController,
                        hintText: 'Zip code',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    UIHelper.horizontalSpace(12.7.w),
                    CustomButton(
                      width: 88.w,
                      label: 'Search',
                      onPressed: _handleSearch,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
