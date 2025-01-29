import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static Future<void> initialize() async {
    AwesomeNotifications().initialize(
      null, // Default notification icon
      [
        NotificationChannel(
          channelKey: 'scheduled_channel',
          channelName: 'Scheduled Notifications',
          channelDescription: 'Channel for scheduled notifications',
          importance: NotificationImportance.Max,
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
        ),
      ],
    );
  }

  static Future<bool> requestNotificationPermission() async {
    return await AwesomeNotifications().isNotificationAllowed();
  }

  static Future<void> showNotification(String title, String body) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'scheduled_channel',
        title: title,
        body: body,
        category: NotificationCategory.Alarm,
        fullScreenIntent: true,
        wakeUpScreen: true,
        notificationLayout: NotificationLayout.Default,
        actionType: ActionType.KeepOnTop,
      ),
    );
  }

  void requestNotificationPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

    if (!isAllowed) {
      // Request permission from the user
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static Future<void> scheduleNotification(DateTime scheduleTime) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'scheduled_channel',
        title: 'Scheduled Notification',
        body: 'This notification is scheduled to appear!',
        category: NotificationCategory.Alarm,
        fullScreenIntent: true,
        wakeUpScreen: true,
        notificationLayout: NotificationLayout.Default,
        actionType: ActionType.KeepOnTop,
      ),
      schedule: NotificationCalendar.fromDate(date: scheduleTime),
    );
  }

  static Future<void> immediateNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'scheduled_channel',
        title: 'Hello!',
        body: 'This is a test notification.',
        category: NotificationCategory.Alarm,
        fullScreenIntent: true,
        wakeUpScreen: true,
      ),
    );
  }

  static Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}
