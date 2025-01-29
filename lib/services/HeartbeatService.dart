import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'FirebaseService.dart';

class HeartbeatService with WidgetsBindingObserver {
  Timer? _timer;
  bool _isHeartbeatWriting = false; // Flag for throttling
  final Duration interval;

  // Optional callbacks for events
  final VoidCallback? onHeartbeatStart;
  final VoidCallback? onHeartbeatStop;
  final ValueChanged<String>? onHeartbeat;

  HeartbeatService({
    required this.interval,
    this.onHeartbeatStart,
    this.onHeartbeatStop,
    this.onHeartbeat,
  }) {
    WidgetsBinding.instance.addObserver(this);
    _startHeartbeat();
  }

  /// Start the heartbeat timer
  void _startHeartbeat() {
    if (_timer != null && _timer!.isActive) {
      print("Heartbeat timer already running.");
      return;
    }

    print("Starting heartbeat timer...");
    onHeartbeatStart?.call();

    _timer = Timer.periodic(interval, (_) async {
      final String timestamp = _getFormattedTimestamp();

      print("Heartbeat at $timestamp");
      onHeartbeat?.call(timestamp);

      // Send heartbeat to Firebase
      await _sendHeartbeatToFirebase(timestamp);
    });
  }

  /// Format timestamp to 'HH:mm:ss yyyy-MM-dd'
  String _getFormattedTimestamp() {
    final DateTime now = DateTime.now();
    return DateFormat('HH:mm:ss yyyy-MM-dd').format(now);
  }

  /// Send heartbeat to Firebase with throttle
  Future<void> _sendHeartbeatToFirebase(String timestamp) async {
    if (_isHeartbeatWriting) return; // Prevent overlapping calls
    _isHeartbeatWriting = true;

    try {
      final firebaseService = FirebaseService();
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await firebaseService.writeHeartbeatToDatabase(user.uid, timestamp);
      } else {
        print("No authenticated user. Skipping heartbeat.");
      }
    } catch (e) {
      print("Error sending heartbeat: $e");
    } finally {
      _isHeartbeatWriting = false;
    }
  }

  /// Stop the heartbeat timer
  void _stopHeartbeat() {
    if (_timer != null && _timer!.isActive) {
      print("Stopping heartbeat timer...");
      _timer?.cancel();
      _timer = null;
      onHeartbeatStop?.call();
    }
  }

  /// App lifecycle changes handler
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("App resumed. Restarting heartbeat...");
        _startHeartbeat();
        break;
      case AppLifecycleState.paused:
        print("App paused. Stopping heartbeat...");
        _stopHeartbeat();
        break;
      default:
        break;
    }
  }

  /// Clean up resources
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopHeartbeat();
  }
}
