import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

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

  /// Stream of quote requests stored in Firestore. Maps documents into model list.
  ValueStream<List<QuoteRequestModel>> get requestsStream {
    final controller = BehaviorSubject<List<QuoteRequestModel>>();

    _firestore.collection('quote_requests').orderBy('submittedAt', descending: true).snapshots().listen(
      (QuerySnapshot snap) {
        final List<QuoteRequestModel> items = snap.docs.map((d) => _fromDoc(d)).toList();
        controller.add(items);
      },
      onError: (e) => controller.addError(e),
    );

    return controller.stream;
  }

  List<QuoteRequestModel> get requests => <QuoteRequestModel>[]; // kept for compatibility

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

    await _firestore.collection('quote_requests').doc(docId).set(payload);

    return requestId;
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
