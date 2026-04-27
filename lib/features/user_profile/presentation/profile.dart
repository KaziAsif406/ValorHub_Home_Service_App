import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/features/user_profile/presentation/widgets/analytics_card.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.name = 'Md Riyad',
    this.email = 'mdriyadpc11@gmail.com',
    this.imagePath,
  });

  final String name;
  final String email;
  final String? imagePath;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final Widget profileImage = _buildProfileImage();

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 24.h),
          child: Column(
            children: [
              Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.allPrimaryColor,
                    width: 4.w,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(1.w),
                  child: ClipOval(child: profileImage),
                ),
              ),
              UIHelper.verticalSpace(16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.name,
                    style: TextFontStyle.textStyle24c0A0A0AInter700,
                  ),
                  UIHelper.horizontalSpace(8.w),
                  GestureDetector(
                    onTap: () {
                      NavigationService.navigateToWithArgs(
                        Routes.editProfileScreen,
                        {
                          'name': widget.name,
                          'email': widget.email,
                          'imagePath': widget.imagePath,
                        },
                      );
                    },
                    child: Image.asset(
                      'assets/icons/edit.png',
                      width: 16.w,
                      height: 16.h,
                    ),
                  ),
                ],
              ),
              UIHelper.verticalSpace(10.h),
              Text(
                widget.email,
                style: TextFontStyle.textStyle14c6A7181Inter400,
              ),
              UIHelper.verticalSpace(24.h),
              Row(
                children: [
                  Expanded(
                    child: AnalyticsCard(
                      title: 'Favorites',
                      value: '5',
                    ),
                  ),
                  UIHelper.horizontalSpace(10.w),
                  Expanded(
                    child: AnalyticsCard(
                      title: 'Total Requests',
                      value: '12',
                    ),
                  ),
                  UIHelper.horizontalSpace(10.w),
                  Expanded(
                    child: AnalyticsCard(
                      title: 'Pending',
                      value: '3',
                    ),
                  ),
                ],
              ),
              UIHelper.verticalSpace(18.h),
              _ProfileActionCard(
                children: [
                  _ProfileActionRow(
                    title: 'Change Password',
                    textColor: AppColors.c6B7280,
                    iconColor: AppColors.c6B7280,
                    imagePath: 'assets/icons/shield.png',
                    onTap: () {
                      NavigationService.navigateTo(Routes.resetInsidePassword);
                    },
                  ),
                  UIHelper.verticalSpace(10.h),
                  _ProfileActionRow(
                    title: 'Contact Us',
                    textColor: AppColors.c6B7280,
                    iconColor: AppColors.c6B7280,
                    imagePath: 'assets/icons/contact_us.png',
                    onTap: () {
                      NavigationService.navigateTo(Routes.contactUsScreen);
                    },
                  ),
                  UIHelper.verticalSpace(10.h),
                  _ProfileActionRow(
                    title: 'My Requests',
                    textColor: AppColors.c6B7280,
                    iconColor: AppColors.c6B7280,
                    imagePath: 'assets/icons/quote.png',
                    onTap: () {
                      NavigationService.navigateTo(Routes.contactUsScreen);
                    },
                  ),
                  UIHelper.verticalSpace(10.h),
                  _ProfileActionRow(
                    title: 'Saved Contractors',
                    textColor: AppColors.c6B7280,
                    iconColor: AppColors.c6B7280,
                    imagePath: 'assets/icons/heart.png',
                    onTap: () {
                      NavigationService.navigateTo(Routes.savedContractorsScreen);
                    },
                  ),
                  UIHelper.verticalSpace(10.h),
                  _ProfileActionRow(
                    title: 'FAQ',
                    textColor: AppColors.c6B7280,
                    iconColor: AppColors.c6B7280,
                    imagePath: 'assets/icons/faq.png',
                    onTap: () {
                      NavigationService.navigateTo(Routes.faqScreen);
                    },
                  ),
                ],
              ),
              UIHelper.verticalSpace(14.h),
              _ProfileActionCard(
                children: [
                  _ProfileActionRow(
                    title: 'Delete Account',
                    imagePath: 'assets/icons/delete.png',
                    iconColor: AppColors.allPrimaryColor,
                    textColor: AppColors.allPrimaryColor,
                    onTap: () {
                      NavigationService.navigateToReplacement(Routes.signUpScreen);
                    },
                  ),
                  UIHelper.verticalSpace(10.h),
                  _ProfileActionRow(
                    title: 'Log Out',
                    imagePath: 'assets/icons/logout.png',
                    iconColor: AppColors.allPrimaryColor,
                    textColor: AppColors.allPrimaryColor,
                    onTap: () {
                      NavigationService.navigateToReplacement(Routes.loginScreen);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    final String? imagePath = widget.imagePath;

    if (imagePath != null && imagePath.isNotEmpty) {
      final File file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
        );
      }
    }

    return Image.asset(
      'assets/icons/profile.png',
      height: 40.h,
      width: 40.w,
      // fit: BoxFit.contain,
    );
  }
}

class _ProfileActionCard extends StatelessWidget {
  const _ProfileActionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.c000000.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileActionRow extends StatelessWidget {
  const _ProfileActionRow({
    required this.title,
    required this.imagePath,
    required this.onTap,
    required this.iconColor,
    required this.textColor,
  });

  final String title;
  final String imagePath;
  final VoidCallback onTap;
  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 24.sp,
              height: 24.sp,
            ),
            UIHelper.horizontalSpace(16.w),
            Expanded(
              child: Text(
                title,
                style: TextFontStyle.textStyle14c14181FInter400.copyWith(
                  color: textColor,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 24.sp,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
