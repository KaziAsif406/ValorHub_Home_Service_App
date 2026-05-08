import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PresenceStatus {
	const PresenceStatus({
		required this.isOnline,
		this.lastSeen,
	});

	final bool isOnline;
	final DateTime? lastSeen;

	factory PresenceStatus.fromSnapshot(DataSnapshot snapshot) {
		final value = snapshot.value;
		if (value is! Map) {
			return const PresenceStatus(isOnline: false);
		}

		final data = Map<String, dynamic>.from(value);
		return PresenceStatus(
			isOnline: data['isOnline'] == true,
			lastSeen: _dateTimeFromTimestamp(data['lastSeen']),
		);
	}

	String get statusText {
		if (isOnline) {
			return 'Online';
		}

		if (lastSeen != null) {
			return 'Last seen ${_formatRelativeTime(lastSeen!)}';
		}

		return 'Offline';
	}
}

class PresenceService {
	PresenceService._();

	static final PresenceService instance = PresenceService._();

	final FirebaseAuth _auth = FirebaseAuth.instance;
	final FirebaseDatabase _database = FirebaseDatabase.instance;

	StreamSubscription<DatabaseEvent>? _connectionSubscription;
	String? _activeUserId;

	DatabaseReference _statusRef(String userId) => _database.ref('status/$userId');

	Stream<PresenceStatus> watchUserPresence(String userId) {
		return _statusRef(userId).onValue.map((event) {
			return PresenceStatus.fromSnapshot(event.snapshot);
		});
	}

	Future<void> initializeForUser(String userId) async {
		if (userId.isEmpty) {
			return;
		}

		if (_activeUserId == userId && _connectionSubscription != null) {
			return;
		}

		await _connectionSubscription?.cancel();
		_connectionSubscription = null;
		_activeUserId = userId;

		final statusRef = _statusRef(userId);
		_connectionSubscription = _database.ref('.info/connected').onValue.listen(
			(event) async {
				final connected = event.snapshot.value as bool? ?? false;
				if (!connected) {
					return;
				}

				await statusRef.onDisconnect().set(_offlinePayload());
				await statusRef.set(_onlinePayload());
			},
		);
	}

	Future<void> setOfflineForUser(String userId) async {
		if (userId.isEmpty) {
			return;
		}

		await _statusRef(userId).set(_offlinePayload());
	}

	Future<void> setOfflineForCurrentUser() async {
		final userId = _auth.currentUser?.uid;
		if (userId == null || userId.isEmpty) {
			return;
		}

		await setOfflineForUser(userId);
	}

	Future<void> dispose() async {
		await _connectionSubscription?.cancel();
		_connectionSubscription = null;
		_activeUserId = null;
	}

	Map<String, dynamic> _onlinePayload() {
		return {
			'isOnline': true,
			'lastSeen': ServerValue.timestamp,
			'updatedAt': ServerValue.timestamp,
		};
	}

	Map<String, dynamic> _offlinePayload() {
		return {
			'isOnline': false,
			'lastSeen': ServerValue.timestamp,
			'updatedAt': ServerValue.timestamp,
		};
	}
}

DateTime? _dateTimeFromTimestamp(dynamic value) {
	if (value == null) {
		return null;
	}

	if (value is int) {
		return DateTime.fromMillisecondsSinceEpoch(value);
	}

	if (value is double) {
		return DateTime.fromMillisecondsSinceEpoch(value.toInt());
	}

	if (value is String) {
		final parsed = int.tryParse(value);
		if (parsed != null) {
			return DateTime.fromMillisecondsSinceEpoch(parsed);
		}
	}

	return null;
}

String _formatRelativeTime(DateTime timestamp) {
	final difference = DateTime.now().difference(timestamp);

	if (difference.inMinutes <= 0) {
		return 'just now';
	}

	if (difference.inMinutes < 60) {
		return '${difference.inMinutes}m ago';
	}

	if (difference.inHours < 24) {
		return '${difference.inHours}h ago';
	}

	if (difference.inDays < 7) {
		return '${difference.inDays}d ago';
	}

	return '${timestamp.month}/${timestamp.day}/${timestamp.year}';
}
