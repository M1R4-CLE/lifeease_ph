import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class ReminderCardWidget extends StatelessWidget {
  final Map<String, dynamic> reminderMap;
  final bool isEnglish;
  final bool bigButtonMode;
  final VoidCallback onMarkDone;
  final VoidCallback onSnooze;

  const ReminderCardWidget({
    super.key,
    required this.reminderMap,
    required this.isEnglish,
    required this.bigButtonMode,
    required this.onMarkDone,
    required this.onSnooze,
  });

  ReminderStatus _parseStatus(String s) {
    switch (s) {
      case 'done':
        return ReminderStatus.done;
      case 'snoozed':
        return ReminderStatus.snoozed;
      case 'missed':
        return ReminderStatus.missed;
      case 'upcoming':
        return ReminderStatus.upcoming;
      default:
        return ReminderStatus.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tintColor = Color(reminderMap['tintColor'] as int);
    final iconColor = Color(reminderMap['iconColor'] as int);
    final status = _parseStatus(reminderMap['status'] as String);
    final isDone = status == ReminderStatus.done;
    final title = isEnglish
        ? reminderMap['title'] as String
        : reminderMap['titleFil'] as String;
    final titleSize = bigButtonMode ? 16.0 : 15.0;

    return Dismissible(
      key: Key('reminder_${reminderMap['id']}'),
      direction: isDone ? DismissDirection.none : DismissDirection.endToStart,
      onDismissed: (_) {
        HapticFeedback.lightImpact();
        onMarkDone();
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: AppTheme.successContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 28),
            const SizedBox(width: 8),
            Text(
              isEnglish ? 'Done' : 'Tapos',
              style: GoogleFonts.nunitoSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.success,
              ),
            ),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDone ? theme.colorScheme.surfaceContainerHighest : tintColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDone
                    ? theme.colorScheme.outline.withAlpha(26)
                    : Colors.white.withAlpha(179),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: reminderMap['iconName'] as String,
                  color: isDone ? theme.colorScheme.outline : iconColor,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.nunitoSans(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w700,
                      color: isDone
                          ? theme.colorScheme.onSurfaceVariant
                          : const Color(0xFF1A1A2E),
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'clock',
                        color: isDone ? theme.colorScheme.outline : iconColor,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        reminderMap['time'] as String,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDone ? theme.colorScheme.outline : iconColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      StatusBadgeWidget(status: status, compact: true),
                    ],
                  ),
                ],
              ),
            ),
            // Actions (only for non-done reminders)
            if (!isDone) ...[
              const SizedBox(width: 8),
              Column(
                children: [
                  _ActionButton(
                    icon: 'check',
                    color: AppTheme.success,
                    tooltip: isEnglish ? 'Mark Done' : 'Markahan Tapos',
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onMarkDone();
                    },
                  ),
                  const SizedBox(height: 6),
                  _ActionButton(
                    icon: 'snooze',
                    color: const Color(0xFF0369A1),
                    tooltip: isEnglish ? 'Snooze' : 'Ipagpaliban',
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onSnooze();
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withAlpha(31),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: CustomIconWidget(iconName: icon, color: color, size: 18),
          ),
        ),
      ),
    );
  }
}
