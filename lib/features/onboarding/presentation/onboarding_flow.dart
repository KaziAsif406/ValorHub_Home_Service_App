import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
// import 'package:template_flutter/navigation_screen.dart';
import '../../../common_widgets/custom_button.dart';
// import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import 'widgets/onboarding_dots.dart';

final class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_OnboardingPageData> _pages = const [
    _OnboardingPageData(
      imageAsset: 'assets/images/onboarding_1.png',
      title: 'Choose a service',
      description:
          'Find the right service for your needs easily, with a variety of options available at your fingertips.',
      width: 250,
      height: 250,
    ),
    _OnboardingPageData(
      imageAsset: 'assets/images/onboarding_2.png',
      title: 'Get a quote',
      description:
          'Request price estimates from professionals to help you make informed decisions with ease.',
      width: 250,
      height: 250,
    ),
    _OnboardingPageData(
      imageAsset: 'assets/images/onboarding_3.png',
      title: 'Work done',
      description:
          'Sit back and relax while skilled experts efficiently take care of your tasks, ensuring a job well done.',
      width: 250,
      height: 250,
    ),
  ];

  void _onNextTap() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }
    NavigationService.navigateToReplacement(Routes.loginScreen);
  }

  void _onSkipTap() {
    NavigationService.navigateToReplacement(Routes.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() {
                  _currentIndex = index;
                }),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: page.width?.w ?? 300.w,
                        height: page.height?.h ?? 250.h,
                        child: Image.asset(
                          page.imageAsset,
                          fit: BoxFit.contain,
                        ),
                      ),
                      UIHelper.verticalSpace(24.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: TextFontStyle.textStyle22c33353CInter700,
                        ),
                      ),
                      UIHelper.verticalSpace(16.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: TextFontStyle.textStyle16c282828Inter400.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            OnboardingDots(count: _pages.length, activeIndex: _currentIndex),
            UIHelper.verticalSpace(100.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _onSkipTap,
                    child: Text(
                      'Skip',
                      style: TextFontStyle.textStyle14c282828Inter400,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 108.w,
                    child: CustomButton(
                      label: _currentIndex == _pages.length - 1 ? 'Finish' : 'Next',
                      textStyle: TextFontStyle.textStyle14cFFFFFFInter400.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      onPressed: _onNextTap,
                      height: 42.h,
                      borderRadius: 12.r,
                    ),
                  ),
                ],
              ),
            ),
            UIHelper.verticalSpace(24.h),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.imageAsset,
    required this.title,
    required this.description,
    this.width,
    this.height,
  });

  final String imageAsset;
  final String title;
  final String description;
  final double? width;
  final double? height;
}
