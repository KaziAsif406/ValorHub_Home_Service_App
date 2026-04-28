import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:template_flutter/gen/colors.gen.dart';
// import 'package:template_flutter/helpers/ui_helpers.dart';
import 'contractor_info.dart';

class ProjectGallery extends StatelessWidget {
  final contractorData contractor;

  const ProjectGallery({
    super.key,
    required this.contractor,
  });

  final List<String> projectImages = const [
    'assets/images/placeholder_image.jpeg',
    'assets/images/placeholder_image.jpeg',
    'assets/images/placeholder_image.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: projectImages.asMap().entries.map((entry) {
          int index = entry.key;
          String image = entry.value;
          
          return Container(
            margin: EdgeInsets.only(right: index == projectImages.length - 1 ? 0 : 8.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: GestureDetector(
                onTap: () {
                  // Open image in full screen or gallery view
                },
                child: Container(
                  width: 128.w,
                  height: 128.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
