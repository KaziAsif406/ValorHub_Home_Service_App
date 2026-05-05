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

  final BehaviorSubject<List<QuoteRequestModel>> _requestsController =
      BehaviorSubject<List<QuoteRequestModel>>.seeded(_seedRequests());

  ValueStream<List<QuoteRequestModel>> get requestsStream =>
      _requestsController.stream;

  List<QuoteRequestModel> get requests =>
      List<QuoteRequestModel>.unmodifiable(_requestsController.value);

  void addRequest({
    required String fullName,
    required String zipCode,
    required String serviceCategory,
    required String projectDetails,
    String? contractorName,
    List<String> imagePaths = const <String>[],
    required String location,
    required String budget,
  }) {
    final QuoteRequestModel newRequest = QuoteRequestModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName.trim(),
      zipCode: zipCode.trim(),
      serviceCategory: serviceCategory.trim(),
      projectDetails: projectDetails.trim(),
      location: location.trim(),
      budget: budget.trim(),
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
        zipCode: '11215',
        serviceCategory: 'Bathroom Remodel',
        projectDetails: 'Full master bathroom renovation incl. tile + vanity.',
        location: '123 Main St, New York, NY 10001',
        budget: '\$5,000 - \$7,000',
        submittedAt: now.subtract(const Duration(minutes: 45)),
        status: QuoteRequestStatus.pending,
      ),
      QuoteRequestModel(
        id: 'rq-3041',
        fullName: 'David Chen',
        zipCode: '07302',
        serviceCategory: 'Kitchen Plumbing',
        projectDetails: 'Replace kitchen sink + dishwasher hookup.',
        location: '456 Oak Ave, Brooklyn, NY 11201',
        budget: '\$2,000 - \$3,000',
        submittedAt: now.subtract(const Duration(hours: 2)),
        status: QuoteRequestStatus.pending,
      ),
      QuoteRequestModel(
        id: 'rq-3038',
        fullName: 'Amelia Brooks',
        zipCode: '07030',
        serviceCategory: 'Deck Construction',
        projectDetails: 'Build a 12\'x16\' cedar deck in backyard.',
        location: '789 Pine Rd, Jersey City, NJ 07302',
        budget: '\$3,000 - \$5,000',
        submittedAt: now.subtract(const Duration(days: 1)),
        status: QuoteRequestStatus.accepted,
      ),
      QuoteRequestModel(
        id: 'rq-3037',
        fullName: 'Olivia Brown',
        zipCode: '10023',
        serviceCategory: 'Electrical Repair',
        projectDetails: 'Circuit breaker trips when the oven is used.',
        location: '101 Broadway, New York, NY 10001',
        budget: '\$1,000 - \$2,000',
        submittedAt: now.subtract(const Duration(days: 1, hours: 1)),
        status: QuoteRequestStatus.rejected,
      ),
      QuoteRequestModel(
        id: 'rq-3036',
        fullName: 'Daniel Brooks',
        zipCode: '10458',
        serviceCategory: 'Roof Inspection',
        projectDetails: 'Need a roof inspection after recent storm damage.',
        location: '202 Park Ave, New York, NY 10001',
        budget: '\$1,500 - \$2,500',
        submittedAt: now.subtract(const Duration(days: 1, hours: 4)),
        status: QuoteRequestStatus.rejected,
      ),
    ];
  }
}
