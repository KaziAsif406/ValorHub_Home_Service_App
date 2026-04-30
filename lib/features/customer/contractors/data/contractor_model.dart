class contractorData {
  const contractorData({
    required this.name,
    required this.service,
    required this.rating,
    required this.reviews,
    required this.location,
    required this.experience,
    required this.description,
    required this.phone,
  });

  final String name;
  final String service;
  final double rating;
  final int reviews;
  final String location;
  final int experience;
  final String description;
  final String phone;
}
