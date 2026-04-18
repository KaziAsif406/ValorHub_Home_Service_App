import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class ServiceCategoriesSection extends StatelessWidget {
  const ServiceCategoriesSection({super.key});

  static final List<_CategoryData> _categories = [
    _CategoryData(label: 'Plumbing', iconPath: 'assets/icons/plumbing.png'),
    _CategoryData(label: 'HVAC', iconPath: 'assets/icons/hvac.png'),
    _CategoryData(label: 'Roofing', iconPath: 'assets/icons/roofing.png'),
    _CategoryData(label: 'Electrical', iconPath: 'assets/icons/electrical.png'),
    _CategoryData(label: 'Cleaning', iconPath: 'assets/icons/cleaning.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Service Categories',
            style: TextFontStyle.textStyle16c0A0A0AInter700,
          ),
        ),
        UIHelper.verticalSpace(12.h),
        SizedBox(
          height: 100.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, __) => UIHelper.horizontalSpace(5.w),
            itemBuilder: (context, index) {
              return _CategoryTile(category: _categories[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryData {
  const _CategoryData({required this.label, required this.iconPath});

  final String label;
  final String iconPath;
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});

  final _CategoryData category;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            color: AppColors.cE54545.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Center(
            child: Image.asset(
              category.iconPath,
              width: 24.w,
              height: 24.h,
            ),
          ),
        ),
        UIHelper.verticalSpace(6.h),
        SizedBox(
          width: 80.w,
          child: Text(
            category.label,
            textAlign: TextAlign.center,
            style: TextFontStyle.textStyle12c0A0A0AInter400,
          ),
        ),
      ],
    );
  }
}
