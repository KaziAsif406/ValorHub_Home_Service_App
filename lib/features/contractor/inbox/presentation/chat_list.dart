import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/features/contractor/inbox/presentation/widget/chat_overview_tile.dart';
import 'package:template_flutter/features/customer/contractors/data/contractor_model.dart';
import 'package:template_flutter/constants/app_constants.dart';
import 'package:template_flutter/features/contractor/inbox/presentation/chat_inbox.dart';
import 'package:template_flutter/services/chat_service.dart';
import 'package:template_flutter/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
// import 'package:template_flutter/features/customer/contractors/presentation/widgets/contractor_info.dart';
import 'package:template_flutter/gen/colors.gen.dart';
// import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class DashboardInboxSection extends StatefulWidget {
	const DashboardInboxSection({super.key});


	@override
	State<DashboardInboxSection> createState() => _DashboardInboxSectionState();
}

class _DashboardInboxSectionState extends State<DashboardInboxSection> {
	final TextEditingController _searchController = TextEditingController();
	final String _currentUserId = AuthService().currentUser?.uid ?? '';

	@override
	void dispose() {
		_searchController.dispose();
		super.dispose();
	}
  

	@override
	Widget build(BuildContext context) {
		return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: SafeArea(
				child: Padding(
					padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
					child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
						children: [
              Text(
                'Inbox',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.c14181F,
                ),
              ),
							UIHelper.verticalSpace(12.h),
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
															final displayName = otherDoc.data()?['displayName'] as String?;
															final email = otherDoc.data()?['email'] as String? ?? '';
															name = displayName ?? email.split('@').first;
															initials = _initialsFromName(name);
														}

														return ContractorChatOverviewTile(
															name: name,
															serviceCategory: service,
															lastMessage: lastMessage,
															timeLabel: timeLabel,
															initials: initials,
															unreadCount: 0,
															isOnline: false,
															isSelected: false,
															onTap: () {
																// Build a minimal contractorData to pass into inbox
																final contractor = contractorData(
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

																NavigationService.navigatorKey.currentState
																		?.push(
																			MaterialPageRoute(
																				builder: (_) => ContractorChatInboxScreen(
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

 
