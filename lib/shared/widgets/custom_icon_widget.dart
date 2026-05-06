import 'package:flutter/material.dart';

class CustomIconWidget extends StatelessWidget {
  final String iconName;
  final Color? color;
  final double? size;

  const CustomIconWidget({
    super.key,
    required this.iconName,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    switch (iconName) {
      case 'add':
        iconData = Icons.add_rounded;
        break;
      case 'pill':
        iconData = Icons.medical_services_rounded;
        break;
      case 'heart':
        iconData = Icons.favorite_rounded;
        break;
      case 'medical':
        iconData = Icons.local_hospital_rounded;
        break;
      case 'snooze':
        iconData = Icons.snooze_rounded;
        break;
      default:
        iconData = Icons.help_outline_rounded;
    }

    return Icon(
      iconData,
      color: color,
      size: size,
    );
  }
}
