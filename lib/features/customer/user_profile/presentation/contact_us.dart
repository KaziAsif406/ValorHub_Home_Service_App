import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
import '/common_widgets/custom_appbar.dart';
import '/common_widgets/custom_button.dart';
import '/common_widgets/custom_textform_field.dart';
import '/constants/text_font_style.dart';
import '/gen/colors.gen.dart';
import 'widgets/contact_info_tile.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomAppBar(
        backgroundColor: AppColors.allSecondaryColor,
        showBackArrow: true,
        title: Text(
          'Contact Us',
          style: TextFontStyle.textStyle18c000000Inter600,
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, // 👈 important
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContactInfoTile(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  subtitle: 'support@proconnect.com',
                ),
                UIHelper.verticalSpace(12.h),
                ContactInfoTile(
                  icon: Icons.phone_outlined,
                  title: 'Phone',
                  subtitle: '(555) 000-1234',
                ),
                UIHelper.verticalSpace(12.h),
                ContactInfoTile(
                  icon: Icons.location_on_outlined,
                  title: 'Office',
                  subtitle: '123 Main St, Dallas, TX 75001',
                ),
                UIHelper.verticalSpace(12.h),
                ContactInfoTile(
                  icon: Icons.access_time_outlined,
                  title: 'Business Hours',
                  subtitle: 'Monday - Friday: 9am - 6pm\nSaturday: 10am - 4pm\nSunday: Closed',
                ),
                UIHelper.verticalSpace(16.h),
                Text(
                  'Send a Message',
                  style: TextFontStyle.textStyle18c14181FInter700,
                ),
                UIHelper.verticalSpace(12.h),
                CustomTextFormField(
                  height: 46,
                  hintText: 'Your Name',
                ),
                UIHelper.verticalSpace(16.h),
                CustomTextFormField(
                  height: 46,
                  hintText: 'Your Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                UIHelper.verticalSpace(16.h),
                CustomTextFormField(
                  height: 46,
                  hintText: 'Select a subject',
                ),
                UIHelper.verticalSpace(16.h),
                CustomTextFormField(
                  hintText: 'Your Message',
                  maxLines: 5,
                ),
                UIHelper.verticalSpace(16.h),
                CustomButton(
                  label: 'Send Message',
                  onPressed: () {},
                  height: 44.h,
                ),
                UIHelper.verticalSpace(16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
