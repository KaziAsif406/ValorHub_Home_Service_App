import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template_flutter/constants/app_constants.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
import 'package:template_flutter/features/customer/contractors/data/contractor_model.dart';
import 'package:template_flutter/features/customer/contractors/data/contractor_mapper.dart';

class ContractorProfileScreen extends StatelessWidget {
  const ContractorProfileScreen({super.key});

  // Real-time contractor stream from Firestore
  Stream<List<contractorData>> get contractorsStream {
    return FirebaseFirestore.instance
        .collection(kFirestoreUsersCollection)
        .where(kKeyUserType, isEqualTo: kUserTypeContractor)
        .snapshots()
        .map((QuerySnapshot snap) {
      return snap.docs.map((doc) => mapDocToContractor(doc)).whereType<contractorData>().toList();
    });
  }

  // Compatibility getter for existing synchronous consumers.
  static List<contractorData> get contractors => <contractorData>[];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 380.w),
          child: StreamBuilder<List<contractorData>>(
            stream: contractorsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final List<contractorData> list = snapshot.data ?? <contractorData>[];
              if (list.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Text(
                    'No contractors available yet.',
                    style: TextFontStyle.textStyle14c64748BInter400,
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return Column(
                children: list.map(_buildContractorCard).toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContractorCard(contractorData contractor) {
    return Container(
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
                    label: ' Profile',
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
                  height: 35.h,
                )
              ),
            ],
          ),
        ],
      ),
    );
  }

}
