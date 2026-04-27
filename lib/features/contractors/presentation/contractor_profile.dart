import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/contractors/presentation/widgets/contractor_info.dart';
import 'package:template_flutter/features/contractors/presentation/widgets/service_offered_tiles.dart';
import 'package:template_flutter/features/contractors/presentation/widgets/project_galary.dart';
import 'package:template_flutter/features/contractors/presentation/widgets/customer_reviews.dart';
import 'package:template_flutter/features/contractors/presentation/widgets/add_review.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
// import 'package:template_flutter/helpers/helper_methods.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class ContractorProfile extends StatefulWidget {
  final contractorData contractor;
  final bool isFavorite;

  const ContractorProfile({
    super.key,
    required this.contractor,
    this.isFavorite = false,
  });

  @override
  State<ContractorProfile> createState() => _ContractorProfileState();
}

class _ContractorProfileState extends State<ContractorProfile> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        title: Text(
          'Contractor Profile',
          style: TextFontStyle.textStyle16c14181FInter600,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.c14181F,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: AppColors.scaffoldColor.withValues(alpha: 0.00),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.c000000.withValues(alpha: 0.20),
                  width: 2,
                ),
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                icon: isFavorite
                    ? Image.asset(
                        'assets/icons/filled_heart.png',
                        width: 20.w,
                        height: 20.h,
                      )
                    : Image.asset(
                        'assets/icons/heart_outlined.png',
                        width: 20.w,
                        height: 20.h,
                      ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Contractor Header Info
            _buildContractorHeader(),
            // UIHelper.verticalSpace(16.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About Section
                  _buildAboutSection(),
                  UIHelper.verticalSpace(24.h),
            
                  // Services Offered Section
                  if (widget.contractor.service.isNotEmpty) ...[
                    Text(
                      'Services Offered',
                      style: TextFontStyle.textStyle16c14181FInter600,
                    ),
                    UIHelper.verticalSpace(8.h),
                    ServiceOfferedTiles(contractor: widget.contractor),
                    UIHelper.verticalSpace(16.h),
                  ],
            
                  // Project Gallery Section
                  Text(
                    'Project Gallery',
                    style: TextFontStyle.textStyle16c14181FInter600,
                  ),
                  UIHelper.verticalSpace(8.h),
                  ProjectGallery(contractor: widget.contractor),
                  UIHelper.verticalSpace(16.h),
            
                  // Customer Reviews Section
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Customer Reviews',
                          style: TextFontStyle.textStyle16c14181FInter600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showAddReviewDialog(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              size: 16.w,
                              color: AppColors.allPrimaryColor,
                            ),
                            UIHelper.horizontalSpace(4.w),
                            Text(
                              'Add Review',
                              style: TextFontStyle.textStyle12cBE1E2DInter500,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(8.h),
                  CustomerReviews(contractor: widget.contractor),
                  UIHelper.verticalSpace(24.h),

                  CustomButton(
                    height: 34.h,
                    label: 'Request Quote',
                    onPressed: () {
                      NavigationService.navigateTo(Routes.requestQuoteScreen);
                    },
                    textStyle: TextFontStyle.textStyle12cFFFFFFInter600,
                    borderRadius: 12.r,
                    padding: EdgeInsets.symmetric(vertical: 8.5.h),
                  ),

                  UIHelper.verticalSpace(12.h),
                  // Action Buttons
                  CustomButton(
                    height: 34.h,
                    label: 'Call Now',
                    onPressed: () {
                      // Handle call action
                    },
                    leading: Image.asset(
                      'assets/icons/call_red.png',
                      width: 20.w,
                      height: 16.h,
                    ),
                    textStyle: TextFontStyle.textStyle12cBE1E2DInter600,
                    borderRadius: 12.r,
                    padding: EdgeInsets.symmetric(vertical: 8.5.h),
                    isOutlined: true,
                  ),
                  UIHelper.verticalSpace(16.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContractorHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Image
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              image: const DecorationImage(
                image: AssetImage('assets/images/placeholder_image.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          UIHelper.verticalSpace(12.h),

          // Name
          Text(
            widget.contractor.name,
            style: TextFontStyle.textStyle18c14181FInter700,
          ),
          UIHelper.verticalSpace(3.5.h),

          // Service Badge and Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.contractor.location,
                style: TextFontStyle.textStyle14c6A7181Inter400,
              ),
              UIHelper.horizontalSpace(10.w),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.allPrimaryColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  widget.contractor.service,
                  style: TextFontStyle.textStyle12cBE1E2DInter500,
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(10.h),

          // Rating and Experience
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.scaffoldColor,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/gold_star.png',
                      width: 16.w,
                      height: 16.h,
                    ),
                    UIHelper.horizontalSpace(4.w),
                    Text(
                      widget.contractor.rating.toStringAsFixed(1),
                      style: TextFontStyle.textStyle14c14181FInter600,
                    ),
                    Text(
                      ' (${widget.contractor.reviews})',
                      style: TextFontStyle.textStyle12c6A7181Inter400,
                    ),
                  ],
                ),
              ),
              UIHelper.horizontalSpace(16.w),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.scaffoldColor,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/clock.png',
                      width: 14.w,
                      height: 14.h,
                    ),
                    UIHelper.horizontalSpace(4.w),
                    Text(
                      '${widget.contractor.experience} years exp.',
                      style: TextFontStyle.textStyle14c6A7181Inter400,
                    ),
                  ],
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(12.h),

          // Badges/Certifications
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBadge('Licensed Plumber', 
              AppColors.allPrimaryColor, 
              iconPath: 'assets/icons/verified_red.png'),

              _buildBadge('Insured & Bonded', 
              AppColors.c5BBE1E, 
              iconPath: 'assets/icons/verified_green.png'),


              _buildBadge('EPA Certified', 
              AppColors.cE7B008, 
              iconPath: 'assets/icons/certified.png'),
            ],
          ),
          UIHelper.verticalSpace(9.5.h),

          // Contact Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/phone.png',
                width: 16.w,
                height: 16.h,
              ),
              UIHelper.horizontalSpace(6.w),
              Text(
                '(555) 123-4567',
                style: TextFontStyle.textStyle13c64748BInter400,
              ),
              UIHelper.horizontalSpace(16.w),
              Image.asset(
                'assets/icons/mail.png',
                width: 16.w,
                height: 16.h,
              ),
              UIHelper.horizontalSpace(6.w),
              Text(
                'john@email.com',
                style: TextFontStyle.textStyle13c64748BInter400,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(
    String text, 
    Color color, {
    String? iconPath,
    }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(9999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconPath != null)
            Image.asset(
              iconPath,
              width: 12.w,
              height: 12.h,
            ),
          UIHelper.horizontalSpace(4.w),
          Text(
            text,
            style: TextFontStyle.textStyle10c000000Inter500.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: TextFontStyle.textStyle16c14181FInter600,
        ),
        UIHelper.verticalSpace(8.h),
        Text(
          widget.contractor.description,
          style: TextFontStyle.textStyle14c6A7181Inter400.copyWith(
            height: 1.6,
          ),
        ),
      ],
    );
  }
}