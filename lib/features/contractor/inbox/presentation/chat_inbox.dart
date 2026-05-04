import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/features/contractor/inbox/presentation/widget/chat_bubble.dart';
import 'package:template_flutter/features/contractor/inbox/presentation/widget/composer.dart';
import 'package:template_flutter/features/contractor/inbox/presentation/widget/inbox_header.dart';
import 'package:template_flutter/features/customer/contractors/presentation/widgets/contractor_info.dart';

class ContractorChatInboxScreen extends StatefulWidget {
  const ContractorChatInboxScreen({
    super.key,
    required this.contractor,
    required this.isOnline,
  });

  final contractorData contractor;
  final bool isOnline;

  @override
  State<ContractorChatInboxScreen> createState() => _ContractorChatInboxScreenState();
}

class _ContractorChatInboxScreenState extends State<ContractorChatInboxScreen> {
  final TextEditingController _messageController = TextEditingController();
  late final List<ContractorChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = _buildConversation();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          children: [
            ContractorInboxHeader(
              name: widget.contractor.name,
              service: widget.contractor.service,
              isOnline: widget.isOnline,
              initials: _initialsFromName(widget.contractor.name),
              onBack: () => Navigator.of(context).pop(),
              onCall: () {},
              onMore: () {},
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ContractorChatBubble(message: message);
                },
              ),
            ),
            ContractorChatComposer(controller: _messageController),
          ],
        ),
      ),
    );
  }

  List<ContractorChatMessage> _buildConversation() {
    return [
      const ContractorChatMessage(
        text: 'Hi! Thanks for accepting my request.',
        time: '9:58 AM',
        isMe: false,
      ),
      const ContractorChatMessage(
        text: 'Of course - happy to help with the project.',
        time: '10:01 AM',
        isMe: true,
      ),
      ContractorChatMessage(
        text:
            'Do you typically use cedar or composite for ${widget.contractor.service.toLowerCase()}?',
        time: '10:04 AM',
        isMe: false,
      ),
      const ContractorChatMessage(
        text: 'Both work great. I can walk you through options and bring samples.',
        time: '10:12 AM',
        isMe: true,
      ),
      const ContractorChatMessage(
        text: 'Sounds good - can we schedule a site visit Friday?',
        time: '10:32 AM',
        isMe: false,
      ),
    ];
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
