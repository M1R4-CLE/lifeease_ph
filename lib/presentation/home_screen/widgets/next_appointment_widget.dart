
import '../../../core/app_export.dart';

class NextAppointmentWidget extends StatelessWidget {
  final bool isEnglish;
  final List<Map<String, dynamic>> reminderMaps;

  const NextAppointmentWidget({
    super.key,
    required this.isEnglish,
    required this.reminderMaps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sectionLabel = isEnglish
        ? 'Your Next Reminder'
        : 'Susunod na Paalala';
    final countLabel =
        '${reminderMaps.length} ${isEnglish ? 'upcoming' : 'darating'}';

    if (reminderMaps.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.success,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                isEnglish
                    ? 'No upcoming reminders today!'
                    : 'Walang darating na paalala ngayon!',
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final reminder = reminderMaps.first;
    final tintColor = Color(reminder['tintColor'] as int);
    final iconColor = Color(reminder['iconColor'] as int);
    final title = isEnglish
        ? reminder['title'] as String
        : reminder['titleFil'] as String;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: tintColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionLabel,
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: iconColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(179),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  countLabel,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: iconColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(204),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: reminder['iconName'] as String,
                    color: iconColor,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A2E),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'calendar',
                          color: iconColor,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          reminder['date'] as String,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: iconColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        CustomIconWidget(
                          iconName: 'clock',
                          color: iconColor,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          reminder['time'] as String,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: iconColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
