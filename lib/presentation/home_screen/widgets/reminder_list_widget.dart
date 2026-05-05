
import '../../../core/app_export.dart';
import './reminder_card_widget.dart';

class ReminderListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> reminderMaps;
  final bool isEnglish;
  final bool bigButtonMode;
  final Function(String id, String newStatus) onStatusChanged;

  const ReminderListWidget({
    super.key,
    required this.reminderMaps,
    required this.isEnglish,
    required this.bigButtonMode,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sectionLabel = isEnglish ? "Today's Reminders" : "Mga Paalala Ngayon";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              sectionLabel,
              style: GoogleFonts.nunitoSans(
                fontSize: bigButtonMode ? 20 : 18,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              '${reminderMaps.length} ${isEnglish ? 'total' : 'lahat'}',
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (reminderMaps.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(
                    Icons.task_alt_rounded,
                    size: 56,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isEnglish
                        ? 'No reminders for today!'
                        : 'Walang paalala ngayon!',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reminderMaps.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final reminder = reminderMaps[index];
              return _AnimatedReminderItem(
                index: index,
                child: ReminderCardWidget(
                  reminderMap: reminder,
                  isEnglish: isEnglish,
                  bigButtonMode: bigButtonMode,
                  onMarkDone: () =>
                      onStatusChanged(reminder['id'] as String, 'done'),
                  onSnooze: () =>
                      onStatusChanged(reminder['id'] as String, 'snoozed'),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _AnimatedReminderItem extends StatefulWidget {
  final int index;
  final Widget child;
  const _AnimatedReminderItem({required this.index, required this.child});

  @override
  State<_AnimatedReminderItem> createState() => _AnimatedReminderItemState();
}

class _AnimatedReminderItemState extends State<_AnimatedReminderItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300 + (widget.index * 60).clamp(0, 400)),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(opacity: _fade, child: widget.child),
    );
  }
}
