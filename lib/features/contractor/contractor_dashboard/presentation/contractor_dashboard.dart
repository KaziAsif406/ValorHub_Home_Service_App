import 'package:flutter/material.dart';
import 'package:template_flutter/features/contractor/inbox/presentation/chat_list.dart';
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
import 'dashboard_overview_section.dart';
import '../../profile/presentation/contractor_profile_screen.dart';
import '../../reviews/presentation/dashboard_reviews_screen.dart';
import '../../services/presentation/dashboard_services_screen.dart';

enum ContractorDashboardSection {
  overview,
  inbox,
  requests,
  services,
  profile,
  reviews
}

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
  late String _profileName;

  @override
  void initState() {
    super.initState();
    _profileName = widget.profileName;
    _loadProfileName();
  }

  Future<void> _loadProfileName() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null || uid.isEmpty) return;
      final data = await _auth.getUserProfileByUserId(uid);
      if (data == null) return;

      final displayName = (data['displayName'] as String?)?.trim() ??
          (data['name'] as String?)?.trim();
      if (displayName != null && displayName.isNotEmpty) {
        setState(() {
          _profileName = displayName;
        });
        return;
      }

      // Try first/last name fields if present
      final first = (data['first_name'] as String?)?.trim() ?? '';
      final last = (data['lst_name'] as String?)?.trim() ?? '';
      final combined = '$first ${last.isNotEmpty ? last : ''}'.trim();
      if (combined.isNotEmpty) {
        setState(() {
          _profileName = combined;
        });
        return;
      }

      // Fallback to email local-part if available
      final email = (data['email'] as String?)?.trim();
      if (email != null && email.isNotEmpty) {
        final local = email.split('@').first;
        setState(() {
          _profileName = local;
        });
      }
    } catch (_) {
      // ignore errors and keep existing profileName
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    NavigationService.navigateToReplacement(Routes.loginScreen);
  }

  void _openSection(ContractorDashboardSection section) {
    // Only close the drawer if it is currently open.
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
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
        profileName: _profileName,
        profileEmail: widget.profileEmail,
        selectedSection: _selectedSection,
        onSectionSelected: _openSection,
        onSignOut: _signOut,
      ),
      body: SafeArea(
        child: Column(
          children: [
            ContractorDashboardAppBar(
              profileName: _profileName,
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
          profileName: _profileName,
          profileEmail: widget.profileEmail,
          onViewRequests: () =>
              _openSection(ContractorDashboardSection.requests),
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
          profileName: _profileName,
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
