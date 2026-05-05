import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/features/contractor/inbox/presentation/widget/chat_bubble.dart';
import 'package:template_flutter/features/customer/contractors/data/contractor_model.dart';
import 'package:template_flutter/features/contractor/inbox/presentation/widget/composer.dart';
import 'package:template_flutter/features/contractor/inbox/presentation/widget/inbox_header.dart';
import 'package:template_flutter/services/chat_service.dart';
import 'package:template_flutter/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
  late final String _chatId;
  late final String _myId;

  @override
  void initState() {
    super.initState();
    final auth = AuthService();
    _myId = auth.currentUser?.uid ?? '';
    _chatId = ChatService.chatIdFor(_myId, widget.contractor.id);
    ChatService().createChatIfNotExists(_chatId, [_myId, widget.contractor.id]);
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
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: ChatService().messagesStream(_chatId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return const SizedBox();
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data?.docs ?? [];
                  final messages = docs.map((d) {
                    final data = d.data();
                    final text = data['text'] as String? ?? '';
                    final created = data['createdAt'] as Timestamp?;
                    final time = created != null
                        ? DateFormat('h:mm a').format(created.toDate())
                        : '';
                    final isMe = (data['senderId'] as String? ?? '') == _myId;
                    return ContractorChatMessage(text: text, time: time, isMe: isMe);
                  }).toList();

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ContractorChatBubble(message: message);
                    },
                  );
                },
              ),
            ),
            ContractorChatComposer(
              controller: _messageController,
              onSend: () async {
                final text = _messageController.text.trim();
                if (text.isEmpty) return;
                final auth = AuthService();
                final senderName = auth.currentUser?.displayName ?? '';
                await ChatService().sendTextMessage(
                  chatId: _chatId,
                  text: text,
                  senderId: _myId,
                  senderName: senderName,
                );
                _messageController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
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
