import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeSlotGridWidget extends StatelessWidget {
  final int selectedHour;
  final bool isPM;
  final bool isEnglish;
  final bool bigButtonMode;
  final ValueChanged<int> onHourSelected;

  const TimeSlotGridWidget({
    super.key,
    required this.selectedHour,
    required this.isPM,
    required this.isEnglish,
    required this.bigButtonMode,
    required this.onHourSelected,
  });

  // Hours in 12h format (1–12)
  static const List<int> _hours = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  String _formatSlot(int hour) {
    return '${hour.toString().padLeft(2, '0')}:00';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _hours.map((hour) {
        final isSelected = selectedHour == hour;
        return _TimeSlotChip(
          label: _formatSlot(hour),
          isSelected: isSelected,
          bigButtonMode: bigButtonMode,
          onTap: () {
            HapticFeedback.selectionClick();
            onHourSelected(hour);
          },
        );
      }).toList(),
    );
  }
}

class _TimeSlotChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool bigButtonMode;
  final VoidCallback onTap;

  const _TimeSlotChip({
    required this.label,
    required this.isSelected,
    required this.bigButtonMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      selected: isSelected,
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: bigButtonMode ? 20 : 16,
            vertical: bigButtonMode ? 14 : 11,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withAlpha(71),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: GoogleFonts.nunitoSans(
              fontSize: bigButtonMode ? 15 : 14,
              fontWeight: FontWeight.w700,
              color: isSelected
                  ? Colors.white
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
