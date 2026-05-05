import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/customer/contractors/presentation/widgets/contractor_info.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';

class SavedContractorsScreen extends StatelessWidget {
	const SavedContractorsScreen({super.key, this.onBackToHome});

	final VoidCallback? onBackToHome;

	void _handleBack(BuildContext context) {
		if (onBackToHome != null) {
			onBackToHome!();
			return;
		}

		if (Navigator.of(context).canPop()) {
			Navigator.of(context).pop();
		}
	}

	static const List<contractorData> _contractors = [
		contractorData(
			id: '',
			name: 'Mike Johnson',
			service: 'Plumbing',
			rating: 4.9,
			reviews: 142,
			location: 'Dallas, TX',
			experience: 12,
			description:
					'Licensed master plumber specializing in residential repairs and installations.',
		),
		contractorData(
			id: '',
			name: 'Sarah Williams',
			service: 'HVAC',
			rating: 4.8,
			reviews: 98,
			location: 'Austin, TX',
			experience: 10,
			description:
					'Certified HVAC specialist with expertise in diagnostics and efficient climate solutions.',
		),
		contractorData(
			id: '',
			name: 'David Chen',
			service: 'Electrical',
			rating: 4.7,
			reviews: 215,
			location: 'Houston, TX',
			experience: 15,
			description:
					'Licensed electrician focused on safe installations, repairs, and smart home upgrades.',
		),
	];

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 20.sp,
            color: AppColors.c14181F,
          ),
					onPressed: () => _handleBack(context),
        ),
        title: Text(
          'Saved Contractors',
          style: TextFontStyle.textStyle16c14181FInter600,
        ),
      ),
			body: SafeArea(
				child: ListView.separated(
					physics: const BouncingScrollPhysics(),
					padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
					itemCount: _contractors.length,
					separatorBuilder: (_, __) => SizedBox(height: 18.h),
					itemBuilder: (context, index) {
						return _SavedContractorCard(data: _contractors[index]);
					},
				),
			),
		);
	}
}

class _SavedContractorCard extends StatelessWidget {
	const _SavedContractorCard({required this.data});

	final contractorData data;

	@override
	Widget build(BuildContext context) {
		return Container(
			decoration: BoxDecoration(
				color: AppColors.scaffoldColor,
				borderRadius: BorderRadius.circular(12.r),
				boxShadow: [
					BoxShadow(
						color: AppColors.c000000.withValues(alpha: 0.12),
						blurRadius: 14.r,
						offset: Offset(0, 3.h),
					),
				],
			),
			padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
			child: Column(
				children: [
					Row(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							ClipRRect(
								borderRadius: BorderRadius.circular(12.r),
								child: Image.asset(
									'assets/images/placeholder_image.jpeg',
									width: 56.w,
									height: 56.w,
									fit: BoxFit.cover,
								),
							),
							SizedBox(width: 12.w),
							Expanded(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											data.name,
											style: TextFontStyle.textStyle14c14181FInter600,
										),
										SizedBox(height: 4.h),
										Text(
											data.service,
											style: TextFontStyle.textStyle12cBE1E2DInter500,
										),
										SizedBox(height: 4.h),
										Row(
											children: [
                        Image.asset(
                          'assets/icons/gold_star.png',
                          width: 12.w,
                          height: 12.w,
                        ),
												SizedBox(width: 6.w),
												Text(
													data.rating.toStringAsFixed(1),
													style: TextFontStyle.textStyle12c14181FInter600,
												),
												SizedBox(width: 8.w),
												Text(
													'(${data.reviews})',
													style: TextFontStyle.textStyle12c6A7181Inter400,
												),
											],
										),
									],
								),
							),
							Padding(
								padding: EdgeInsets.only(top: 14.h, right: 4.w),
								child: Image.asset(
                  'assets/icons/filled_heart.png',
                  width: 20.w,
                  height: 20.w,
                ),
							),
						],
					),
					SizedBox(height: 12.h),
					Row(
						children: [
							Expanded(
								child: CustomButton(
                  label: 'View Profile',
                  onPressed: () {
                    NavigationService.navigateToWithObject(Routes.contractorProfileScreen, data);
                  },
                  height: 34.h,
                  borderRadius: 12.r,
                  textStyle: TextFontStyle.textStyle12cBE1E2DInter600,
                  isOutlined: true,
                ),
							),
							SizedBox(width: 12.w),
							Expanded(
								child: CustomButton(
                  label: 'Request Quote',
										onPressed: () {
											NavigationService.navigateToWithObject(Routes.requestQuoteScreen, data);
										},
                  height: 34.h,
                  borderRadius: 12.r,
                  textStyle: TextFontStyle.textStyle12cFFFFFFInter600,
                ),
							),
						],
					),
				],
			),
		);
	}
}
