import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LocationCard extends StatelessWidget {
  final String? locationInfo;
  final VoidCallback onRequestPermission;

  const LocationCard({
    super.key,
    required this.locationInfo,
    required this.onRequestPermission,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: locationInfo != null
          ? Card(
              child: Padding(
                padding: EdgeInsets.all(16.sp),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 32,
                    ),
                    SizedBox(width: 12.sp),
                    Text(
                      locationInfo!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            )
          : ElevatedButton(
              onPressed: onRequestPermission,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_searching),
                  SizedBox(width: 10.sp),
                  const Text('Allow Location'),
                ],
              ),
            ),
    );
  }
}
