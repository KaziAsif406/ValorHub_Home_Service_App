import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/customer/location/presentation/widget/survey_answer_selector_tile.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class SurveyScreen extends StatefulWidget {
	const SurveyScreen({super.key, this.categoryName, this.zipCode});

	final String? categoryName;
	final String? zipCode;

	@override
	State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
	int _currentStep = 0;
	final List<int> _selectedIndexes = [0, 0];

	static const List<_SurveyQuestion> _questions = [
		_SurveyQuestion(
			title: 'What kind of location is this?',
			options: ['Home', 'Business'],
		),
		_SurveyQuestion(
			title: 'How soon do you need this project?',
			options: [
				'Urgent (1-2 days)',
				'Within 2 weeks',
				'More than 2 weeks',
				'Not sure - still planning/budgeting',
			],
		),
	];

	_SurveyQuestion get _activeQuestion => _questions[_currentStep];

	void _selectOption(int optionIndex) {
		setState(() {
			_selectedIndexes[_currentStep] = optionIndex;
		});
	}

	void _onBackPressed() {
		if (_currentStep > 0) {
			setState(() {
				_currentStep -= 1;
			});
			return;
		}

		if (Navigator.of(context).canPop()) {
			Navigator.of(context).pop();
		}
	}

	void _onNextPressed() {
		if (_currentStep < _questions.length - 1) {
			setState(() {
				_currentStep += 1;
			});
			return;
		}

		NavigationService.navigateToWithArgs(
			Routes.contractorsScreen,
			{
				'filterCategory': widget.categoryName ?? '',
				'zipCode': widget.zipCode ?? '',
			},
		);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: AppColors.scaffoldColor,
			body: SafeArea(
				child: Padding(
					padding: EdgeInsets.symmetric(horizontal: 20.w),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.center,
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							Text(
								_activeQuestion.title,
								textAlign: TextAlign.center,
								style: TextFontStyle.textStyle18c14181FInter600,
							),
							UIHelper.verticalSpace(24.h),
							...List.generate(_activeQuestion.options.length, (index) {
								final label = _activeQuestion.options[index];
								return Padding(
									padding: EdgeInsets.only(bottom: 14.h),
									child: SurveyAnswerSelectorTile(
										label: label,
										isSelected: _selectedIndexes[_currentStep] == index,
										onTap: () => _selectOption(index),
									),
								);
							}),
							UIHelper.verticalSpace(32.h),
							Row(
								children: [
									Expanded(
										child: CustomButton(
											label: 'Back',
											onPressed: _onBackPressed,
											height: 38.h,
											borderRadius: 12.r,
											isOutlined: true,
											color: AppColors.allPrimaryColor,
											borderColor: AppColors.allPrimaryColor,
											textStyle: TextStyle(
												color: AppColors.allPrimaryColor,
												fontSize: 18.sp,
												fontWeight: FontWeight.w600,
											),
										),
									),
									UIHelper.horizontalSpace(14.w),
									Expanded(
										child: CustomButton(
											label: 'Next',
											onPressed: _onNextPressed,
											height: 38.h,
											borderRadius: 12.r,
											textStyle: TextStyle(
												color: AppColors.scaffoldColor,
												fontSize: 18.sp,
												fontWeight: FontWeight.w600,
											),
										),
									),
								],
							),
						],
					),
				),
			),
		);
	}
}

class _SurveyQuestion {
	final String title;
	final List<String> options;

	const _SurveyQuestion({required this.title, required this.options});
}
