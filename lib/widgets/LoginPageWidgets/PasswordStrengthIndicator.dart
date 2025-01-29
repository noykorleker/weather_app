import 'package:flutter/material.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  final String Function(String) calculateStrength;
  final Color Function(String) getStrengthColor;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    required this.calculateStrength,
    required this.getStrengthColor,
  });

  @override
  Widget build(BuildContext context) {
    final strength = calculateStrength(password);
    final color = getStrengthColor(strength);
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Password Strength: $strength',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
