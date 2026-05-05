import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

import 'widget/about_me_section.dart';
import 'widget/certifications_section.dart';
import 'widget/contact_information_section.dart';
import 'widget/professional_details_section.dart';
import 'widget/profile_header_card.dart';

class DashboardProfileSection extends StatelessWidget {
  const DashboardProfileSection({
    super.key,
    required this.profileName,
    required this.profileEmail,
    required this.onSignOut,
    this.professionalTitle = 'Professional',
    this.rating = 4.9,
    this.reviewCount = 127,
    this.isVerified = true,
    this.phone = '(555) 123-4567',
    this.serviceArea = 'New York, NY & Surrounding Areas',
    this.licenseNumber = 'GC-123456-NY',
    this.yearsOfExperience = 12,
    this.completedProjects = 186,
    this.aboutText =
        'Licensed general contractor with over 12 years of experience in residential and commercial construction. Specializing in bathroom and kitchen remodeling, carpentry, plumbing, and interior painting. Committed to delivering high-quality workmanship and exceptional customer service.',
    this.certifications = const [
      'General Liability Insurance',
      'Workers\' Compensation Insurance',
      'EPA Lead-Safe Certified',
      'OSHA Safety Certification',
    ],
  });

  final String profileName;
  final String profileEmail;
  final VoidCallback onSignOut;
  final String professionalTitle;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final String phone;
  final String serviceArea;
  final String licenseNumber;
  final int yearsOfExperience;
  final int completedProjects;
  final String aboutText;
  final List<String> certifications;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeaderCard(
            profileName: profileName,
            professionalTitle: professionalTitle,
            rating: rating,
            reviewCount: reviewCount,
            isVerified: isVerified,
            onEditPressed: () {
              // Handle edit profile navigation
            },
          ),
          UIHelper.verticalSpace(16.h),
          ContactInformationSection(
            phone: phone,
            email: profileEmail,
            serviceArea: serviceArea,
          ),
          UIHelper.verticalSpace(16.h),
          ProfessionalDetailsSection(
            licenseNumber: licenseNumber,
            yearsOfExperience: yearsOfExperience,
            completedProjects: completedProjects,
          ),
          UIHelper.verticalSpace(16.h),
          AboutMeSection(
            aboutText: aboutText,
          ),
          UIHelper.verticalSpace(16.h),
          CertificationsSection(
            certifications: certifications,
          ),
          UIHelper.verticalSpace(24.h),
          // Sign out button at the bottom
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSignOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withValues(alpha: 0.1),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: const BorderSide(
                    color: Colors.red,
                    width: 1.5,
                  ),
                ),
              ),
              child: Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          UIHelper.verticalSpace(16.h),
        ],
      ),
    );
  }
}
