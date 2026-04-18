import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/contractors/presentation/widgets/contractor_info.dart';
import 'package:template_flutter/features/contractors/presentation/widgets/contractor_filter_bottom_sheet.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';



class ContractorsScreen extends StatefulWidget {
  const ContractorsScreen({super.key});

  @override
  State<ContractorsScreen> createState() => _ContractorsScreenState();
}


class _ContractorsScreenState extends State<ContractorsScreen> {
  String _selectedCategory = 'All Services';
  String _selectedRating = 'Any Rating';

  Future<void> _showFilterBottomSheet() async {
    final selectedFilters = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.72,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.scaffoldColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            ),
            child: ContractorFilterBottomSheet(
              initialCategory: _selectedCategory,
              initialRating: _selectedRating,
            ),
          ),
        );
      },
    );

    if (selectedFilters != null) {
      setState(() {
        _selectedCategory = selectedFilters['category'] ?? _selectedCategory;
        _selectedRating = selectedFilters['rating'] ?? _selectedRating;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        elevation: 2,
        shadowColor: AppColors.c000000.withValues(alpha: 0.3),
        backgroundColor: AppColors.scaffoldColor,
        title: Text(
            'Contractors',
            style: TextFontStyle.textStyle16c14181FInter600.copyWith(
              height: 2.0.h,
            ),
          ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: AppColors.c14181F),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    height: 40.h,
                    hintText: 'Search contractors...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                UIHelper.horizontalSpace(8.w),
                InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: _showFilterBottomSheet,
                  child: Container(
                    height: 45.h,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.c000000.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Image(
                      image: const AssetImage('assets/icons/filter.png'),
                      height: 16.h,
                      width: 16.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, // 👈 important
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            child: ContractorProfileScreen()
          ),
        ),
      ),
    );
  }
}