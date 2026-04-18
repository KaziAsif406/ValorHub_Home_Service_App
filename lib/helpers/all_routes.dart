// ignore_for_file: unused_element

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/features/auth/presentation/forget_password.dart';
import 'package:template_flutter/features/auth/presentation/login.dart';
import 'package:template_flutter/features/auth/presentation/reset_password.dart';
import 'package:template_flutter/features/auth/presentation/signup.dart';
import 'package:template_flutter/features/auth/presentation/verification.dart';
import 'package:template_flutter/features/contractors/presentation/contractor_profile.dart';
import 'package:template_flutter/features/contractors/presentation/contractors_screen.dart';
import 'package:template_flutter/features/contractors/presentation/widgets/contractor_info.dart';
import 'package:template_flutter/features/location/presentation/find_location.dart';
import 'package:template_flutter/features/home/presentation/home.dart';
import 'package:template_flutter/features/home/presentation/notifications.dart';
import 'package:template_flutter/features/onboarding/presentation/onboarding_flow.dart';
import 'package:template_flutter/features/quotes/presentation/quote_sent.dart';
import 'package:template_flutter/features/quotes/presentation/request_quote.dart';
import 'package:template_flutter/features/user_profile/presentation/change_password_inside_profile.dart';
import 'package:template_flutter/features/user_profile/presentation/contact_us.dart';
import 'package:template_flutter/features/user_profile/presentation/edit_profile.dart';
import 'package:template_flutter/features/user_profile/presentation/faq.dart';
import 'package:template_flutter/navigation_screen.dart';
import 'package:template_flutter/welcome_screen.dart';
// import 'package:template_flutter/features/product/presentation/products.dart';
// import '../features/auth/presentation/login.dart';
// import '../features/auth/presentation/signup.dart';
// import '../features/product/presentation/product_details.dart';
// import '../features/product/presentation/products_with_pagination.dart'
    // as products_pagination;
import '../features/user_profile/presentation/profile.dart';

final class Routes {
  static final Routes _routes = Routes._internal();
  Routes._internal();
  static Routes get instance => _routes;

  // Auth Routes
  static const String loginScreen = '/logIn';
  static const String signUpScreen = '/signUp';
  static const String forgotPWScreen = '/ForgotPWScreen';
  static const String otpScreen = '/OtpScreen';
  static const String resetPassword = '/resetPassword';
  static const String resetInsidePassword = '/resetInsidePassword';
  //products_with_pagination
  static const String productsWithPagination = '/ProductsWithPagination';
  //ProductsScreen
  static const String productsScreen = '/ProductsScreen';
  //ProductDetailsScreen
  static const String productDetailsScreen = '/ProductDetailsScreen';

  // Main App Routes
  static const String homeScreen = '/home_screen';
  static const String navigationScreen = '/NavigationScreen';
  static const String profile = '/Profile';
  static const String welcomeScreen = '/welcome_screen';
  static const String onboardingFlow = '/onboarding_flow';
  static const String contractorsScreen = '/contractors_screen';
  static const String findLocationScreen = '/find_location_screen';
  static const String notificationScreen = '/notification_screen';
  static const String contractorProfileScreen = '/contractor_profile_screen';
  static const String requestQuoteScreen = '/request_quote_screen';
  static const String quoteSentScreen = '/quote_sent_screen';
  static const String contactUsScreen = '/contact_us_screen';
  static const String faqScreen = '/faq_screen';
  static const String editProfileScreen = '/edit_profile_screen';
}

final class RouteGenerator {
  static final RouteGenerator _routeGenerator = RouteGenerator._internal();
  RouteGenerator._internal();
  static RouteGenerator get instance => _routeGenerator;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Auth Routes
      case Routes.loginScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const LoginScreen())
            : _FadedTransitionRoute(
                widget: const LoginScreen(), settings: settings);

      case Routes.signUpScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const SignUpScreen())
            : _FadedTransitionRoute(
                widget: const SignUpScreen(), settings: settings);

      case Routes.welcomeScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const WelcomeScreen())
            : _FadedTransitionRoute(
                widget: const WelcomeScreen(), settings: settings);

      case Routes.onboardingFlow:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const OnboardingFlow())
            : _FadedTransitionRoute(
                widget: const OnboardingFlow(), settings: settings);

      case Routes.navigationScreen:
        final routeArgs = settings.arguments;
        final initialIndex =
            routeArgs is Map<String, dynamic> && routeArgs['initialIndex'] is int
                ? routeArgs['initialIndex'] as int
                : 0;
        final String profileName = routeArgs is Map<String, dynamic> && routeArgs['name'] is String
            ? routeArgs['name'] as String
            : 'Md Riyad';
        final String profileEmail = routeArgs is Map<String, dynamic> && routeArgs['email'] is String
            ? routeArgs['email'] as String
            : 'mdriyadpc11@gmail.com';
        final String? profileImagePath = routeArgs is Map<String, dynamic>
            ? routeArgs['imagePath'] as String?
            : null;

        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => NavigationScreen(
                  initialIndex: initialIndex,
                  profileName: profileName,
                  profileEmail: profileEmail,
                  profileImagePath: profileImagePath,
                ),
              )
            : _FadedTransitionRoute(
                widget: NavigationScreen(
                  initialIndex: initialIndex,
                  profileName: profileName,
                  profileEmail: profileEmail,
                  profileImagePath: profileImagePath,
                ),
                settings: settings,
              );


      case Routes.resetPassword:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const ResetPasswordScreen())
            : _FadedTransitionRoute(
                widget: const ResetPasswordScreen(), settings: settings);


      case Routes.resetInsidePassword:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const ResetPasswordInsideProfileScreen())
            : _FadedTransitionRoute(
                widget: const ResetPasswordInsideProfileScreen(), settings: settings);

      // case Routes.productsWithPagination:
      //   return defaultTargetPlatform == TargetPlatform.iOS
      //       ? CupertinoPageRoute(
      //           builder: (context) =>
      //               const products_pagination.ProductsScreen())
      //       : _FadedTransitionRoute(
      //           widget: const products_pagination.ProductsScreen(),
      //           settings: settings);
      // case Routes.productsScreen:
      //   return defaultTargetPlatform == TargetPlatform.iOS
      //       ? CupertinoPageRoute(builder: (context) => const ProductsScreen())
      //       : _FadedTransitionRoute(
      //           widget: const ProductsScreen(), settings: settings);
      // case Routes.productDetailsScreen:
      //   final args = settings.arguments as Map;
      //   return defaultTargetPlatform == TargetPlatform.iOS
      //       ? CupertinoPageRoute(
      //           builder: (context) =>
      //               ProductDetailsScreen(productId: args['productId']))
      //       : _FadedTransitionRoute(
      //           widget: ProductDetailsScreen(productId: args['productId']),
      //           settings: settings);

      case Routes.forgotPWScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const ForgetPasswordScreen())
            : _FadedTransitionRoute(
                widget: const ForgetPasswordScreen(), settings: settings);


      case Routes.otpScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const VerificationCodeScreen())
            : _FadedTransitionRoute(
                widget: const VerificationCodeScreen(), settings: settings);


      // case Routes.otpScreen:
      //   final args = settings.arguments as Map;
      //   return defaultTargetPlatform == TargetPlatform.iOS
      //       ? CupertinoPageRoute(builder: (context) => VerificationCodeScreen())
      //       : _FadedTransitionRoute(
      //           widget: VerificationCodeScreen(),
      //           settings: settings
      //         );

      // case Routes.setPassword:
      //   final args = settings.arguments as Map;
      //   return defaultTargetPlatform == TargetPlatform.iOS
      //       ? CupertinoPageRoute(builder: (context) => SetPasswordScreen(name: args['name'], email: args['email']))
      //       : _FadedTransitionRoute(
      //           widget: SetPasswordScreen(name: args['name'], email: args['email']),
      //           settings: settings
      //         );

      // Main App Routes
      case Routes.homeScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const HomeScreen())
            : _FadedTransitionRoute(widget: const HomeScreen(), settings: settings);

      // case Routes.navigationScreen:
      //   return defaultTargetPlatform == TargetPlatform.iOS
      //       ? CupertinoPageRoute(builder: (context) => const NavigationScreen())
      //       : _FadedTransitionRoute(widget: const NavigationScreen(), settings: settings);

      case Routes.profile:
        final profileArgs = settings.arguments;
        final String profileName = profileArgs is Map<String, dynamic> && profileArgs['name'] is String
            ? profileArgs['name'] as String
            : 'Md Riyad';
        final String profileEmail = profileArgs is Map<String, dynamic> && profileArgs['email'] is String
            ? profileArgs['email'] as String
            : 'mdriyadpc11@gmail.com';
        final String? profileImagePath = profileArgs is Map<String, dynamic>
            ? profileArgs['imagePath'] as String?
            : null;

        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => ProfileScreen(
                  name: profileName,
                  email: profileEmail,
                  imagePath: profileImagePath,
                ),
              )
            : _FadedTransitionRoute(
                widget: ProfileScreen(
                  name: profileName,
                  email: profileEmail,
                  imagePath: profileImagePath,
                ),
                settings: settings);
      

      case Routes.contractorsScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const ContractorsScreen())
            : _FadedTransitionRoute(
                widget: const ContractorsScreen(), settings: settings);

      case Routes.findLocationScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const FindLocationScreen())
            : _FadedTransitionRoute(
                widget: const FindLocationScreen(), settings: settings);

      case Routes.notificationScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const NotificationsScreen())
            : _FadedTransitionRoute(
                widget: const NotificationsScreen(), settings: settings);


      case Routes.contractorProfileScreen:
        final contractor = settings.arguments as contractorData;
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => ContractorProfile(contractor: contractor))
            : _FadedTransitionRoute(
                widget: ContractorProfile(contractor: contractor),
                settings: settings);


      case Routes.requestQuoteScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const RequestQuote())
            : _FadedTransitionRoute(
                widget: const RequestQuote(), settings: settings);


      case Routes.quoteSentScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const QuoteSent())
            : _FadedTransitionRoute(
                widget: const QuoteSent(), settings: settings);


      case Routes.contactUsScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const ContactUs())
            : _FadedTransitionRoute(
                widget: const ContactUs(), settings: settings);


      case Routes.faqScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const Faq())
            : _FadedTransitionRoute(
                widget: const Faq(), settings: settings);

      case Routes.editProfileScreen:
        final editProfileArgs = settings.arguments;
        final String editProfileName = editProfileArgs is Map<String, dynamic> && editProfileArgs['name'] is String
            ? editProfileArgs['name'] as String
            : '';
        final String editProfileEmail = editProfileArgs is Map<String, dynamic> && editProfileArgs['email'] is String
            ? editProfileArgs['email'] as String
            : '';
        final String? editProfileImagePath = editProfileArgs is Map<String, dynamic>
            ? editProfileArgs['imagePath'] as String?
            : null;

        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => EditProfileScreen(
                  initialName: editProfileName,
                  initialEmail: editProfileEmail,
                  initialImagePath: editProfileImagePath,
                ),
              )
            : _FadedTransitionRoute(
                widget: EditProfileScreen(
                  initialName: editProfileName,
                  initialEmail: editProfileEmail,
                  initialImagePath: editProfileImagePath,
                ),
                settings: settings);

      default:
        return null;
    }
  }
}

class _FadedTransitionRoute extends PageRouteBuilder {
  final Widget widget;
  @override
  final RouteSettings settings;

  _FadedTransitionRoute({required this.widget, required this.settings})
      : super(
          settings: settings,
          reverseTransitionDuration: const Duration(milliseconds: 1),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionDuration: const Duration(milliseconds: 1),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.ease,
              ),
              child: child,
            );
          },
        );
}

class ScreenTitle extends StatelessWidget {
  final Widget widget;

  const ScreenTitle({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: .5, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: widget,
    );
  }
}
