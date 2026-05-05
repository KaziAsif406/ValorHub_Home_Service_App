import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum QuoteRequestStatus { pending, accepted, rejected, completed }

final class QuoteRequestModel {
  QuoteRequestModel({
    required this.id,
    required this.fullName,
    required this.zipCode,
    required this.serviceCategory,
    required this.projectDetails,
    required this.submittedAt,
    required this.status,
    required this.location,
    required this.budget,
    this.contractorName,
    this.imagePaths = const <String>[],
  });

  final String id;
  final String fullName;
  final String zipCode;
  final String serviceCategory;
  final String projectDetails;
  final DateTime submittedAt;
  final QuoteRequestStatus status;
  final String? contractorName;
  final List<String> imagePaths;
  final String location;
  final String budget;

  QuoteRequestModel copyWith({
    QuoteRequestStatus? status,
  }) {
    return QuoteRequestModel(
      id: id,
      fullName: fullName,
      zipCode: zipCode,
      serviceCategory: serviceCategory,
      projectDetails: projectDetails,
      submittedAt: submittedAt,
      status: status ?? this.status,
      contractorName: contractorName,
      imagePaths: imagePaths,
      location: location,
      budget: budget,
    );
  }
}

final class QuoteRequestStore {
  QuoteRequestStore._internal();
  static final QuoteRequestStore instance = QuoteRequestStore._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Backward-compatible stream for the signed-in customer's own requests.
  Stream<List<QuoteRequestModel>> get requestsStream {
    final String? customerId = FirebaseAuth.instance.currentUser?.uid;
    if (customerId == null || customerId.isEmpty) {
      return Stream<List<QuoteRequestModel>>.value(const <QuoteRequestModel>[]);
    }

    return customerRequestsStream(customerId);
  }

  List<QuoteRequestModel> get requests => <QuoteRequestModel>[];

  Stream<List<QuoteRequestModel>> customerRequestsStream(String customerId) {
    return _firestore
        .collection('quote_requests')
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .map((QuerySnapshot snap) => _sortedFromDocs(snap.docs));
  }

  Stream<List<QuoteRequestModel>> contractorRequestsStream(String contractorId) {
    return _firestore
        .collection('quote_requests')
        .where('contractorId', isEqualTo: contractorId)
        .snapshots()
        .map((QuerySnapshot snap) => _sortedFromDocs(snap.docs));
  }

  Future<String> addRequest({
    required String fullName,
    required String zipCode,
    required String serviceCategory,
    required String projectDetails,
    String? contractorId,
    String? contractorName,
    List<String> imagePaths = const <String>[],
    required String location,
    required String budget,
  }) async {
    final int rand = Random().nextInt(9000) + 1000;
    final String requestId = '#REQ-$rand';
    final String docId = 'REQ-$rand';

    final String? customerId = FirebaseAuth.instance.currentUser?.uid;

    final Map<String, dynamic> payload = <String, dynamic>{
      'requestId': requestId,
      'customerId': customerId,
      'contractorId': contractorId,
      'contractorName': contractorName,
      'fullName': fullName.trim(),
      'zipCode': zipCode.trim(),
      'serviceCategory': serviceCategory.trim(),
      'projectDetails': projectDetails.trim(),
      'location': location.trim(),
      'budget': budget.trim(),
      'imagePaths': imagePaths,
      'status': 'pending',
      'submittedAt': FieldValue.serverTimestamp(),
    };

    try {
      await _firestore.collection('quote_requests').doc(docId).set(payload);
      return requestId;
    } on FirebaseException catch (fe) {
      // rethrow with clearer message
      throw Exception('Firestore error (${fe.code}): ${fe.message}');
    } catch (e) {
      throw Exception('Failed to save quote request: ${e.toString()}');
    }
  }

  Future<void> updateStatus(String requestId, QuoteRequestStatus status) async {
    final String docId = requestId.replaceFirst('#', '');
    await _firestore.collection('quote_requests').doc(docId).update({
      'status': status.name,
    });
  }

  static QuoteRequestModel _fromDoc(QueryDocumentSnapshot d) {
    final Map<String, dynamic> data = d.data() as Map<String, dynamic>;

    final Timestamp? ts = data['submittedAt'] as Timestamp?;
    return QuoteRequestModel(
      id: data['requestId'] as String? ?? d.id,
      fullName: data['fullName'] as String? ?? '',
      zipCode: data['zipCode'] as String? ?? '',
      serviceCategory: data['serviceCategory'] as String? ?? '',
      projectDetails: data['projectDetails'] as String? ?? '',
      location: data['location'] as String? ?? '',
      budget: data['budget'] as String? ?? '',
      imagePaths: (data['imagePaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          <String>[],
      submittedAt: ts?.toDate() ?? DateTime.now(),
      status: _StatusFromString(data['status'] as String?),
      contractorName: data['contractorName'] as String?,
    );
  }

  static List<QuoteRequestModel> _sortedFromDocs(List<QueryDocumentSnapshot> docs) {
    final List<QuoteRequestModel> items = docs.map(_fromDoc).toList();
    items.sort((QuoteRequestModel a, QuoteRequestModel b) {
      return b.submittedAt.compareTo(a.submittedAt);
    });
    return items;
  }

  static QuoteRequestStatus _StatusFromString(String? s) {
    switch (s) {
      case 'accepted':
        return QuoteRequestStatus.accepted;
      case 'rejected':
        return QuoteRequestStatus.rejected;
      case 'completed':
        return QuoteRequestStatus.completed;
      case 'pending':
      default:
        return QuoteRequestStatus.pending;
    }
  }
}
