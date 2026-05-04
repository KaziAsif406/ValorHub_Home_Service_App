import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class ContractorFilterBottomSheet extends StatefulWidget {
  const ContractorFilterBottomSheet({
    super.key,
    required this.initialCategory,
    required this.initialRating,
  });

  final String initialCategory;
  final String initialRating;

  @override
  State<ContractorFilterBottomSheet> createState() =>
      _ContractorFilterBottomSheetState();
}

class _ContractorFilterBottomSheetState extends State<ContractorFilterBottomSheet> {
  static const List<String> _serviceCategories = [
    'All Services',
    'Electrical',
    'Plumbing',
    'Remodeling',
    'Roofing',
  ];

  static const List<String> _minimumRatings = [
    'Any Rating',
    '4.5+ Stars',
    '4.0+ Stars',
    '3.5+ Stars',
  ];

  late String _selectedCategory;
  late String _selectedRating;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _selectedRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Filters',
                      style: TextFontStyle.textStyle20c101828Inter700.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: AppColors.c6B7280,
                      size: 23.sp,
                    ),
                  ),
                ],
              ),
              UIHelper.verticalSpace(24.h),
              Text(
                'Service Category',
                style: TextFontStyle.textStyle14c101828Inter600.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              UIHelper.verticalSpace(8.h),
              ..._serviceCategories.map(
                (category) => _FilterOptionTile(
                  title: category,
                  isSelected: _selectedCategory == category,
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),
              ),
              UIHelper.verticalSpace(16.h),
              Text(
                'Minimum Rating',
                style: TextFontStyle.textStyle14c101828Inter600.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              UIHelper.verticalSpace(8.h),
              ..._minimumRatings.map(
                (rating) => _FilterOptionTile(
                  title: rating,
                  isSelected: _selectedRating == rating,
                  onTap: () {
                    setState(() {
                      _selectedRating = rating;
                    });
                  },
                ),
              ),
              UIHelper.verticalSpace(16.h),
              CustomButton(
                label: 'Apply Filters',
                onPressed: () {
                  Navigator.pop(
                    context,
                    {
                      'category': _selectedCategory,
                      'rating': _selectedRating,
                    },
                  );
                },
                width: double.infinity,
                height: 44.h,
                borderRadius: 12.r,
                textStyle: TextFontStyle.textStyle14cFFFFFFInter600,
              ),
              UIHelper.verticalSpace(8.h + bottomInset),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterOptionTile extends StatelessWidget {
  const _FilterOptionTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Container(
          height: 46.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: AppColors.scaffoldColor,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: AppColors.c686868.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 16.w,
                height: 16.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.allPrimaryColor
                      : AppColors.c686868.withValues(alpha: 0.3),
                ),
              ),
              UIHelper.horizontalSpace(12.w),
              Text(
                title,
                style: TextFontStyle.textStyle14c101828Inter500.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
