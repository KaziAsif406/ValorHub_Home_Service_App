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
  late Future<Map<String, dynamic>?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchCurrentUserProfile();
  }

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

  Future<void> _updateCurrentUserProfile(Map<String, dynamic> payload) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception('No signed-in user found.');
    }

    await FirebaseFirestore.instance
        .collection(kFirestoreUsersCollection)
        .doc(uid)
        .set(
      {
        ...payload,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  List<String> _extractCertifications(Map<String, dynamic>? data) {
    final dynamic raw = data?['certifications'];
    if (raw is List) {
      return raw
          .whereType<String>()
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return widget.certifications;
  }

  Future<void> _openEditProfileBottomSheet({
    required String phone,
    required String serviceArea,
    required int yearsOfExperience,
    required String aboutText,
    required List<String> certifications,
  }) async {
    final phoneController = TextEditingController(text: phone);
    final serviceAreaController = TextEditingController(text: serviceArea);
    final yearsController = TextEditingController(
      text: yearsOfExperience.toString(),
    );
    final aboutController = TextEditingController(text: aboutText);
    final certificationController = TextEditingController();
    final List<String> draftCertifications = List<String>.from(certifications);

    final bool? shouldSave = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 16.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 38.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    UIHelper.verticalSpace(14.h),
                    Text(
                      'Edit Profile Details',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.c0A0A0A,
                      ),
                    ),
                    UIHelper.verticalSpace(14.h),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                        
                      ),
                    ),
                    UIHelper.verticalSpace(12.h),
                    TextField(
                      controller: serviceAreaController,
                      decoration: const InputDecoration(
                        labelText: 'Service Area',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    UIHelper.verticalSpace(12.h),
                    TextField(
                      controller: yearsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Years of Experience',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    UIHelper.verticalSpace(12.h),
                    TextField(
                      controller: aboutController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'About Me',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    UIHelper.verticalSpace(12.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add Certification',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.c0A0A0A,
                          ),
                        ),
                        UIHelper.horizontalSpace(8.w),
                        IconButton(
                          onPressed: () {
                            final String value = certificationController.text.trim();
                            if (value.isEmpty) return;
                            setModalState(() {
                              draftCertifications.add(value);
                              certificationController.clear();
                            });
                          },
                          icon: const Icon(Icons.add_circle),
                          color: AppColors.contractor_primary,
                        ),
                      ],
                    ),
                    UIHelper.verticalSpace(10.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: draftCertifications
                          .map(
                            (cert) => Chip(
                              label: Text(cert),
                              deleteIcon: const Icon(Icons.close),
                              onDeleted: () {
                                setModalState(() {
                                  draftCertifications.remove(cert);
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                    UIHelper.verticalSpace(18.h),
                    CustomButton(
                      label: 'Save Changes',
                      onPressed: () => Navigator.of(modalContext).pop(true),
                      borderRadius: 12.r,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      color: AppColors.contractor_primary,
                    ),
                    UIHelper.verticalSpace(8.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (shouldSave != true) {
      return;
    }

    try {
      final int parsedYears = int.tryParse(yearsController.text.trim()) ?? yearsOfExperience;
      final String normalizedServiceArea = serviceAreaController.text.trim();
      final Map<String, dynamic> payload = {
        kKeyMobileNumber: phoneController.text.trim(),
        kKeyExperienceYears: parsedYears,
        kKeyDescription: aboutController.text.trim(),
        'service_area': normalizedServiceArea,
        'certifications': draftCertifications,
      };

      final List<String> areaParts = normalizedServiceArea
          .split(',')
          .map((part) => part.trim())
          .where((part) => part.isNotEmpty)
          .toList();
      if (areaParts.length >= 2) {
        payload[kKeyCity] = areaParts.first;
        payload[kKeyState] = areaParts[1];
      }

      await _updateCurrentUserProfile(payload);

      if (!mounted) return;
      setState(() {
        _profileFuture = _fetchCurrentUserProfile();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _profileFuture,
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

        final certifications = _extractCertifications(data);

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
                  _openEditProfileBottomSheet(
                    phone: phone,
                    serviceArea: serviceArea,
                    yearsOfExperience: yearsOfExperience,
                    aboutText: aboutText,
                    certifications: certifications,
                  );
                },
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
