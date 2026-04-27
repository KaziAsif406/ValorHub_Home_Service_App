import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/app_preferences.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    this.initialIndex = 0,
    this.initialName = '',
    this.initialEmail = '',
    this.initialImagePath,
  });

  final int initialIndex;
  final String initialName;
  final String initialEmail;
  final String? initialImagePath;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _savedImagePath;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _emailController.text = widget.initialEmail;
    if (widget.initialImagePath != null &&
        widget.initialImagePath!.isNotEmpty) {
      _savedImagePath = widget.initialImagePath;
      _selectedImage = File(widget.initialImagePath!);
    }
  }

  Future<void> _showPicker() async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFrom(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFrom(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFrom(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F7),
        elevation: 0,
        leading: IconButton(
          onPressed: () => NavigationService.goBack,
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.c14181F,
            size: 20.sp,
          ),
        ),
        title: Text(
          'Edit',
          style: TextFontStyle.textStyle24c0A0A0AInter700.copyWith(
            fontSize: 20.sp,
            color: AppColors.c14181F,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelper.verticalSpace(24.h),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.cD9D9D9,
                      ),
                      child: _selectedImage != null
                          ? ClipOval(
                              child: Image.file(
                                _selectedImage!,
                                // width: 120.w,
                                // height: 120.w,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'assets/icons/profile.png',
                              width: 100.w,
                              height: 100.h,
                              // fit: BoxFit.contain,
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          _showPicker();
                        },
                        child: Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.allSecondaryColor,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.c000000.withValues(alpha: 0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(7.w),
                            child: Image.asset(
                              'assets/icons/edit.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              UIHelper.verticalSpace(28.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      label: 'Name',
                      hintText: 'Enter your name',
                      controller: _nameController,
                    ),
                    UIHelper.verticalSpace(16.h),
                    CustomTextFormField(
                      label: 'Email',
                      hintText: 'Enter your email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    UIHelper.verticalSpace(16.h),
                    CustomTextFormField(
                      label: 'Number',
                      hintText: 'Enter your number',
                      controller: _numberController,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
              UIHelper.verticalSpace(24.h),
              CustomButton(
                label: 'Save',
                onPressed: () async {
                  final String? localImagePath =
                      await _saveImageToPermanentDirectory();

                  if (!mounted) {
                    return;
                  }

                  await AppPrefs.setProfileImagePath(localImagePath);

                  NavigationService.popAndReplaceWihArgs(
                    Routes.navigationScreen,
                    {
                      'initialIndex': 3,
                      'name': _nameController.text.trim(),
                      'email': _emailController.text.trim(),
                      'imagePath': localImagePath,
                    },
                  );
                },
                width: double.infinity,
                height: 40.h,
                textStyle: TextFontStyle.textStyle16cFFFFFFInter700,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _saveImageToPermanentDirectory() async {
    final File? imageFile = _selectedImage;

    if (imageFile == null) {
      return _savedImagePath;
    }

    if (_savedImagePath != null && _savedImagePath!.isNotEmpty) {
      final File existingFile = File(_savedImagePath!);
      if (existingFile.existsSync() && imageFile.path == existingFile.path) {
        return _savedImagePath;
      }
    }

    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final Directory profileDirectory = Directory(
        '${appDirectory.path}${Platform.pathSeparator}profile_images');
    if (!await profileDirectory.exists()) {
      await profileDirectory.create(recursive: true);
    }

    final String savedPath =
        '${profileDirectory.path}${Platform.pathSeparator}profile_image.jpg';
    await imageFile.copy(savedPath);
    _savedImagePath = savedPath;
    return savedPath;
  }
}
