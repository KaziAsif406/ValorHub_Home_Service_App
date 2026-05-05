import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/features/customer/contractors/presentation/contractors_screen.dart';
import 'package:template_flutter/features/customer/home/presentation/home.dart';
import 'package:template_flutter/features/customer/inbox/presentation/chat_list.dart';
import 'package:template_flutter/features/customer/user_profile/presentation/profile.dart';
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
  late final PageController _pageController;

  static final List<_NavigationItem> _items = [
    _NavigationItem(
      filledAssetPath: 'assets/icons/nav_home_filled.png',
      outlinedAssetPath: 'assets/icons/nav_home_outlined.png',
      label: 'Home',
    ),
    _NavigationItem(
      filledAssetPath: 'assets/icons/nav_chat_filled.png',
      outlinedAssetPath: 'assets/icons/nav_chat_outlined.png',
      label: 'Inbox',
    ),
    _NavigationItem(
      filledAssetPath: 'assets/icons/nav_list_filled.png',
      outlinedAssetPath: 'assets/icons/nav_list_outlined.png',
      label: 'List',
    ),
    _NavigationItem(
      filledAssetPath: 'assets/icons/nav_profile_filled.png',
      outlinedAssetPath: 'assets/icons/nav_profile_outlined.png',
      label: 'Profile',
    ),
  ];

  late final List<Widget> _pages = [
    const HomeScreen(),
    ChatListScreen(onBackToHome: () => _onItemTapped(0)),
    ContractorsScreen(onBackToHome: () => _onItemTapped(0)),
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
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          if (_selectedIndex != index) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        children: _pages
            .map((page) => _KeepAlivePage(child: page))
            .toList(growable: false),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            selected
                                ? item.filledAssetPath
                                : item.outlinedAssetPath,
                            width: 22.sp,
                            height: 22.sp,
                            fit: BoxFit.contain,
                          ),
                          if (selected) ...[
                            UIHelper.horizontalSpace(8.w),
                            Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.allPrimaryColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
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
  final String filledAssetPath;
  final String outlinedAssetPath;
  final String label;

  const _NavigationItem({
    required this.filledAssetPath,
    required this.outlinedAssetPath,
    required this.label,
  });
}

class _KeepAlivePage extends StatefulWidget {
  const _KeepAlivePage({required this.child});

  final Widget child;

  @override
  State<_KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
