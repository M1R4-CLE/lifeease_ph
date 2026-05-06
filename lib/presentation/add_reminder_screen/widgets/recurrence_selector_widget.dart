import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/custom_icon_widget.dart';

class RecurrenceSelectorWidget extends StatelessWidget {
  final String selected;
  final bool isEnglish;
  final bool bigButtonMode;
  final ValueChanged<String> onChanged;

  const RecurrenceSelectorWidget({
    super.key,
    required this.selected,
    required this.isEnglish,
    required this.bigButtonMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final options = isEnglish
        ? [
            {'value': 'once', 'label': 'Once', 'icon': 'check_circle'},
            {'value': 'daily', 'label': 'Daily', 'icon': 'repeat'},
            {'value': 'weekly', 'label': 'Weekly', 'icon': 'calendar'},
            {'value': 'monthly', 'label': 'Monthly', 'icon': 'star'},
          ]
        : [
            {'value': 'once', 'label': 'Isang Beses', 'icon': 'check_circle'},
            {'value': 'daily', 'label': 'Araw-araw', 'icon': 'repeat'},
            {'value': 'weekly', 'label': 'Linggu-linggo', 'icon': 'calendar'},
            {'value': 'monthly', 'label': 'Buwan-buwan', 'icon': 'star'},
          ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: options.map((opt) {
          final isSelected = selected == opt['value'];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _RecurrenceChip(
              label: opt['label'] as String,
              iconName: opt['icon'] as String,
              isSelected: isSelected,
              bigButtonMode: bigButtonMode,
              onTap: () {
                HapticFeedback.selectionClick();
                onChanged(opt['value'] as String);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _RecurrenceChip extends StatelessWidget {
  final String label;
  final String iconName;
  final bool isSelected;
  final bool bigButtonMode;
  final VoidCallback onTap;

  const _RecurrenceChip({
    required this.label,
    required this.iconName,
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
          duration: const Duration(milliseconds: 200),
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
                      color: theme.colorScheme.primary.withAlpha(64),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurfaceVariant,
                size: bigButtonMode ? 18 : 16,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.nunitoSans(
                  fontSize: bigButtonMode ? 15 : 14,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
