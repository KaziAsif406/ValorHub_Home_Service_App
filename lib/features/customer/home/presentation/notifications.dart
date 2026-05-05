import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/features/customer/home/presentation/widgets/notification_tile.dart';

class NotificationsScreen extends StatelessWidget {
	const NotificationsScreen({super.key});

	static const List<_NotificationData> _notifications = [
		_NotificationData(
			iconPath: 'assets/icons/quotes.png',
			title: 'Quote Received',
			description: 'Mike Johnson sent you a quote for plumbing repair.',
			time: '2 min ago',
			isRead: false,
		),
		_NotificationData(
			iconPath: 'assets/icons/new_msg.png',
			title: 'New Message',
			description: 'Sarah Williams replied to your inquiry.',
			time: '1 hour ago',
			isRead: false,
		),
		_NotificationData(
			iconPath: 'assets/icons/request.png',
			title: 'Request Updated',
			description: 'Your quote request #1234 has been viewed.',
			time: '3 hours ago',
			isRead: true,
		),
	];

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: AppColors.scaffoldColor,
			appBar: AppBar(
				backgroundColor: AppColors.allSecondaryColor,
				elevation: 0,
				leading: IconButton(
					icon: Icon(
						Icons.arrow_back_ios_new_outlined,
						size: 20.sp,
						color: AppColors.c14181F,
					),
					onPressed: () => NavigationService.goBack,
				),
				title: Text(
					'Notification',
					style: TextFontStyle.textStyle16c14181FInter600,
				),
			),
			body: SafeArea(
				child: ListView.separated(
					padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
					itemCount: _notifications.length,
					separatorBuilder: (_, __) => SizedBox(height: 16.h),
					itemBuilder: (context, index) {
						final notification = _notifications[index];
						return NotificationTile(
							iconPath: notification.iconPath,
							title: notification.title,
							description: notification.description,
							time: notification.time,
							isRead: notification.isRead,
							onTap: () {},
						);
					},
				),
			),
		);
	}
}

class _NotificationData {
	const _NotificationData({
		required this.iconPath,
		required this.title,
		required this.description,
		required this.time,
		required this.isRead,
	});

	final String iconPath;
	final String title;
	final String description;
	final String time;
	final bool isRead;
}
