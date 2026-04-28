import 'package:rxdart/rxdart.dart';

enum QuoteRequestStatus { pending, completed }

final class QuoteRequestModel {
  QuoteRequestModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.zipCode,
    required this.serviceCategory,
    required this.projectDetails,
    required this.submittedAt,
    required this.status,
    this.contractorName,
    this.imagePaths = const <String>[],
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String zipCode;
  final String serviceCategory;
  final String projectDetails;
  final DateTime submittedAt;
  final QuoteRequestStatus status;
  final String? contractorName;
  final List<String> imagePaths;

  QuoteRequestModel copyWith({
    QuoteRequestStatus? status,
  }) {
    return QuoteRequestModel(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      zipCode: zipCode,
      serviceCategory: serviceCategory,
      projectDetails: projectDetails,
      submittedAt: submittedAt,
      status: status ?? this.status,
      contractorName: contractorName,
      imagePaths: imagePaths,
    );
  }
}

final class QuoteRequestStore {
  QuoteRequestStore._internal();
  static final QuoteRequestStore instance = QuoteRequestStore._internal();

  final BehaviorSubject<List<QuoteRequestModel>> _requestsController =
      BehaviorSubject<List<QuoteRequestModel>>.seeded(
          const <QuoteRequestModel>[]);

  ValueStream<List<QuoteRequestModel>> get requestsStream =>
      _requestsController.stream;

  List<QuoteRequestModel> get requests =>
      List<QuoteRequestModel>.unmodifiable(_requestsController.value);

  void addRequest({
    required String fullName,
    required String email,
    required String phone,
    required String zipCode,
    required String serviceCategory,
    required String projectDetails,
    String? contractorName,
    List<String> imagePaths = const <String>[],
  }) {
    final QuoteRequestModel newRequest = QuoteRequestModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName.trim(),
      email: email.trim(),
      phone: phone.trim(),
      zipCode: zipCode.trim(),
      serviceCategory: serviceCategory.trim(),
      projectDetails: projectDetails.trim(),
      contractorName: contractorName?.trim().isEmpty ?? true
          ? null
          : contractorName?.trim(),
      imagePaths: List<String>.from(imagePaths),
      submittedAt: DateTime.now(),
      status: QuoteRequestStatus.pending,
    );

    final List<QuoteRequestModel> updated = <QuoteRequestModel>[
      newRequest,
      ..._requestsController.value,
    ];
    _requestsController.sink.add(updated);
  }

  void updateStatus(String requestId, QuoteRequestStatus status) {
    final List<QuoteRequestModel> updated = _requestsController.value
        .map((QuoteRequestModel item) =>
            item.id == requestId ? item.copyWith(status: status) : item)
        .toList();
    _requestsController.sink.add(updated);
  }

  void clear() {
    _requestsController.sink.add(const <QuoteRequestModel>[]);
  }

  void dispose() {
    _requestsController.close();
  }
}
