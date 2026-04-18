import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class WhyChooseUsSection extends StatelessWidget {
  const WhyChooseUsSection({super.key});

  static final List<_ReasonData> _reasons = [
    _ReasonData(
      iconPath: 'assets/icons/verified_red.png',
      title: 'Verified Pros',
      subtitle: 'Background-checked and licensed',
    ),
    _ReasonData(
      iconPath: 'assets/icons/rating.png',
      title: 'Top Ratings',
      subtitle: 'Highly rated by homeowners',
    ),
    _ReasonData(
      iconPath: 'assets/icons/trusted.png',
      title: 'Trusted',
      subtitle: 'Satisfaction guaranteed',
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
            'Why Choose Us',
            style: TextFontStyle.textStyle16c0A0A0AInter700,
          ),
          UIHelper.verticalSpace(12.h),
          Column(
            children: _reasons
                .map(
                  (reason) => _ReasonCard(reason: reason),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}

class _ReasonData {
  const _ReasonData(
      {required this.iconPath, required this.title, required this.subtitle});

  final String iconPath;
  final String title;
  final String subtitle;
}

class _ReasonCard extends StatelessWidget {
  const _ReasonCard({required this.reason});

  final _ReasonData reason;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16.r,
            offset: Offset(5.w, 10.h),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.allPrimaryColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Image.asset(reason.iconPath),
            ),
          ),
          UIHelper.horizontalSpace(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reason.title,
                  style: TextFontStyle.textStyle14c14181FInter600,
                ),
                UIHelper.verticalSpace(4.h),
                Text(
                  reason.subtitle,
                  style: TextFontStyle.textStyle12c6A7181Inter400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
