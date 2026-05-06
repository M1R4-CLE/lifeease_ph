import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../../data/model/emergency_contact.dart';

class EmergencyFabWidget extends StatelessWidget {
  final List<EmergencyContact> contacts;
  final bool showCountdown;

  const EmergencyFabWidget({
    super.key,
    required this.contacts,
    this.showCountdown = false,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      onPressed: () {
        // Implementation for emergency call/countdown
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Emergency feature triggered')),
        );
      },
      backgroundColor: AppTheme.emergencyRed,
      child: const Icon(Icons.emergency_rounded, color: Colors.white, size: 36),
    );
  }
}
