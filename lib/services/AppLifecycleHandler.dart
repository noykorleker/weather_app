import 'package:flutter/services.dart';

class AppLifecycleHandler {
  static const MethodChannel _channel = MethodChannel("app_events");

  static void initialize() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "onAppSwiped":
          print("App was swiped away on Android");
          // Handle app swipe event
          break;

        case "onAppTerminated":
          print("App was terminated on iOS");
          // Handle app termination
          break;

        case "onAppBackgrounded":
          print("App entered background");
          // Handle app entering background
          break;

        case "onAppForegrounded":
          print("App entered foreground");
          // Handle app coming to foreground
          break;

        case "onAppError":
          final String? error = call.arguments as String?;
          print("An error occurred in the app: $error");
          // Handle app errors
          break;

        case "onInitializationComplete":
          print("App initialization completed successfully");
          break;

        default:
          print("Unhandled method: ${call.method}");
          break;
      }
      return null; // Ensure a value is returned
    });
  }
}
