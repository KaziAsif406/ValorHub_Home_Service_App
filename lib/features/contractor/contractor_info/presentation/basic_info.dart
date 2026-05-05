import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
import 'package:template_flutter/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({
    super.key,
    this.contractorName,
    this.contractorEmail,
  });

  final String? contractorName;
  final String? contractorEmail;

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final TextEditingController _serviceCategoryController =
      TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  final AuthService _auth = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _serviceCategoryController.dispose();
    _experienceController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final String serviceCategory = _serviceCategoryController.text.trim();
    final String experienceText = _experienceController.text.trim();
    final String city = _cityController.text.trim();
    final String state = _stateController.text.trim();
    final String zipCode = _zipCodeController.text.trim();
    final String mobileNumber = _mobileNumberController.text.trim();

    if (serviceCategory.isEmpty ||
        experienceText.isEmpty ||
        city.isEmpty ||
        state.isEmpty ||
        zipCode.isEmpty ||
        mobileNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields.')),
      );
      return;
    }

    final int? experienceYears = int.tryParse(experienceText);
    if (experienceYears == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid number of years.')),
      );
      return;
    }

    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String? userId = currentUser?.uid;
    final String name = widget.contractorName?.trim().isNotEmpty == true
        ? widget.contractorName!.trim()
        : currentUser?.displayName?.trim().isNotEmpty == true
            ? currentUser!.displayName!.trim()
            : '';
    final String email = widget.contractorEmail?.trim().isNotEmpty == true
        ? widget.contractorEmail!.trim()
        : currentUser?.email?.trim().isNotEmpty == true
            ? currentUser!.email!.trim()
            : '';

    if (userId == null || name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please sign up again so your account can be completed.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _auth.saveContractorBasicInfo(
        userId: userId,
        name: name,
        email: email,
        serviceCategory: serviceCategory,
        experienceYears: experienceYears,
        city: city,
        state: state,
        zipCode: zipCode,
        mobileNumber: mobileNumber,
      );
      await _auth.signOut();
      if (!mounted) return;

      NavigationService.navigateToReplacementWithArgs(
        Routes.loginScreen,
        <String, dynamic>{
          'message': 'Profile saved. Check your email to verify your account.',
        },
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Complete Contractor Profile',
                    style: TextFontStyle.textStyle24c0A0A0AInter700.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                UIHelper.verticalSpace(8.h),
                Center(
                  child: Text(
                    'Add the details customers will see on your profile.',
                    style: TextFontStyle.textStyle14c64748BInter400,
                    textAlign: TextAlign.center,
                  ),
                ),
                UIHelper.verticalSpace(40.h),
                CustomTextFormField(
                  label: 'Service Category',
                  labelStyle: TextFontStyle.textStyle15c0A0A0AInter400,
                  hintText: 'Select your service category',
                  keyboardType: TextInputType.text,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  controller: _serviceCategoryController,
                ),
                UIHelper.verticalSpace(24.h),
                CustomTextFormField(
                  label: 'Years of Experience',
                  labelStyle: TextFontStyle.textStyle15c0A0A0AInter400,
                  hintText: 'Enter your years of experience',
                  keyboardType: TextInputType.number,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  controller: _experienceController,
                ),
                UIHelper.verticalSpace(24.h),
                CustomTextFormField(
                  label: 'City',
                  labelStyle: TextFontStyle.textStyle15c0A0A0AInter400,
                  hintText: 'Enter your city',
                  keyboardType: TextInputType.text,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  controller: _cityController,
                ),
                UIHelper.verticalSpace(24.h),
                CustomTextFormField(
                  label: 'State',
                  labelStyle: TextFontStyle.textStyle15c0A0A0AInter400,
                  hintText: 'Enter your state',
                  keyboardType: TextInputType.text,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  controller: _stateController,
                ),
                UIHelper.verticalSpace(24.h),
                CustomTextFormField(
                  label: 'Zip Code',
                  labelStyle: TextFontStyle.textStyle15c0A0A0AInter400,
                  hintText: 'Enter your zip code',
                  keyboardType: TextInputType.text,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  controller: _zipCodeController,
                ),
                UIHelper.verticalSpace(24.h),
                CustomTextFormField(
                  label: 'Mobile Number',
                  labelStyle: TextFontStyle.textStyle15c0A0A0AInter400,
                  hintText: 'Enter your mobile number',
                  keyboardType: TextInputType.phone,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  controller: _mobileNumberController,
                ),
                UIHelper.verticalSpace(24.h),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : CustomButton(
                        label: 'Submit',
                        onPressed: _submit,
                        height: 40.h,
                        borderRadius: 12.r,
                        width: double.infinity,
                        textStyle: TextFontStyle.textStyle16cFFFFFFInter700,
                      ),
                UIHelper.verticalSpace(32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
