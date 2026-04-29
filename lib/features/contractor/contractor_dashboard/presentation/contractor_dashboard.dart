import 'package:flutter/material.dart';
import 'package:template_flutter/features/contractor/quote_requests/presentation/all_requessts.dart';
// import 'package:template_flutter/common_widgets/custom_button.dart';
// import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
// import 'package:template_flutter/helpers/ui_helpers.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/services/auth_service.dart';

import 'widget/contractor_dashboard_app_bar.dart';
import 'widget/contractor_dashboard_drawer.dart';
import '../../inbox/presentation/dashboard_inbox_screen.dart';
import 'widget/dashboard_overview_section.dart';
import '../../profile/presentation/dashboard_profile_screen.dart';
import '../../reviews/presentation/dashboard_reviews_screen.dart';
import '../../services/presentation/dashboard_services_screen.dart';

enum ContractorDashboardSection { overview, inbox, requests, services, profile, reviews }

class ContractorDashboardScreen extends StatefulWidget {
  const ContractorDashboardScreen({
    super.key,
    required this.profileName,
    required this.profileEmail,
  });

  final String profileName;
  final String profileEmail;

  @override
  State<ContractorDashboardScreen> createState() =>
      _ContractorDashboardScreenState();
}

class _ContractorDashboardScreenState extends State<ContractorDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _auth = AuthService();
  ContractorDashboardSection _selectedSection =
      ContractorDashboardSection.overview;

  Future<void> _signOut() async {
    await _auth.signOut();
    NavigationService.navigateToReplacement(Routes.loginScreen);
  }

  void _openSection(ContractorDashboardSection section) {
    Navigator.of(context).pop();
    setState(() {
      _selectedSection = section;
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _setInboxSection() {
    setState(() {
      _selectedSection = ContractorDashboardSection.inbox;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.scaffoldColor,
      drawer: ContractorDashboardDrawer(
        profileName: widget.profileName,
        profileEmail: widget.profileEmail,
        selectedSection: _selectedSection,
        onSectionSelected: _openSection,
        onSignOut: _signOut,
      ),
      body: SafeArea(
        child: Column(
          children: [
            ContractorDashboardAppBar(
              profileName: widget.profileName,
              onMenuPressed: _openDrawer,
              onInboxPressed: _setInboxSection,
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: _buildSection(_selectedSection),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(ContractorDashboardSection section) {
    switch (section) {
      case ContractorDashboardSection.overview:
        return DashboardOverviewSection(
          key: const ValueKey<String>('overview'),
          profileName: widget.profileName,
          profileEmail: widget.profileEmail,
        );
      case ContractorDashboardSection.inbox:
        return DashboardInboxSection(
          key: const ValueKey<String>('inbox'),
        );
      case ContractorDashboardSection.requests:
        return AllRequestsScreen(
          key: const ValueKey<String>('requests'),
        );
      case ContractorDashboardSection.services:
        return DashboardServicesSection(
          key: const ValueKey<String>('services'),
        );
      case ContractorDashboardSection.profile:
        return DashboardProfileSection(
          key: const ValueKey<String>('profile'),
          profileName: widget.profileName,
          profileEmail: widget.profileEmail,
          onSignOut: _signOut,
        );
      case ContractorDashboardSection.reviews:
        return DashboardReviewsSection(
          key: const ValueKey<String>('reviews'),
        );
    }
  }
}
