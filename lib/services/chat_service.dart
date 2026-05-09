import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String chatIdFor(String a, String b) {
    final ids = [a, b]..sort();
    return ids.join('_');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> messagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Future<void> createChatIfNotExists(String chatId, List<String> participants) async {
    final current = FirebaseAuth.instance.currentUser;
    // Debug log to help troubleshoot permission issues
    // ignore: avoid_print
    print('ChatService.createChatIfNotExists called. authUid=${current?.uid}, chatId=$chatId, participants=$participants');
    if (current == null) {
      throw 'Not authenticated';
    }
    // Defensive validation: ensure current user is included in participants
    if (!participants.contains(current.uid)) {
      throw 'Current user (${current.uid}) must be included in participants: $participants';
    }
    final docRef = _firestore.collection('chats').doc(chatId);

    // Upsert without pre-reading. Pre-read is denied for non-existing docs by rules.
    try {
      await docRef.set({
        'participants': participants,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      // Provide a clearer error message for permission issues
      // ignore: avoid_print
      print('ChatService.createChatIfNotExists failed: $e (authUid=${current.uid}, participants=$participants)');
      rethrow;
    }
  }

  Future<void> sendTextMessage({
    required String chatId,
    required String text,
    required String senderId,
    required String senderName,
  }) async {
    final current = FirebaseAuth.instance.currentUser;
    // Debug log
    // ignore: avoid_print
    print('ChatService.sendTextMessage called. authUid=${current?.uid}, senderId=$senderId, chatId=$chatId');
    if (current == null) {
      throw 'Not authenticated';
    }
    // Ensure chat document exists and includes the sender as a participant.
    try {
      await createChatIfNotExists(chatId, [senderId]);
    } catch (e) {
      // ignore: avoid_print
      print('createChatIfNotExists before sendTextMessage failed: $e');
      rethrow;
    }
    final messagesRef = _firestore.collection('chats').doc(chatId).collection('messages');
    final msgRef = messagesRef.doc();

    await _firestore.runTransaction((tx) async {
      tx.set(msgRef, {
        'text': text,
        'senderId': senderId,
        'senderName': senderName,
        'createdAt': FieldValue.serverTimestamp(),
        'type': 'text',
        'seenBy': [senderId],
      });

      final chatRef = _firestore.collection('chats').doc(chatId);
      tx.set(chatRef, {
        'lastMessage': text,
        'lastSenderId': senderId,
        'lastUpdated': FieldValue.serverTimestamp(),
        // Ensure participants contains senderId without using array transforms on create
        'participants': FieldValue.arrayUnion([senderId])
      }, SetOptions(merge: true));
    });
  }

  Future<void> markMessagesAsSeen({
    required String chatId,
    required String currentUserId,
  }) async {

    final snapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .get();

    for (final doc in snapshot.docs) {

      final data = doc.data();

      final senderId =
          data['senderId'] ?? '';

      final seenBy =
          List<String>.from(
            data['seenBy'] ?? [],
          );

      if (
        senderId != currentUserId &&
        !seenBy.contains(currentUserId)
      ) {

        seenBy.add(currentUserId);

        await doc.reference.update({
          'seenBy': seenBy,
        });
      }
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> chatsForUser(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .snapshots();
  }

  /// Returns true if all messages in a chat have been seen by the current user,
  /// false if there are unseen messages from other users.
  Future<bool> hasSeenAllMessages({
    required String chatId,
    required String currentUserId,
  }) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final senderId = data['senderId'] ?? '';
        final seenBy = List<String>.from(data['seenBy'] ?? []);

        // If message is from another user and current user hasn't seen it
        if (senderId != currentUserId && !seenBy.contains(currentUserId)) {
          return false; // Found unseen message
        }
      }

      return true; // All messages are seen
    } catch (e) {
      // ignore: avoid_print
      print('ChatService.hasSeenAllMessages error: $e');
      return true; // Default to true (seen) on error
    }
  }

  /// Stream that emits whether all messages in a chat have been seen by the current user.
  /// This listens for real-time changes to the messages collection.
  Stream<bool> hasSeenAllMessagesStream({
    required String chatId,
    required String currentUserId,
  }) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .snapshots()
        .map((snapshot) {
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final senderId = data['senderId'] ?? '';
        final seenBy = List<String>.from(data['seenBy'] ?? []);

        // If message is from another user and current user hasn't seen it
        if (senderId != currentUserId && !seenBy.contains(currentUserId)) {
          return false; // Found unseen message
        }
      }

      return true; // All messages are seen
    });
  }
}
