import 'package:flutter/material.dart';

class GreetingCard extends StatelessWidget {
  final String firstName;
  final String lastName;

  const GreetingCard({
    super.key,
    required this.firstName,
    required this.lastName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              child: Text('${firstName[0]}${lastName[0]}'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Hello $firstName $lastName, how are you today?',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
