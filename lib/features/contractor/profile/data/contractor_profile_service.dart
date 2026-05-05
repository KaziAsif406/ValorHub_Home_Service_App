import 'package:cloud_firestore/cloud_firestore.dart';

class ContractorProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> fetchProfileByUserId(String userId) async {
    final snapshot = await _firestore.collection('users').doc(userId).get();
    if (!snapshot.exists) return null;
    return snapshot.data();
  }
}
