import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/app_preferences.dart';
import 'package:template_flutter/helpers/navigation_service.dart';


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool? seen;


  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus().then((_) {
      Future.delayed(const Duration(seconds: 4), () {
        if (seen == true) {
          NavigationService.navigateTo(Routes.loginScreen);
        } else {
          NavigationService.navigateTo(Routes.onboardingFlow);
        }
      });
    });
  }

  Future<void> _checkOnboardingStatus() async {
    final hasSeen = await AppPrefs.hasSeenOnboarding();
    if (!mounted) return;
    setState(() {
      seen = hasSeen;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: Center(
        child: Image.asset(
          'assets/icons/logo.png',
          width: 151.w,
          height: 136.h,
        ),
      ),
    );
  }
}
