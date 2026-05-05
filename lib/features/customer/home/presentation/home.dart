import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/constants/text_font_style.dart';
// import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/customer/home/presentation/widgets/home_header.dart';
import 'package:template_flutter/features/customer/home/presentation/widgets/popular_services.dart';
import 'package:template_flutter/features/customer/home/presentation/widgets/reviews.dart';
import 'package:template_flutter/features/customer/home/presentation/widgets/service_catagories.dart';
import 'package:template_flutter/features/customer/home/presentation/widgets/why_choose_us.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leadingWidth: 160.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Image.asset(
            'assets/icons/logo_home.png',
            height: 36.h,
            width: 140.w,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () {
                NavigationService.navigateTo(Routes.notificationScreen);
              },
              child: Image.asset(
                'assets/icons/notification.png',
                height: 25.h,
                width: 25.w,
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const HomeHeader(),
                UIHelper.verticalSpace(20.h),
                const ServiceCategoriesSection(),
                UIHelper.verticalSpace(24.h),
                const PopularServicesSection(),
                UIHelper.verticalSpace(10.h),
                const WhyChooseUsSection(),
                UIHelper.verticalSpace(24.h),
                const ReviewsSection(),
                UIHelper.verticalSpace(24.h),
                // const HomeActionButton(),
                CustomButton(
                  label: 'Find Contractor',
                  onPressed: () {
                    NavigationService.navigateToWithArgs(
                      Routes.navigationScreen,
                      {'initialIndex': 2},
                    );
                  },
                  textStyle: TextFontStyle.textStyle14cFFFFFFInter600,
                  borderRadius: 12.r,
                  width: 310.w,
                  // height: 56.h,
                ),
                UIHelper.verticalSpace(12.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
