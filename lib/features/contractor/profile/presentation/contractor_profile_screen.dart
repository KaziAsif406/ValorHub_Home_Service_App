import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:template_flutter/constants/app_constants.dart';

import 'widget/about_me_section.dart';
import 'widget/certifications_section.dart';
import 'widget/contact_information_section.dart';
import 'widget/professional_details_section.dart';
import 'widget/profile_header_card.dart';

class DashboardProfileSection extends StatefulWidget {
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
  State<DashboardProfileSection> createState() => _DashboardProfileSectionState();
}

class _DashboardProfileSectionState extends State<DashboardProfileSection> {
  Future<Map<String, dynamic>?> _fetchCurrentUserProfile() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return null;
      final doc = await FirebaseFirestore.instance
          .collection(kFirestoreUsersCollection)
          .doc(uid)
          .get();
      if (!doc.exists) return null;
      return doc.data();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchCurrentUserProfile(),
      builder: (context, snapshot) {
        final data = snapshot.data;

        final profileName = (data != null && data['displayName'] != null)
            ? data['displayName'] as String
            : widget.profileName;

        final professionalTitle = (data != null && data['service_category'] != null)
            ? data['service_category'] as String
            : widget.professionalTitle;

        final rating = widget.rating;
        final reviewCount = widget.reviewCount;
        final isVerified = widget.isVerified;

        final phone = (data != null && data['mobile_number'] != null)
            ? data['mobile_number'] as String
            : widget.phone;

        final email = (data != null && data['email'] != null)
            ? data['email'] as String
            : widget.profileEmail;

        final serviceArea = _buildServiceAreaFromData(data) ?? widget.serviceArea;

        final licenseNumber = (data != null && data['license_number'] != null)
            ? data['license_number'] as String
            : widget.licenseNumber;

        final yearsOfExperience = (data != null && data['experience_years'] != null)
            ? (data['experience_years'] is int
                ? data['experience_years'] as int
                : int.tryParse(data['experience_years'].toString()) ?? widget.yearsOfExperience)
            : widget.yearsOfExperience;

        final completedProjects = widget.completedProjects;

        final aboutText = (data != null && data['description'] != null)
            ? data['description'] as String
            : widget.aboutText;

        final certifications = widget.certifications;

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
                onEditPressed: () {},
              ),
              UIHelper.verticalSpace(16.h),
              ContactInformationSection(
                phone: phone,
                email: email,
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
              CustomButton(
                label: 'Sign Out',
                onPressed: widget.onSignOut,
                borderRadius: 12.r,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                color: AppColors.contractor_primary,
              ),
              UIHelper.verticalSpace(16.h),
            ],
          ),
        );
      },
    );
  }

  String? _buildServiceAreaFromData(Map<String, dynamic>? data) {
    if (data == null) return null;
    final city = data['city'] as String?;
    final state = data['state'] as String?;
    if (city != null && state != null) {
      return '$city, $state';
    }
    return data['service_area'] as String?;
  }
}
