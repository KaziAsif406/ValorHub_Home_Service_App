import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/customer/contractors/data/contractor_model.dart';
import 'package:template_flutter/gen/colors.gen.dart';
// import 'package:template_flutter/helpers/ui_helpers.dart';
class ServiceOfferedTiles extends StatelessWidget {
  final contractorData contractor;

  const ServiceOfferedTiles({
    super.key,
    required this.contractor,
  });

  final List<String> servicesList = const [
    'Leak Repairs',
    'Drain Cleaning',
    'Water Heater',
    'Bathroom Plumbing',
    'Gas Lines',
    'Kitchen Plumbing',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: servicesList.map((service) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.cF3F4F6,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                service,
                style: TextFontStyle.textStyle12c333C4DInter500,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
