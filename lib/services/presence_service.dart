import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:template_flutter/helpers/realtime_database.dart';

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
  PresenceService._internal();

  static final PresenceService _instance = PresenceService._internal();

  factory PresenceService() => _instance;

  final DatabaseReference _db = AppRealtimeDatabase.instance.ref();

  StreamSubscription<User?>? _authSub;
  StreamSubscription<DatabaseEvent>? _connectedSub;
  String? _currentUid;

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

  /// Start presence service — listens for auth changes and hooks Realtime DB
  /// presence behavior for the signed-in user. Safe to call once at app startup.
  void start() {
    // Cancel existing subscription if present
    _authSub?.cancel();
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        // user signed out — mark previous user offline and cancel listeners
        if (_currentUid != null) {
          _setOffline(_currentUid!);
        }
        _currentUid = null;
        _connectedSub?.cancel();
        _connectedSub = null;
        // debug
        // ignore: avoid_print
        print('PresenceService: auth state - signed out');
        return;
      }

      // new user signed in
      if (_currentUid == user.uid) return;
      _currentUid = user.uid;
      _setupPresenceForUid(_currentUid!);
      // debug
      // ignore: avoid_print
      print('PresenceService: auth state - signed in ($_currentUid)');
    });
  }

  Future<void> _setOffline(String uid) async {
    try {
      await _db.child('status/$uid').set({
        'isOnline': false,
        'lastSeen': ServerValue.timestamp,
      });
      // ignore: avoid_print
      print('PresenceService: set offline for $uid');
    } catch (e) {
      // ignore: avoid_print
      print('PresenceService: failed to set offline for $uid: $e');
    }
  }

  /// Public wrapper to set a given uid offline immediately.
  /// Useful to call before performing a sign-out so the DB reflects offline state.
  Future<void> setOfflineForUid(String uid) async {
    await _setOffline(uid);
  }

  void _setupPresenceForUid(String uid) {
    // Cancel previous connected listener
    _connectedSub?.cancel();
    final connectedRef = AppRealtimeDatabase.instance.ref('.info/connected');
    final userStatusRef = _db.child('status/$uid');

    _connectedSub = connectedRef.onValue.listen((event) async {
      final connected = event.snapshot.value as bool? ?? false;
      if (!connected) return;

      try {
        // When user disconnects
        await userStatusRef.onDisconnect().set({
          'isOnline': false,
          'lastSeen': ServerValue.timestamp,
        });

        // When user is online
        await userStatusRef.set({
          'isOnline': true,
          'lastSeen': ServerValue.timestamp,
        });

        // ignore: avoid_print
        print('PresenceService: set online for $uid');
      } catch (e) {
        // ignore: avoid_print
        print('PresenceService: presence setup error for $uid: $e');
      }
    });
  }

  /// Stop presence service and cancel subscriptions
  void dispose() {
    _authSub?.cancel();
    _connectedSub?.cancel();
    _authSub = null;
    _connectedSub = null;
  }
}
