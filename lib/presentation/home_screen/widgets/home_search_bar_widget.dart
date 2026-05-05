
import '../../../core/app_export.dart';

class HomeSearchBarWidget extends StatelessWidget {
  final bool isEnglish;
  final VoidCallback onMicTap;

  const HomeSearchBarWidget({
    super.key,
    required this.isEnglish,
    required this.onMicTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hint = isEnglish
        ? 'Ask anything about your health...'
        : 'Magtanong tungkol sa iyong kalusugan...';

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1.5),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          CustomIconWidget(
            iconName: 'search',
            color: theme.colorScheme.onSurfaceVariant,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              style: GoogleFonts.nunitoSans(
                fontSize: 15,
                color: theme.colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.nunitoSans(
                  fontSize: 15,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
                filled: false,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Mic button
          Semantics(
            label: isEnglish ? 'Voice command' : 'Boses na utos',
            button: true,
            child: GestureDetector(
              onTap: onMicTap,
              child: Container(
                width: 44,
                height: 44,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mic_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
