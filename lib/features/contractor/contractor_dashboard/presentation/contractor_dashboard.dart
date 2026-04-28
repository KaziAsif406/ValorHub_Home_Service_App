import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
import 'package:template_flutter/services/auth_service.dart';

class ContractorDashboardScreen extends StatelessWidget {
  ContractorDashboardScreen({
    super.key,
    required this.profileName,
    required this.profileEmail,
  });

  final String profileName;
  final String profileEmail;
  final AuthService _auth = AuthService();

  Future<void> _signOut() async {
    await _auth.signOut();
    NavigationService.navigateToReplacement(Routes.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contractor Dashboard',
                style: TextFontStyle.textStyle24c0A0A0AInter700.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              UIHelper.verticalSpace(12.h),
              Text(
                profileName,
                style: TextFontStyle.textStyle18c0A0A0AInter700,
              ),
              UIHelper.verticalSpace(4.h),
              Text(
                profileEmail,
                style: TextFontStyle.textStyle14c64748BInter400,
              ),
              UIHelper.verticalSpace(24.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: AppColors.contractor_primary,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This dashboard is routed from Firestore user type.',
                      style: TextFontStyle.textStyle16cFFFFFFInter700,
                    ),
                    UIHelper.verticalSpace(8.h),
                    Text(
                      'Replace this screen with your production contractor dashboard when ready.',
                      style: TextFontStyle.textStyle14cFFFFFFInter400,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              CustomButton(
                label: 'Sign Out',
                onPressed: _signOut,
                height: 44.h,
                width: double.infinity,
                borderRadius: 12.r,
                color: AppColors.contractor_primary,
                textStyle: TextFontStyle.textStyle16cFFFFFFInter700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
