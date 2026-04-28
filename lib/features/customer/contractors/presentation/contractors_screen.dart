import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/customer/contractors/presentation/widgets/contractor_info.dart';
import 'package:template_flutter/features/customer/contractors/presentation/widgets/contractor_filter_bottom_sheet.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';



class ContractorsScreen extends StatefulWidget {
  ContractorsScreen({super.key, this.onBackToHome, this.filterCategory});

  final VoidCallback? onBackToHome;
  final String? filterCategory;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  State<ContractorsScreen> createState() => _ContractorsScreenState();
}


class _ContractorsScreenState extends State<ContractorsScreen> {
  late String _selectedCategory;
  late String _selectedRating;

  @override
  void initState() {
    super.initState();
    _selectedCategory = 'All Services';
    _selectedRating = 'Any Rating';
  }

  List<contractorData> get _filteredContractors {
    List<contractorData> contractors = ContractorProfileScreen.contractors;
    
    if (widget.filterCategory != null && widget.filterCategory!.isNotEmpty) {
      contractors = contractors
          .where((c) => c.service.toLowerCase() == widget.filterCategory!.toLowerCase())
          .toList();
    }
    
    return contractors;
  }

  void _handleBack() {
    if (widget.onBackToHome != null) {
      widget.onBackToHome!();
      return;
    }

    NavigationService.navigateTo(Routes.navigationScreen);
  }

  Future<void> _showFilterBottomSheet() async {
    widget._searchFocusNode.unfocus();

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
          onPressed: _handleBack,
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
                    focusNode: widget._searchFocusNode,
                  ),
                ),
                UIHelper.horizontalSpace(8.w),
                if (widget.filterCategory == null || widget.filterCategory!.isEmpty)
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
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 380.w),
                  child: Column(
                    children: _filteredContractors.map((contractor) => 
                      Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldColor,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20.r,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Image.asset(
                                    'assets/images/placeholder_image.jpeg',
                                    width: 64.w,
                                    height: 64.w,
                                  ),
                                ),
                                UIHelper.horizontalSpace(16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              contractor.name,
                                              style: TextFontStyle.textStyle14c14181FInter600,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                              vertical: 6.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.scaffoldColor.withValues(alpha: 0),
                                            ),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/icons/gold_star.png',
                                                  width: 14.w,
                                                  height: 14.h,
                                                ),
                                                UIHelper.horizontalSpace(2.w),
                                                Text(
                                                  contractor.rating.toStringAsFixed(1),
                                                  style: TextFontStyle.textStyle12c14181FInter600,
                                                ),
                                                Text(
                                                  ' (${contractor.reviews})',
                                                  style: TextFontStyle.textStyle12c6A7181Inter400,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      UIHelper.verticalSpace(2.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 1.5.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.allPrimaryColor.withValues(alpha: 0.10),
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                        child: Text(
                                          contractor.service,
                                          style: TextFontStyle.textStyle10cBE1E2DInter500.copyWith(
                                            color: AppColors.allPrimaryColor,
                                          ),
                                        ),
                                      ),
                                      UIHelper.verticalSpace(7.h),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/icons/location_pin.png',
                                            width: 12.w,
                                            height: 12.h,
                                          ),
                                          UIHelper.horizontalSpace(4.w),
                                          Text(
                                            contractor.location,
                                            style: TextFontStyle.textStyle12c6A7181Inter400,
                                          ),
                                          UIHelper.horizontalSpace(12.w),
                                          Image.asset(
                                            'assets/icons/clock.png',
                                            width: 12.w,
                                            height: 12.h,
                                          ),
                                          UIHelper.horizontalSpace(4.w),
                                          Text(
                                            '${contractor.experience} years',
                                            style: TextFontStyle.textStyle12c6A7181Inter400,
                                          ),
                                        ],
                                      ),
                                      UIHelper.verticalSpace(5.h),
                                      Text(
                                        contractor.description,
                                        style: TextFontStyle.textStyle12c6A7181Inter400.copyWith(height: 1.6),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            UIHelper.verticalSpace(12.h),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 34.h,
                                    child: CustomButton(
                                      label: 'View Profile',
                                      onPressed: () {
                                        NavigationService.navigateToWithObject(
                                          Routes.contractorProfileScreen,
                                          contractor,);
                                      },
                                      textStyle: TextFontStyle.textStyle12cBE1E2DInter600,
                                      borderRadius: 12.r,
                                      color: AppColors.scaffoldColor,
                                      isOutlined: true,
                                    ),
                                  ),
                                ),
                                UIHelper.horizontalSpace(8.w),
                                Expanded(
                                  child: CustomButton(
                                    label: 'Request Quote',
                                    onPressed: () {
                                      NavigationService.navigateToWithObject(
                                        Routes.requestQuoteScreen,
                                        contractor,);
                                    },
                                    textStyle: TextFontStyle.textStyle12cFFFFFFInter600,
                                    borderRadius: 12.r,
                                    height: 32.h,
                                  )
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}