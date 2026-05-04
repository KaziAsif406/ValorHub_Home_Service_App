import 'package:flutter/material.dart';
import 'package:template_flutter/features/contractor/home/presentation/widget/home_app_bar.dart';
import 'package:template_flutter/features/contractor/home/presentation/widget/home_overview_section.dart';
import 'package:template_flutter/gen/colors.gen.dart';

class ContractorHomeScreen extends StatefulWidget {
  const ContractorHomeScreen({
    super.key,
    this.profileName = 'Contractor',
    this.profileEmail = 'contractor@example.com',
  });

  final String profileName;
  final String profileEmail;

  @override
  State<ContractorHomeScreen> createState() => _ContractorHomeScreenState();
}

class _ContractorHomeScreenState extends State<ContractorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        elevation: 1,
        titleSpacing: 15,
        automaticallyImplyLeading: false,
        title: ContractorHomeAppBar(
          profileName: widget.profileName,
          onInboxPressed: _handleInboxPressed,
        ),
      ),
      // PreferredSize(
      //   preferredSize: const Size.fromHeight(kToolbarHeight),
      //   child: SafeArea(
      //     child: ContractorHomeAppBar(
      //       profileName: widget.profileName,
      //       onInboxPressed: _handleInboxPressed,
      //     ),
      //   ),
      // ),
      body: HomeOverviewSection(
        profileName: widget.profileName,
        profileEmail: widget.profileEmail,
      ),
    );
  }


  void _handleInboxPressed() {
    // Handle inbox button press
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inbox pressed')),
    );
  }
}
