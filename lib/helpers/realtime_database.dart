import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';


class AppRealtimeDatabase {
  static const String databaseUrl =
      'https://valorhub-ea8ff-default-rtdb.asia-southeast1.firebasedatabase.app';

  static FirebaseDatabase get instance => FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: databaseUrl,
      );
}