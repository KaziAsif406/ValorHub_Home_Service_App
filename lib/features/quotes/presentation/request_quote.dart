import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/quotes/data/quote_request_store.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class RequestQuote extends StatefulWidget {
  const RequestQuote({
    super.key,
    this.initialServiceCategory,
    this.initialContractorName,
  });

  final String? initialServiceCategory;
  final String? initialContractorName;

  @override
  State<RequestQuote> createState() => _RequestQuoteState();
}

class _RequestQuoteState extends State<RequestQuote> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _serviceController.text = widget.initialServiceCategory ?? '';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _zipController.dispose();
    _serviceController.dispose();
    _projectController.dispose();
    super.dispose();
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
                    label: 'Email',
                    hintText: 'Enter your email address',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: _emailValidator,
                  ),
                  UIHelper.verticalSpace(16.h),
                  CustomTextFormField(
                    label: 'Phone',
                    hintText: '(555) 123-4567',
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
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
                    label: 'Service Category',
                    hintText: 'Select a Service',
                    controller: _serviceController,
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
                        label: 'Submit Request',
                        onPressed: _onSubmit,
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

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final RegExp emailRegex = RegExp(r'^[\w\-.]+@([\w\-]+\.)+[a-zA-Z]{2,}');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }

    return null;
  }

  void _onSubmit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    QuoteRequestStore.instance.addRequest(
      fullName: _fullNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      zipCode: _zipController.text,
      serviceCategory: _serviceController.text,
      projectDetails: _projectController.text,
      contractorName: widget.initialContractorName,
      imagePaths: const <String>[],
    );

    NavigationService.navigateToReplacement(Routes.quoteSentScreen);
  }
}
