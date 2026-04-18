import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/features/contractors/presentation/contractors_screen.dart';
import 'package:template_flutter/features/contractors/presentation/saved_contractors.dart';
import 'package:template_flutter/features/home/presentation/home.dart';
import 'package:template_flutter/features/user_profile/presentation/profile.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({
    super.key,
    this.initialIndex = 0,
    this.profileName = 'Md Riyad',
    this.profileEmail = 'mdriyadpc11@gmail.com',
    this.profileImagePath,
  });

  final int initialIndex;
  final String profileName;
  final String profileEmail;
  final String? profileImagePath;

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late int _selectedIndex;

  static final List<_NavigationItem> _items = [
    _NavigationItem(icon: Icons.home_outlined, label: 'Home'),
    _NavigationItem(icon: Icons.favorite_border, label: 'Saved'),
    _NavigationItem(icon: Icons.list, label: 'List'),
    _NavigationItem(icon: Icons.person_outline, label: 'Profile'),
  ];

  late final List<Widget> _pages = [
    const HomeScreen(),
    const SavedContractorsScreen(),
    const ContractorsScreen(),
    ProfileScreen(
      name: widget.profileName,
      email: widget.profileEmail,
      imagePath: widget.profileImagePath,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, _pages.length - 1);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 10.h,
        bottom: MediaQuery.of(context).padding.bottom + 10.h,
      ),
      child: Row(
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final selected = index == _selectedIndex;
          return Expanded(
            flex: selected ? 2 : 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutQuart,
                height: 52.h,
                decoration: BoxDecoration(
                  color: selected ? AppColors.allPrimaryColor.withValues(alpha: 0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999.r),
                    onTap: () => _onItemTapped(index),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            item.icon,
                            size: 22.sp,
                            color: selected
                                ? AppColors.allPrimaryColor
                                : AppColors.c8E8E93,
                          ),
                          if (selected) ...[
                            UIHelper.horizontalSpace(8.w),
                            Expanded(
                              child: Text(
                                item.label,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.allPrimaryColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavigationItem {
  final IconData icon;
  final String label;

  const _NavigationItem({required this.icon, required this.label});
}
