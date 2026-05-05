
import '../../../core/app_export.dart';

class ContactSectionHeaderWidget extends StatelessWidget {
  final int contactCount;
  final int maxContacts;
  final bool isEnglish;
  final bool bigButtonMode;

  const ContactSectionHeaderWidget({
    super.key,
    required this.contactCount,
    required this.maxContacts,
    required this.isEnglish,
    required this.bigButtonMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = maxContacts - contactCount;
    final isFull = remaining == 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isFull
            ? AppTheme.successContainer
            : theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Slot indicators
          Row(
            children: List.generate(maxContacts, (i) {
              final isFilled = i < contactCount;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isFilled
                        ? (isFull
                              ? AppTheme.success
                              : theme.colorScheme.primary)
                        : theme.colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isFilled
                          ? Colors.transparent
                          : theme.colorScheme.outlineVariant,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: isFilled
                        ? Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 18,
                          )
                        : Icon(
                            Icons.add_rounded,
                            color: theme.colorScheme.outline,
                            size: 18,
                          ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isFull
                      ? (isEnglish
                            ? 'All 3 slots filled'
                            : 'Puno na ang 3 slot')
                      : (isEnglish
                            ? '$contactCount of $maxContacts contacts added'
                            : '$contactCount sa $maxContacts contacts na naidagdag'),
                  style: GoogleFonts.nunitoSans(
                    fontSize: bigButtonMode ? 15 : 14,
                    fontWeight: FontWeight.w700,
                    color: isFull
                        ? AppTheme.success
                        : theme.colorScheme.primary,
                  ),
                ),
                Text(
                  isFull
                      ? (isEnglish
                            ? 'Remove a contact to add another'
                            : 'Mag-alis ng contact para magdagdag ng bago')
                      : (isEnglish
                            ? '$remaining slot${remaining > 1 ? 's' : ''} remaining'
                            : '$remaining slot pa ang natitira'),
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: isFull
                        ? AppTheme.success
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
