// // To parse this JSON data, do
// //
// //     final profileResModel = profileResModelFromJson(jsonString);

// import 'dart:convert';

// ProfileResModel profileResModelFromJson(String str) => ProfileResModel.fromJson(json.decode(str));

// String profileResModelToJson(ProfileResModel data) => json.encode(data.toJson());

// class ProfileResModel {
//     bool? success;
//     String? message;
//     Data? data;

//     ProfileResModel({
//         this.success,
//         this.message,
//         this.data,
//     });

//     factory ProfileResModel.fromJson(Map<String, dynamic> json) => ProfileResModel(
//         success: json["success"],
//         message: json["message"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "success": success,
//         "message": message,
//         "data": data?.toJson(),
//     };
// }

// class Data {
//     User? user;

//     Data({
//         this.user,
//     });

//     factory Data.fromJson(Map<String, dynamic> json) => Data(
//         user: json["user"] == null ? null : User.fromJson(json["user"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "user": user?.toJson(),
//     };
// }

// class User {
//     int? id;
//     String? name;
//     String? email;
//     String? phone;
//     DateTime? registeredDate;

//     User({
//         this.id,
//         this.name,
//         this.email,
//         this.phone,
//         this.registeredDate,
//     });

//     factory User.fromJson(Map<String, dynamic> json) => User(
//         id: json["id"],
//         name: json["name"],
//         email: json["email"],
//         phone: json["phone"],
//         registeredDate: json["registered_date"] == null ? null : DateTime.parse(json["registered_date"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "phone": phone,
//         "registered_date": registeredDate?.toIso8601String(),
//     };
// }
