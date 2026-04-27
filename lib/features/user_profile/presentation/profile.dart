import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/app_preferences.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/features/user_profile/presentation/widgets/analytics_card.dart';
import 'package:template_flutter/services/auth_service.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import 'widgets/profile_action_row.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.name = 'Md Riyad',
    this.email = 'mdriyadpc11@gmail.com',
    this.imagePath,
  });

  final String name;
  final String email;
  final String? imagePath;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _deletePasswordController = TextEditingController();

  @override
  void dispose() {
    _deletePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ImageProvider<Object>? profileImage = _buildProfileImage();

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 24.h),
          child: Column(
            children: [
              Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.allPrimaryColor,
                    width: 4.w,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(1.w),
                  child: CircleAvatar(
                    radius: 50.r,
                    backgroundImage: profileImage,
                  ),
                ),
              ),
              UIHelper.verticalSpace(16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.name,
                    style: TextFontStyle.textStyle24c0A0A0AInter700,
                  ),
                  UIHelper.horizontalSpace(8.w),
                  GestureDetector(
                    onTap: () {
                      NavigationService.navigateToWithArgs(
                        Routes.editProfileScreen,
                        {
                          'name': widget.name,
                          'email': widget.email,
                          'imagePath': widget.imagePath,
                        },
                      );
                    },
                    child: Image.asset(
                      'assets/icons/edit.png',
                      width: 16.w,
                      height: 16.h,
                    ),
                  ),
                ],
              ),
              UIHelper.verticalSpace(10.h),
              Text(
                widget.email,
                style: TextFontStyle.textStyle14c6A7181Inter400,
              ),
              UIHelper.verticalSpace(24.h),
              Row(
                children: [
                  Expanded(
                    child: AnalyticsCard(
                      title: 'Favorites',
                      value: '5',
                    ),
                  ),
                  UIHelper.horizontalSpace(10.w),
                  Expanded(
                    child: AnalyticsCard(
                      title: 'Total Requests',
                      value: '12',
                    ),
                  ),
                  UIHelper.horizontalSpace(10.w),
                  Expanded(
                    child: AnalyticsCard(
                      title: 'Pending',
                      value: '3',
                    ),
                  ),
                ],
              ),
              UIHelper.verticalSpace(18.h),
              _ProfileActionCard(
                children: [
                  ProfileActionRow(
                    title: 'Change Password',
                    textColor: AppColors.c6B7280,
                    iconColor: AppColors.c6B7280,
                    imagePath: 'assets/icons/shield.png',
                    onTap: () {
                      NavigationService.navigateTo(Routes.resetInsidePassword);
                    },
                  ),
                  UIHelper.verticalSpace(10.h),
                  ProfileActionRow(
                    title: 'Contact Us',
                    textColor: AppColors.c6B7280,
                    iconColor: AppColors.c6B7280,
                    imagePath: 'assets/icons/contact_us.png',
                    onTap: () {
                      NavigationService.navigateTo(Routes.contactUsScreen);
                    },
                  ),
                  UIHelper.verticalSpace(10.h),
                  ProfileActionRow(
                    title: 'My Requests',
                    textColor: AppColors.c6B7280,
                    iconColor: AppColors.c6B7280,
                    imagePath: 'assets/icons/quote.png',
                    onTap: () {
                      NavigationService.navigateTo(Routes.contactUsScreen);
                    },
                  ),
                  UIHelper.verticalSpace(10.h),
                  ProfileActionRow(
                    title: 'Saved Contractors',
                    textColor: AppColors.c6B7280,
                    iconColor: AppColors.c6B7280,
                    imagePath: 'assets/icons/heart.png',
                    onTap: () {
                      NavigationService.navigateTo(Routes.savedContractorsScreen);
                    },
                  ),
                  UIHelper.verticalSpace(10.h),
                  ProfileActionRow(
                    title: 'FAQ',
                    textColor: AppColors.c6B7280,
                    iconColor: AppColors.c6B7280,
                    imagePath: 'assets/icons/faq.png',
                    onTap: () {
                      NavigationService.navigateTo(Routes.faqScreen);
                    },
                  ),
                ],
              ),
              UIHelper.verticalSpace(14.h),
              _ProfileActionCard(
                children: [
                  ProfileActionRow(
                    title: 'Delete Account',
                    imagePath: 'assets/icons/delete.png',
                    iconColor: AppColors.allPrimaryColor,
                    textColor: AppColors.allPrimaryColor,
                    onTap: _showDeleteAccountDialog,
                  ),
                  UIHelper.verticalSpace(10.h),
                  ProfileActionRow(
                    title: 'Log Out',
                    imagePath: 'assets/icons/logout.png',
                    iconColor: AppColors.allPrimaryColor,
                    textColor: AppColors.allPrimaryColor,
                    onTap: _showLogoutDialog,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteAccountDialog() async {
    final BuildContext screenContext = context;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> deleteAccount() async {
              if (_deletePasswordController.text.trim().isEmpty) {
                ScaffoldMessenger.of(screenContext).showSnackBar(
                  const SnackBar(
                    content: Text('Enter your password to delete the account.'),
                  ),
                );
                return;
              }

              setState(() => isLoading = true);
              try {
                await _authService.deleteAccount(
                  password: _deletePasswordController.text.trim(),
                );
                await AppPrefs.setLoggedIn(false);
                if (mounted) {
                  Navigator.of(dialogContext).pop();
                  NavigationService.navigateToReplacement(Routes.signUpScreen);
                }
              } catch (error) {
                if (mounted) {
                  ScaffoldMessenger.of(screenContext).showSnackBar(
                    SnackBar(content: Text(error.toString())),
                  );
                }
              } finally {
                if (mounted) {
                  setState(() => isLoading = false);
                }
              }
            }

            return AlertDialog(
              title: const Text('Delete Account'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'This will permanently delete your account. Enter your password to confirm.',
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    controller: _deletePasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: isLoading ? null : deleteAccount,
                  child: isLoading
                      ? SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  Future<void> _showLogoutDialog() async {
    final BuildContext screenContext = context;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> logout() async {
              ScaffoldMessenger.of(screenContext).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully.'),
                ),
              );

              setState(() => isLoading = true);
              try {
                await AppPrefs.setLoggedIn(false);
                if (mounted) {
                  Navigator.of(dialogContext).pop();
                  NavigationService.navigateToReplacement(Routes.loginScreen);
                }
              } catch (error) {
                if (mounted) {
                  ScaffoldMessenger.of(screenContext).showSnackBar(
                    SnackBar(content: Text(error.toString())),
                  );
                }
              } finally {
                if (mounted) {
                  setState(() => isLoading = false);
                }
              }
            }

            return AlertDialog(
              title: const Text('Logout'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Are you sure you want to logout?',
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: isLoading ? null : logout,
                  child: isLoading
                      ? SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Logout'),
                ),
              ],
            );
          },
        );
      },
    );
  }

ImageProvider<Object>? _buildProfileImage() {
  final String? imagePath = widget.imagePath;

  if (imagePath != null && imagePath.isNotEmpty) {
    final File file = File(imagePath);
    if (file.existsSync()) {
      return FileImage(file);
    }
  }

  return const AssetImage('assets/icons/profile.png');
  }
}

class _ProfileActionCard extends StatelessWidget {
  const _ProfileActionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.c000000.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}
