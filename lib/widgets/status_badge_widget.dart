import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum ReminderStatus { pending, done, snoozed, missed, upcoming }

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
    final config = _getConfig(status);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: compact ? 10 : 12, color: config.textColor),
          SizedBox(width: 4),
          Text(
            config.label,
            style: GoogleFonts.nunitoSans(
              fontSize: compact ? 10 : 12,
              fontWeight: FontWeight.w700,
              color: config.textColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeConfig _getConfig(ReminderStatus status) {
    switch (status) {
      case ReminderStatus.pending:
        return _BadgeConfig(
          label: 'Pending',
          icon: Icons.schedule_rounded,
          backgroundColor: AppTheme.warningContainer,
          textColor: AppTheme.warning,
        );
      case ReminderStatus.done:
        return _BadgeConfig(
          label: 'Done',
          icon: Icons.check_circle_rounded,
          backgroundColor: AppTheme.successContainer,
          textColor: AppTheme.success,
        );
      case ReminderStatus.snoozed:
        return _BadgeConfig(
          label: 'Snoozed',
          icon: Icons.snooze_rounded,
          backgroundColor: Color(0xFFE0F2FE),
          textColor: Color(0xFF0369A1),
        );
      case ReminderStatus.missed:
        return _BadgeConfig(
          label: 'Missed',
          icon: Icons.warning_rounded,
          backgroundColor: AppTheme.errorContainer,
          textColor: AppTheme.errorColor,
        );
      case ReminderStatus.upcoming:
        return _BadgeConfig(
          label: 'Upcoming',
          icon: Icons.upcoming_rounded,
          backgroundColor: AppTheme.primaryContainer,
          textColor: AppTheme.primary,
        );
    }
  }
}

class _BadgeConfig {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;

  _BadgeConfig({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
  });
}
