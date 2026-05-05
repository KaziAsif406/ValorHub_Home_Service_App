import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/customer/contractors/data/contractor_model.dart';
import 'package:template_flutter/constants/app_constants.dart';
import 'package:template_flutter/services/chat_service.dart';
import 'package:template_flutter/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:template_flutter/features/customer/contractors/data/contractor_mapper.dart';
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
	final String _currentUserId = AuthService().currentUser?.uid ?? '';


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
										child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
											stream: ChatService().chatsForUser(_currentUserId),
											builder: (context, snapshot) {
												if (snapshot.hasError) {
													return Center(
														child: Text(
															'Unable to load chats',
															style: TextFontStyle.textStyle14c6A7181Inter400,
														),
													);
												}

												if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
													return Center(
														child: Text(
															'No chats found',
															style: TextFontStyle.textStyle14c6A7181Inter400,
														),
													);
												}

												final chats = snapshot.data!.docs;

												return ListView.separated(
													itemCount: chats.length,
													padding: EdgeInsets.symmetric(vertical: 6.h),
													separatorBuilder: (_, __) {
														return Divider(
															height: 1.h,
															thickness: 1.h,
															color: AppColors.c000000.withValues(alpha: 0.08),
														);
													},
													itemBuilder: (context, index) {
														final chatDoc = chats[index];
														final data = chatDoc.data();
														final participants = (data['participants'] as List<dynamic>?)
																		?.cast<String>() ??
																[];
														final otherId = participants.firstWhere(
																(p) => p != _currentUserId,
																orElse: () => '');
														final lastMessage = data['lastMessage'] as String? ?? '';
														final lastUpdated = data['lastUpdated'] as Timestamp?;
														final timeLabel = lastUpdated != null
																? DateFormat('h:mm a').format(lastUpdated.toDate())
																: '';

														return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
															future: FirebaseFirestore.instance
																	.collection(kFirestoreUsersCollection)
																	.doc(otherId)
																	.get(),
															builder: (context, userSnap) {
																String name = 'Unknown';
																String service = '';
																String initials = '';

																if (userSnap.hasData && userSnap.data!.exists) {
																	final otherDoc = userSnap.data!;
																	final mapped = mapDocToContractor(otherDoc);
																	if (mapped != null) {
																		name = mapped.name;
																		service = mapped.service;
																		initials = _initialsFromName(mapped.name);
																	} else {
																		final displayName = otherDoc.data()?['displayName'] as String?;
																		final email = otherDoc.data()?['email'] as String? ?? '';
																		name = displayName ?? email.split('@').first;
																		initials = _initialsFromName(name);
																	}
																}

																return ChatOverviewTile(
																	name: name,
																	serviceCategory: service,
																	lastMessage: lastMessage,
																	timeLabel: timeLabel,
																	initials: initials,
																	unreadCount: 0,
																	isOnline: false,
																	isSelected: false,
																	onTap: () {
																		final contractor = mapDocToContractor(userSnap.data!) ??
																				contractorData(
																					id: otherId,
																					name: name,
																					service: service,
																					rating: 0.0,
																					reviews: 0,
																					location: '',
																					experience: 0,
																					description: '',
																					phone: '',
																					mail: otherId,
																				);

																		NavigationService.navigatorKey.currentState?.push(
																			MaterialPageRoute(
																				builder: (_) => ChatInboxScreen(
																					contractor: contractor,
																					isOnline: false,
																				),
																			),
																		);
																	},
																);
															},
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
