import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/model/reminder.dart';
import '../theme/app_theme.dart';

class StatusBadgeWidget extends StatelessWidget {
  final ReminderStatus status;
  final bool compact;

  const StatusBadgeWidget({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case ReminderStatus.done:
        color = AppTheme.success;
        label = 'Done';
        icon = Icons.check_circle_rounded;
        break;
      case ReminderStatus.missed:
        color = AppTheme.errorColor;
        label = 'Missed';
        icon = Icons.error_rounded;
        break;
      case ReminderStatus.snoozed:
        color = const Color(0xFF0369A1);
        label = 'Snoozed';
        icon = Icons.snooze_rounded;
        break;
      case ReminderStatus.upcoming:
        color = AppTheme.warning;
        label = 'Upcoming';
        icon = Icons.upcoming_rounded;
        break;
      default:
        color = AppTheme.primary;
        label = 'Pending';
        icon = Icons.pending_rounded;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 12 : 14, color: color),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
