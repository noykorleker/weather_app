import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:weather_app/services/HeartbeatService.dart';
import 'package:weather_app/services/LocationService.dart';
import 'package:weather_app/services/WeatherService.dart';

import 'ThemeManager.dart';
import 'models/user/userBloc/user_bloc.dart';
import 'screens/AuthWrapper.dart';
import 'screens/ForgotPasswordScreen.dart';
import 'screens/LoginScreen.dart';
import 'screens/MainScreen.dart';
import 'screens/RegistrationScreen.dart';
import 'services/AppLifecycleHandler.dart';
import 'services/FirebaseService.dart';
import 'services/NotificationService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeServices();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(FirebaseService()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

/// Initializes essential services before the app starts
Future<void> _initializeServices() async {
  NotificationService.initialize();
  tz.initializeTimeZones();
  await FirebaseService.initializeFirebase();
  AppLifecycleHandler.initialize();
  await LocationService.initializeAndCacheLocation();
  await WeatherService.initializeWeather();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  final heartbeatService = HeartbeatService(
    interval: Duration(seconds: 30),
    onHeartbeatStart: () => print("Heartbeat started."),
    onHeartbeatStop: () => print("Heartbeat stopped."),
    onHeartbeat: (timestamp) => print("Heartbeat sent at $timestamp."),
  );

// Dispose of the service when done
  @override
  void dispose() {
    heartbeatService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Weather App',
          theme: ThemeManager.lightTheme,
          darkTheme: ThemeManager.darkTheme,
          themeMode: ThemeMode.system,
          home: const AuthWrapper(),
          routes: _buildRoutes(),
          onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: Text('Page Not Found')),
              body: const Center(child: Text('404 - Page Not Found')),
            ),
          ),
        );
      },
    );
  }

  /// Defines all app routes in one place
  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/auth': (context) => const AuthWrapper(),
      '/login': (context) => const LoginScreen(),
      '/register': (context) => const RegistrationScreen(),
      '/main': (context) => const MainScreen(),
      '/forgot-password': (context) => const ForgotPasswordScreen(),
    };
  }
}
