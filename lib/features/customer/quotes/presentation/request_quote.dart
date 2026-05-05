import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:template_flutter/features/customer/quotes/data/quote_request_store.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class RequestQuote extends StatefulWidget {
  const RequestQuote({
    super.key,
    this.initialServiceCategory,
    this.initialContractorName,
    this.initialContractorId,
  });

  final String? initialServiceCategory;
  final String? initialContractorName;
  final String? initialContractorId;

  @override
  State<RequestQuote> createState() => _RequestQuoteState();
}

class _RequestQuoteState extends State<RequestQuote> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _serviceController.text = widget.initialServiceCategory ?? '';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _locationController.dispose();
    _zipController.dispose();
    _serviceController.dispose();
    _budgetController.dispose();
    _projectController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (widget.initialContractorId == null ||
        widget.initialContractorId!.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Missing contractor information. Please open the quote request from a contractor profile.'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Log current user id for debugging
      // ignore: avoid_print
      print('Current Firebase user: ${FirebaseAuth.instance.currentUser?.uid}');

      await QuoteRequestStore.instance.addRequest(
        fullName: _fullNameController.text,
        location: _locationController.text,
        zipCode: _zipController.text,
        budget: _budgetController.text,
        serviceCategory: _serviceController.text,
        projectDetails: _projectController.text,
        contractorId: widget.initialContractorId,
        contractorName: widget.initialContractorName,
        imagePaths: const <String>[],
      );

      NavigationService.navigateToReplacement(Routes.quoteSentScreen);
    } catch (e, st) {
      // Log error for diagnosis
      // ignore: avoid_print
      print('Quote submit failed: $e');
      // ignore: avoid_print
      print(st);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit request: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request a Quote',
          style: TextFontStyle.textStyle16c000000Inter700,
        ),
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              color: AppColors.c000000),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    label: 'Full Name',
                    hintText: 'Enter your full name',
                    controller: _fullNameController,
                    validator: _requiredValidator,
                  ),
                  UIHelper.verticalSpace(16.h),
                  CustomTextFormField(
                    label: 'Service Category',
                    hintText: 'Write the type of service needed',
                    controller: _serviceController,
                    validator: _requiredValidator,
                  ),
                  UIHelper.verticalSpace(16.h),
                  CustomTextFormField(
                    label: 'Location',
                    hintText: 'Area, City ...',
                    keyboardType: TextInputType.text,
                    controller: _locationController,
                    validator: _requiredValidator,
                  ),
                  UIHelper.verticalSpace(16.h),
                  CustomTextFormField(
                    label: 'Zip Code',
                    hintText: '75001',
                    keyboardType: TextInputType.number,
                    controller: _zipController,
                    validator: _requiredValidator,
                  ),
                  UIHelper.verticalSpace(16.h),
                  CustomTextFormField(
                    label: 'Budget',
                    hintText: 'e.g. \$500 - \$1000',
                    controller: _budgetController,
                    validator: _requiredValidator,
                  ),
                  UIHelper.verticalSpace(24.h),
                  CustomTextFormField(
                    label: 'Project Details',
                    hintText: 'Describe your project...',
                    maxLines: 5,
                    controller: _projectController,
                    validator: _requiredValidator,
                  ),
                  UIHelper.verticalSpace(16.h),
                  Text(
                    'Upload Images (Optional)',
                    style: TextFontStyle.textStyle14c14181FInter500,
                  ),
                  SizedBox(height: 8.h),
                  DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      color: AppColors.c6A7181.withValues(alpha: 0.3),
                      strokeWidth: 2,
                      dashPattern: [6, 4],
                      radius: Radius.circular(12.r),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 136.h,
                      padding: EdgeInsets.symmetric(vertical: 32.h),
                      decoration: const BoxDecoration(
                        color: AppColors.allSecondaryColor,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons/upload.png',
                            width: 24.w,
                            height: 24.h,
                          ),
                          UIHelper.verticalSpace(8.h),
                          Text(
                            'Tap to upload photos',
                            style: TextFontStyle.textStyle12c6A7181Inter500,
                          ),
                          UIHelper.verticalSpace(4.h),
                          Text(
                            'PNG, JPG up to 10MB',
                            style: TextFontStyle.textStyle10c6A7181Inter500,
                          ),
                        ],
                      ),
                    ),
                  ),
                  UIHelper.verticalSpace(16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        width: 152.w,
                        height: 34.h,
                        label: 'Cancel',
                        onPressed: () => Navigator.pop(context),
                        isOutlined: true,
                      ),
                      UIHelper.horizontalSpace(8.w),
                      CustomButton(
                        width: 152.w,
                        height: 34.h,
                        label: _isSubmitting ? 'Submitting...' : 'Submit Request',
                        onPressed: _isSubmitting ? null : _onSubmit,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  void _onSubmit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _submit();
  }
}
