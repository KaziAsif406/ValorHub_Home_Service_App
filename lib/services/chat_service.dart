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
    final docRef = _firestore.collection('chats').doc(chatId);
    
    // Check if chat already exists
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      // Chat already exists, don't overwrite lastMessage or other fields
      return;
    }
    
    // Create new chat document only if it doesn't exist
    await docRef.set({
      'participants': participants,
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': '',
      'lastUpdated': FieldValue.serverTimestamp(),
    });
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
}
