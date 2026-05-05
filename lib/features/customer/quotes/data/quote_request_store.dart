import 'package:rxdart/rxdart.dart';

enum QuoteRequestStatus { pending, accepted, rejected, completed }

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
      BehaviorSubject<List<QuoteRequestModel>>.seeded(_seedRequests());

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

  static List<QuoteRequestModel> _seedRequests() {
    final DateTime now = DateTime.now();
    return <QuoteRequestModel>[
      QuoteRequestModel(
        id: 'rq-3042',
        fullName: 'Sarah Mitchell',
        email: 'sarah.mitchell@example.com',
        phone: '(347) 555-0124',
        zipCode: '11215',
        serviceCategory: 'Bathroom Remodel',
        projectDetails: 'Full master bathroom renovation incl. tile + vanity.',
        submittedAt: now.subtract(const Duration(minutes: 45)),
        status: QuoteRequestStatus.pending,
      ),
      QuoteRequestModel(
        id: 'rq-3041',
        fullName: 'David Chen',
        email: 'david.chen@example.com',
        phone: '(646) 555-0148',
        zipCode: '07302',
        serviceCategory: 'Kitchen Plumbing',
        projectDetails: 'Replace kitchen sink + dishwasher hookup.',
        submittedAt: now.subtract(const Duration(hours: 2)),
        status: QuoteRequestStatus.pending,
      ),
      QuoteRequestModel(
        id: 'rq-3038',
        fullName: 'Amelia Brooks',
        email: 'amelia.brooks@example.com',
        phone: '(718) 555-0186',
        zipCode: '07030',
        serviceCategory: 'Deck Construction',
        projectDetails: 'Build a 12\'x16\' cedar deck in backyard.',
        submittedAt: now.subtract(const Duration(days: 1)),
        status: QuoteRequestStatus.accepted,
      ),
      QuoteRequestModel(
        id: 'rq-3037',
        fullName: 'Olivia Brown',
        email: 'olivia.brown@example.com',
        phone: '(212) 555-0102',
        zipCode: '10023',
        serviceCategory: 'Electrical Repair',
        projectDetails: 'Circuit breaker trips when the oven is used.',
        submittedAt: now.subtract(const Duration(days: 1, hours: 1)),
        status: QuoteRequestStatus.rejected,
      ),
      QuoteRequestModel(
        id: 'rq-3036',
        fullName: 'Daniel Brooks',
        email: 'daniel.brooks@example.com',
        phone: '(212) 555-0102',
        zipCode: '10458',
        serviceCategory: 'Roof Inspection',
        projectDetails: 'Need a roof inspection after recent storm damage.',
        submittedAt: now.subtract(const Duration(days: 1, hours: 4)),
        status: QuoteRequestStatus.rejected,
      ),
    ];
  }
}
