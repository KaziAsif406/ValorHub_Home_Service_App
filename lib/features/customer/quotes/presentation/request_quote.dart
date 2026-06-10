import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:template_flutter/features/customer/quotes/data/quote_request_store.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _pickedImages = <XFile>[];

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
          content: Text(
              'Missing contractor information. Please open the quote request from a contractor profile.'),
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

      final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

      // If there are images, show an uploading snackbar with progress (simulated)
      if (_pickedImages.isNotEmpty) {
        final int total = _pickedImages.length;
        for (int i = 0; i < total; i++) {
          final double progress = (i + 1) / total;
          messenger.hideCurrentSnackBar();
          messenger.showSnackBar(
            SnackBar(
              duration: const Duration(days: 1),
              content: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        value: progress, strokeWidth: 2),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                      child: Text(
                          'Uploading images... ${(progress * 100).toStringAsFixed(0)}%')),
                ],
              ),
            ),
          );

          // Simulate upload time per image. Replace with real upload logic if available.
          await Future<void>.delayed(const Duration(milliseconds: 400));
        }

        messenger.hideCurrentSnackBar();
        messenger
            .showSnackBar(const SnackBar(content: Text('Images uploaded')));
      }

      final List<String> imagePaths = _pickedImages.map((e) => e.path).toList();

      await QuoteRequestStore.instance.addRequest(
        fullName: _fullNameController.text,
        location: _locationController.text,
        zipCode: _zipController.text,
        budget: _budgetController.text,
        serviceCategory: _serviceController.text,
        projectDetails: _projectController.text,
        contractorId: widget.initialContractorId,
        contractorName: widget.initialContractorName,
        imagePaths: imagePaths,
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
                  GestureDetector(
                    onTap: _showImageSourceOptions,
                    child: DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        color: AppColors.c6A7181.withValues(alpha: 0.3),
                        strokeWidth: 2,
                        dashPattern: [6, 4],
                        radius: Radius.circular(12.r),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 136.h,
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 12.w),
                        decoration: const BoxDecoration(
                          color: AppColors.allSecondaryColor,
                        ),
                        child: _pickedImages.isEmpty
                            ? Center(
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
                                      style: TextFontStyle
                                          .textStyle12c6A7181Inter500,
                                    ),
                                    UIHelper.verticalSpace(4.h),
                                    Text(
                                      'PNG, JPG up to 10MB',
                                      style: TextFontStyle
                                          .textStyle10c6A7181Inter500,
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: 100.h,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _pickedImages.length,
                                      separatorBuilder: (_, __) =>
                                          SizedBox(width: 8.w),
                                      itemBuilder: (context, i) {
                                        final XFile img = _pickedImages[i];
                                        return Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              child: Image.file(
                                                File(img.path),
                                                width: 100.w,
                                                height: 100.h,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              right: 2,
                                              top: 2,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _pickedImages.removeAt(i);
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(Icons.close,
                                                      size: 18,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  UIHelper.verticalSpace(6.h),
                                  Text(
                                    '${_pickedImages.length} image(s) selected',
                                    style: TextFontStyle
                                        .textStyle12c6A7181Inter500,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  UIHelper.verticalSpace(16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomButton(
                          // width: 152.w,
                          height: 34.h,
                          label: 'Cancel',
                          onPressed: () => Navigator.pop(context),
                          isOutlined: true,
                        ),
                      ),
                      UIHelper.horizontalSpace(8.w),
                      Expanded(
                        child: CustomButton(
                          // width: 152.w,
                          height: 34.h,
                          label: _isSubmitting
                              ? 'Submitting...'
                              : 'Submit Request',
                          onPressed: _isSubmitting ? null : _onSubmit,
                        ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(22.h),
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

  void _showImageSourceOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _pickImagesFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImagesFromGallery() async {
    try {
      final List<XFile>? imgs = await _imagePicker.pickMultiImage();
      if (imgs == null || imgs.isEmpty) return;
      setState(() {
        _pickedImages.addAll(imgs);
      });
    } catch (e) {
      // ignore: avoid_print
      print('Gallery pick failed: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? img =
          await _imagePicker.pickImage(source: source, imageQuality: 80);
      if (img == null) return;
      setState(() {
        _pickedImages.add(img);
      });
    } catch (e) {
      // ignore: avoid_print
      print('Image pick failed: $e');
    }
  }
}
