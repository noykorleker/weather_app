import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sizer/sizer.dart';

import '../TimeFormat.dart';
import '../models/user/userBloc/user_bloc.dart';
import '../services/FirebaseService.dart';
import '../services/LocationService.dart';
import '../services/NotificationService.dart';
import '../widgets/DeleteUserButton.dart';
import '../widgets/DrawerWidget.dart';
import '../widgets/MainScreenWidgets/GreetingCard.dart';
import '../widgets/MainScreenWidgets/LocationCard.dart';
import '../widgets/MainScreenWidgets/NotificationCard.dart';
import '../widgets/MainScreenWidgets/TemperatureCard.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? _locationInfo;
  bool _isLocationGranted = false;
  bool _isNotificationGranted = false;
  String? _notificationScheduledText;
  final FirebaseService _firebaseService = FirebaseService();
  final timeFormat = TimeFormat();
  StreamSubscription<Position>? _positionStreamSubscription;
  bool isGranted = false;

  @override
  void initState() {
    super.initState();
    _initializePermissions();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializePermissions() async {
    final locationGranted = await LocationService.isLocationPermissionGranted();
    final notificationGranted =
        await AwesomeNotifications().isNotificationAllowed();

    if (!notificationGranted) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    if (!mounted) return;

    setState(() {
      _isLocationGranted = locationGranted;
      _isNotificationGranted = notificationGranted ?? false;
    });

    if (locationGranted) {
      await _retrieveLocation();
    }
  }

  Future<void> _retrieveLocation() async {
    try {
      final locationStr = await LocationService.getCurrentLocationAddress();
      if (!mounted) return;
      setState(() {
        _locationInfo = locationStr;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _locationInfo = 'Error retrieving location';
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    final granted = await LocationService.requestLocationPermission();
    if (granted) {
      setState(() {
        _isLocationGranted = true;
      });
      await _retrieveLocation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Location permission is required to display your address.'),
        ),
      );
    }
  }

  Future<void> _onStartPressed() async {
    _checkPermission();
    final scheduleTime = DateTime.now().add(const Duration(minutes: 2));
    await NotificationService.scheduleNotification(scheduleTime);
    setState(() {
      _notificationScheduledText =
          'The notification is scheduled at ${timeFormat.formatTime(scheduleTime)}';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Notification scheduled for ${timeFormat.formatTime(scheduleTime)}'),
      ),
    );
  }

  Future<void> _checkPermission() async {
    if (!_isNotificationGranted) {
      final granted = await NotificationService.requestNotificationPermission();
      setState(() {
        _isNotificationGranted = granted;
      });
      if (!granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Notification permission is required to send notifications.'),
          ),
        );
        return;
      }
    }
  }

  Future<void> _onImmediateNotification() async {
    _checkPermission();
    await NotificationService.immediateNotification();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Notification for ${timeFormat.formatTime(DateTime.now())}'),
      ),
    );
  }

  Future<void> _logout() async {
    await _firebaseService.signOut();
    context.read<UserBloc>().add(ClearUser());
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _deleteUser(String uid) async {
    try {
      await _firebaseService.deleteUser(uid);
      context.read<UserBloc>().add(ClearUser());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User deleted successfully.'),
        ),
      );
      Navigator.pushReplacementNamed(context, '/register');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          final user = state.user;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Main Screen'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: _logout,
                  tooltip: 'Logout',
                ),
              ],
            ),
            drawer: DrawerWidget(
              userEmail: user.email,
              userName: "${user.firstName} ${user.lastName}",
              gender: user.gender,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.sp),
              child: Column(
                children: [
                  GreetingCard(
                    firstName: user.firstName,
                    lastName: user.lastName,
                  ),
                  SizedBox(height: 15.sp),
                  LocationCard(
                    locationInfo: _isLocationGranted ? _locationInfo : null,
                    onRequestPermission: _requestLocationPermission,
                  ),
                  const TemperatureCard(),
                  NotificationCard(
                    notificationText: _notificationScheduledText,
                    onStartPressed: _onStartPressed,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      onPressed: _onImmediateNotification,
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          inherit: false,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.sp,
                          vertical: 20.sp,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.notifications_active,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text('Send Notification Now'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.sp),
                    child: DeleteUserButton(
                      deleteUser: () {
                        _deleteUser(user.uid);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
