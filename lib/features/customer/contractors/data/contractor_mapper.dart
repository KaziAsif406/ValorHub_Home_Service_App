import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template_flutter/constants/app_constants.dart';
import 'package:template_flutter/features/customer/contractors/data/contractor_model.dart';

contractorData? mapDocToContractor(DocumentSnapshot doc) {
  final Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};
  final bool isProfileCompleted = (data[kKeyProfileCompleted] as bool?) == true ||
      (data['profile_complete'] as bool?) == true;
  if (!isProfileCompleted) return null;

  final String name = (data['displayName'] as String?) ?? (data[kEmail] as String?) ?? 'Contractor';
  final String mail = (data[kEmail] as String?) ?? '';
  final String service = (data[kKeyServiceCategory] as String?) ?? 'General';
  final int experience = (data[kKeyExperienceYears] is int)
      ? data[kKeyExperienceYears] as int
      : int.tryParse(data[kKeyExperienceYears]?.toString() ?? '0') ?? 0;
  final String city = (data[kKeyCity] as String?) ?? '';
  final String state = (data[kKeyState] as String?) ?? '';
  final String zip = (data[kKeyZipCode] as String?) ?? '';
  final String location = [if (city.isNotEmpty) city, if (state.isNotEmpty) state].join(', ');
  final String phone = (data[kKeyMobileNumber] as String?) ?? '';
  final String description = (data[kKeyDescription] as String?) ?? '';

  return contractorData(
    id: doc.id,
    name: name,
    service: service,
    rating: (data['rating'] is num) ? (data['rating'] as num).toDouble() : 0.0,
    reviews: (data['reviews'] is int) ? data['reviews'] as int : 0,
    location: location.isNotEmpty ? location : zip,
    zipCode: zip,
    experience: experience,
    description: description,
    phone: phone,
    mail: mail,
  );
}
