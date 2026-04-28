import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/contractor/contractor_dashboard/presentation/contractor_dashboard.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class ContractorDashboardDrawer extends StatelessWidget {
  const ContractorDashboardDrawer({
    super.key,
    required this.profileName,
    required this.profileEmail,
    required this.selectedSection,
    required this.onSectionSelected,
    required this.onSignOut,
  });

  final String profileName;
  final String profileEmail;
  final ContractorDashboardSection selectedSection;
  final ValueChanged<ContractorDashboardSection> onSectionSelected;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.scaffoldColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.contractor_primary,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: Colors.white.withValues(alpha: 0.18),
                      child: Text(
                        _initials(profileName),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    UIHelper.verticalSpace(12.h),
                    Text(
                      profileName,
                      style: TextFontStyle.textStyle16cFFFFFFInter700,
                    ),
                    UIHelper.verticalSpace(4.h),
                    Text(
                      profileEmail,
                      style: TextFontStyle.textStyle12cFFFFFFInter600.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              UIHelper.verticalSpace(18.h),
              Text(
                'Menu',
                style: TextFontStyle.textStyle13c64748BInter400.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              UIHelper.verticalSpace(10.h),
              _DrawerTile(
                icon: Icons.dashboard_outlined,
                label: 'Dashboard',
                selected:
                    selectedSection == ContractorDashboardSection.overview,
                onTap: () =>
                    onSectionSelected(ContractorDashboardSection.overview),
              ),
              _DrawerTile(
                icon: Icons.inbox_outlined,
                label: 'Inbox',
                selected: selectedSection == ContractorDashboardSection.inbox,
                onTap: () =>
                    onSectionSelected(ContractorDashboardSection.inbox),
              ),
              _DrawerTile(
                icon: Icons.handyman_outlined,
                label: 'My services',
                selected:
                    selectedSection == ContractorDashboardSection.services,
                onTap: () =>
                    onSectionSelected(ContractorDashboardSection.services),
              ),
              _DrawerTile(
                icon: Icons.person_outline,
                label: 'Profile',
                selected: selectedSection == ContractorDashboardSection.profile,
                onTap: () =>
                    onSectionSelected(ContractorDashboardSection.profile),
              ),
              _DrawerTile(
                icon: Icons.star_outline,
                label: 'Reviews',
                selected: selectedSection == ContractorDashboardSection.reviews,
                onTap: () =>
                    onSectionSelected(ContractorDashboardSection.reviews),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onSignOut,
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Sign out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.contractor_primary,
                    side: const BorderSide(color: AppColors.contractor_primary),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _initials(String value) {
    final List<String> words = value
        .trim()
        .split(' ')
        .where((String part) => part.isNotEmpty)
        .toList();

    if (words.isEmpty) {
      return 'VH';
    }

    if (words.length == 1) {
      return words.first.characters.first.toUpperCase();
    }

    return (words.first.characters.first + words.last.characters.first)
        .toUpperCase();
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Material(
        color: selected
            ? AppColors.contractor_primary.withValues(alpha: 0.10)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14.r),
        child: ListTile(
          onTap: onTap,
          leading: Icon(
            icon,
            color: selected ? AppColors.contractor_primary : AppColors.c64748B,
          ),
          title: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color:
                  selected ? AppColors.contractor_primary : AppColors.c14181F,
            ),
          ),
          trailing: selected
              ? const Icon(Icons.chevron_right_rounded,
                  color: AppColors.contractor_primary)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      ),
    );
  }
}
