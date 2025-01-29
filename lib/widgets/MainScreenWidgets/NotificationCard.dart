import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NotificationCard extends StatelessWidget {
  final String? notificationText;
  final VoidCallback onStartPressed;

  const NotificationCard({
    super.key,
    required this.notificationText,
    required this.onStartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return notificationText != null
        ? Card(
            margin: EdgeInsets.only(bottom: 16.sp),
            child: Padding(
              padding: EdgeInsets.all(16.sp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.notifications_active,
                    color: Colors.blueAccent,
                    size: 32,
                  ),
                  SizedBox(width: 12.sp),
                  Text(
                    notificationText!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ElevatedButton(
              onPressed: onStartPressed,
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  inherit: false,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.sp,
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
                    Text('Start Notification'),
                  ],
                ),
              ),
            ),
          );
  }
}
