import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
import '/common_widgets/custom_appbar.dart';
import '/common_widgets/custom_button.dart';
import '/constants/text_font_style.dart';
import '/gen/colors.gen.dart';
import 'widgets/faq_item_tile.dart';
import 'widgets/faq_tab_button.dart';

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  final List<String> _tabs = ['Customers', 'Contractors', 'General'];
  int _selectedTabIndex = 0;
  int _expandedIndex = 0;

  final Map<String, List<Map<String, String>>> _faqData = {
    'Customers': [
      {
        'question': 'How do I find a contractor on ContractorHub?',
        'answer': 'Simply enter your service need and zip code in our search bar on the homepage. You\'ll see a list of verified contractors in your area. You can filter by ratings, experience, and specialty to find the perfect match.',
      },
      {
        'question': 'Are all contractors verified?',
        'answer': 'Yes, our team reviews each contractor before they can create a profile. This helps make sure you only connect with trusted professionals.',
      },
      {
        'question': 'How do I request a quote?',
        'answer': 'Choose your service, share details about the project, and submit your request. Contractors will respond with quotes and availability.',
      },
      {
        'question': 'Is there a fee for customers?',
        'answer': 'Signing up and browsing contractors is free. Some services may include a booking or platform fee depending on the provider.',
      },
      {
        'question': 'What if I\'m not satisfied with the service?',
        'answer': 'If something goes wrong, contact our support team and we\'ll help resolve the issue or connect you with a replacement contractor.',
      },
    ],
    'Contractors': [
      {
        'question': 'How do I create a contractor profile?',
        'answer': 'Visit the contractor signup flow, complete your business details, and upload required documentation for verification.',
      },
      {
        'question': 'Can I manage my leads directly in the app?',
        'answer': 'Yes, the app includes a dashboard where you can view requests, respond to customers, and manage upcoming projects.',
      },
      {
        'question': 'How does payment work?',
        'answer': 'Payments are processed securely through the app after the customer approves your quote and the job is completed.',
      },
    ],
    'General': [
      {
        'question': 'How do I reset my password?',
        'answer': 'Tap Forgot Password on the login screen, enter your email, and follow the password reset instructions sent to your inbox.',
      },
      {
        'question': 'Can I change my email address later?',
        'answer': 'Yes, open your profile settings and update your contact information at any time.',
      },
    ],
  };

  List<Map<String, String>> get _currentFaqItems => _faqData[_tabs[_selectedTabIndex]] ?? [];

  void _selectTab(int index) {
    setState(() {
      _selectedTabIndex = index;
      _expandedIndex = 0;
    });
  }

  void _toggleExpansion(int index) {
    setState(() {
      _expandedIndex = _expandedIndex == index ? -1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomAppBar(
        showBackArrow: true,
        title: Text('FAQ', style: TextFontStyle.textStyle18c000000Inter600),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(
                  _tabs.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(right: index == _tabs.length - 1 ? 0 : 8.w),
                    child: FaqTabButton(
                      label: _tabs[index],
                      selected: _selectedTabIndex == index,
                      onTap: () => _selectTab(index),
                    ),
                  ),
                ),
              ),
              UIHelper.verticalSpace(16.h),
              Container(
                // padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Column(
                  children: List.generate(
                    _currentFaqItems.length,
                    (index) {
                      final item = _currentFaqItems[index];
                      return FaqItemTile(
                        question: item['question'] ?? '',
                        answer: item['answer'] ?? '',
                        isExpanded: _expandedIndex == index,
                        onTap: () => _toggleExpansion(index),
                      );
                    },
                  ),
                ),
              ),
              UIHelper.verticalSpace(24.h),
              CustomButton(
                label: 'Contact Support',
                onPressed: () {},
                height: 34.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
