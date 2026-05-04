import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/customer/contractors/presentation/widgets/contractor_info.dart';
import 'package:template_flutter/features/customer/inbox/presentation/chat_inbox.dart';
import 'package:template_flutter/features/customer/inbox/presentation/widget/chat_overview_tile.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class ChatListScreen extends StatefulWidget {
	const ChatListScreen({super.key, this.onBackToHome});

	final VoidCallback? onBackToHome;

	@override
	State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
	final TextEditingController _searchController = TextEditingController();

	late final List<_ChatPreview> _allChats;

	@override
	void initState() {
		super.initState();
		_allChats = _buildPreviewData(ContractorProfileScreen.contractors);
	}


  void _handleBack() {
    if (widget.onBackToHome != null) {
      widget.onBackToHome!();
      return;
    }

    NavigationService.navigateTo(Routes.navigationScreen);
  }

	@override
	void dispose() {
		_searchController.dispose();
		super.dispose();
	}

	List<_ChatPreview> get _filteredChats {
		final query = _searchController.text.trim().toLowerCase();
		if (query.isEmpty) {
			return _allChats;
		}

		return _allChats.where((chat) {
			return chat.contractor.name.toLowerCase().contains(query) ||
					chat.contractor.service.toLowerCase().contains(query);
		}).toList();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: AppColors.scaffoldColor,
			appBar: AppBar(
				elevation: 2,
				shadowColor: AppColors.c000000.withValues(alpha: 0.2),
				backgroundColor: AppColors.scaffoldColor,
				title: Text(
					'Inbox',
					style: TextFontStyle.textStyle16c14181FInter600,
				),
				leading: IconButton(
					icon: const Icon(
						Icons.arrow_back_ios_new_outlined,
						color: AppColors.c14181F,
					),
					onPressed: () {
						_handleBack();
					},
				),
			),
			body: SafeArea(
				child: Padding(
					padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
					child: Column(
						children: [
							CustomTextFormField(
								height: 44.h,
								controller: _searchController,
								hintText: 'Search...',
								onChanged: (_) => setState(() {}),
								contentPadding:
										EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
								prefixIcon: Icon(
									Icons.search_rounded,
									size: 20.sp,
									color: AppColors.c64748B,
								),
							),
							UIHelper.verticalSpace(10.h),
							Expanded(
								child: _filteredChats.isEmpty
										? Center(
												child: Text(
													'No chats found',
													style: TextFontStyle.textStyle14c6A7181Inter400,
												),
											)
										: ListView.separated(
												itemCount: _filteredChats.length,
												padding: EdgeInsets.symmetric(vertical: 6.h),
												separatorBuilder: (_, __) {
													return Divider(
														height: 1.h,
														thickness: 1.h,
														color: AppColors.c000000.withValues(alpha: 0.08),
													);
												},
												itemBuilder: (context, index) {
													final chat = _filteredChats[index];
													return ChatOverviewTile(
														name: chat.contractor.name,
														serviceCategory: chat.contractor.service,
														lastMessage: chat.previewMessage,
														timeLabel: chat.timeLabel,
														initials: _initialsFromName(chat.contractor.name),
														unreadCount: chat.unreadCount,
														isOnline: chat.isOnline,
														isSelected: chat.isSelected,
														onTap: () {
															NavigationService.navigatorKey.currentState
																?.push(
																	MaterialPageRoute(
																		builder: (_) => ChatInboxScreen(
																			contractor: chat.contractor,
																			isOnline: chat.isOnline,
																		),
																	),
																);
														},
													);
												},
											),
							),
						],
					),
				),
			),
		);
	}

	List<_ChatPreview> _buildPreviewData(List<contractorData> contractors) {
		const List<String> timeLabels = [
			'10:32 AM',
			'9:14 AM',
			'Yesterday',
			'Mon',
			'Sun',
			'Sat',
		];

		const List<String> previewMessages = [
			'Sounds good, can we schedule a site visit Friday?',
			'I sent over the color samples I liked.',
			'Thanks for the quote, reviewing now.',
			'Perfect, see you Monday at 8am.',
			'Can you share a quick estimate first?',
			'Please send material options before noon.',
		];

		return List<_ChatPreview>.generate(contractors.length, (index) {
			return _ChatPreview(
				contractor: contractors[index],
				timeLabel: timeLabels[index % timeLabels.length],
				previewMessage: previewMessages[index % previewMessages.length],
				unreadCount: index == 0 ? 2 : 0,
				isOnline: index == 0 || index == 3,
				isSelected: index == 0,
			);
		});
	}

	String _initialsFromName(String fullName) {
		final parts = fullName
				.split(' ')
				.where((part) => part.trim().isNotEmpty)
				.toList(growable: false);

		if (parts.isEmpty) {
			return '';
		}

		if (parts.length == 1) {
			return parts.first.substring(0, 1).toUpperCase();
		}

		return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
				.toUpperCase();
	}
}

class _ChatPreview {
	const _ChatPreview({
		required this.contractor,
		required this.timeLabel,
		required this.previewMessage,
		required this.unreadCount,
		required this.isOnline,
		required this.isSelected,
	});

	final contractorData contractor;
	final String timeLabel;
	final String previewMessage;
	final int unreadCount;
	final bool isOnline;
	final bool isSelected;
}
