import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:timeago/timeago.dart' as timeago;

class PresenceState {
  PresenceState({
    required this.isOnline,
    required this.lastSeenMillis,
  });

  final bool isOnline;
  final int? lastSeenMillis;

  String get label {
    if (isOnline) return 'Online';
    if (lastSeenMillis == null) return 'Offline';

    final lastSeen = DateTime.fromMillisecondsSinceEpoch(lastSeenMillis!);
    return 'Last seen ${timeago.format(lastSeen)}';
  }
}

class PresenceService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  static PresenceState parseRealtimeStatus(dynamic raw) {
    if (raw is! Map) {
      return PresenceState(isOnline: false, lastSeenMillis: null);
    }

    final dynamic isOnlineRaw = raw['isOnline'];
    final dynamic lastSeenRaw = raw['lastSeen'];

    final isOnline = isOnlineRaw is bool
        ? isOnlineRaw
        : (isOnlineRaw?.toString().toLowerCase() == 'true');

    int? lastSeenMillis;
    if (lastSeenRaw is int) {
      lastSeenMillis = lastSeenRaw;
    } else if (lastSeenRaw is num) {
      lastSeenMillis = lastSeenRaw.toInt();
    } else if (lastSeenRaw is String) {
      lastSeenMillis = int.tryParse(lastSeenRaw);
    }

    return PresenceState(isOnline: isOnline, lastSeenMillis: lastSeenMillis);
  }

  void initializePresence() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) return;

    final connectedRef = FirebaseDatabase.instance.ref('.info/connected');

    final userStatusRef = _db.child('status/$uid');

    connectedRef.onValue.listen((event) async {
      final connected = event.snapshot.value as bool? ?? false;

      if (!connected) return;

      /// When user disconnects
      await userStatusRef.onDisconnect().set({
        'isOnline': false,
        'lastSeen': ServerValue.timestamp,
      });

      /// When user is online
      await userStatusRef.set({
        'isOnline': true,
        'lastSeen': ServerValue.timestamp,
      });
    });
  }
}
