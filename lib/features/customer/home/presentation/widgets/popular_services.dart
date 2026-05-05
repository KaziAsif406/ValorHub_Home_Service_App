import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class PopularServicesSection extends StatelessWidget {
  const PopularServicesSection({super.key});

  static final List<_PopularServiceData> _services = [
    _PopularServiceData(
      title: 'Kitchen Services',
      imagePath: 'assets/images/home_popular_1.png',
    ),
    _PopularServiceData(
      title: 'Handyman Services',
      imagePath: 'assets/images/home_popular_2.png',
    ),
    _PopularServiceData(
      title: 'Bathroom Services',
      imagePath: 'assets/images/home_popular_3.png',
    ),
    _PopularServiceData(
      title: 'Roof Repair',
      imagePath: 'assets/images/home_popular_4.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Services',
            style: TextFontStyle.textStyle16c0A0A0AInter700,
          ),
          UIHelper.verticalSpace(16.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 
              1.2,
            ),
            itemCount: _services.length,
            itemBuilder: (context, index) {
              return _PopularServiceCard(service: _services[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _PopularServiceData {
  const _PopularServiceData({required this.title, required this.imagePath});

  final String title;
  final String imagePath;
}

class _PopularServiceCard extends StatelessWidget {
  const _PopularServiceCard({required this.service});

  final _PopularServiceData service;

  @override
  Widget build(BuildContext context) {
    return Container(
 
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.scaffoldColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16.r,
            offset: Offset(5.w, 10.h),
          )
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
            child: Image.asset(
              service.imagePath,
              width: double.infinity,
              height: 93.h,
              fit: BoxFit.cover,
            ),
          ),
          UIHelper.verticalSpace(8.h),
          Text(
            service.title,
            style: TextFontStyle.textStyle12c000000Inter600,
          ),
        ],
      ),
    );
    // return Stack(
    //   children: [
    //     ClipRRect(
    //       borderRadius: BorderRadius.circular(24.r),
    //       child: Image.asset(
    //         service.imagePath,
    //         width: double.infinity,
    //         height: 120.h,
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //     Positioned(
    //       bottom: 42,
    //       left: 3,
    //       right: 3,
    //       child: Container(
    //         width: double.infinity,
    //         height: 41.h,
    //         alignment: Alignment.center,
    //         padding: EdgeInsets.symmetric(horizontal: 12.w),
    //         decoration: BoxDecoration(
    //           color: AppColors.scaffoldColor,
    //           borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24.r), bottomRight: Radius.circular(24.r)),
    //           boxShadow: [
    //             BoxShadow(
    //               color: AppColors.c000000.withValues(alpha: 0.06),
    //               blurRadius: 16.r,
    //             ),
    //           ],
    //         ),
    //         child: Text(
    //           service.title,
    //           style: TextFontStyle.textStyle12c000000Inter600,
    //         ),
    //       ),
    //     )
    //   ],
    // );
  }
}

