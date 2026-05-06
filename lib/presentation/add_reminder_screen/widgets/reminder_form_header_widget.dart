import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/custom_icon_widget.dart';

class ReminderFormHeaderWidget extends StatelessWidget {
  final TextEditingController titleController;
  final bool isEnglish;
  final bool bigButtonMode;
  final bool isListening;
  final VoidCallback onVoiceInput;

  const ReminderFormHeaderWidget({
    super.key,
    required this.titleController,
    required this.isEnglish,
    required this.bigButtonMode,
    required this.isListening,
    required this.onVoiceInput,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputFontSize = bigButtonMode ? 18.0 : 16.0;
    final hintText = isEnglish
        ? 'e.g. Take Blood Pressure Medicine'
        : 'hal. Uminom ng gamot para sa presyon';
    final labelText = isEnglish ? 'Reminder Title' : 'Pamagat ng Paalala';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero card header — adapted from reference booking screen's DoctorHeroCard
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'alarm',
                    color: theme.colorScheme.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEnglish ? 'New Reminder' : 'Bagong Paalala',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        isEnglish
                            ? 'Set a health reminder for yourself'
                            : 'Magtakda ng paalala para sa iyong kalusugan',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Title field label
          Text(
            labelText,
            style: GoogleFonts.nunitoSans(
              fontSize: bigButtonMode ? 15 : 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          // Title field with voice button
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: titleController,
                  style: GoogleFonts.nunitoSans(
                    fontSize: inputFontSize,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: GoogleFonts.nunitoSans(
                      fontSize: inputFontSize,
                      color: theme.colorScheme.onSurfaceVariant.withAlpha(179),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outlineVariant,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppTheme.errorColor,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: bigButtonMode ? 20 : 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return isEnglish
                          ? 'Please enter a reminder title'
                          : 'Mangyaring maglagay ng pamagat';
                    }
                    if (value.trim().length < 3) {
                      return isEnglish
                          ? 'Title must be at least 3 characters'
                          : 'Dapat ay hindi bababa sa 3 karakter';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                ),
              ),
              const SizedBox(width: 10),
              // Voice input button
              Semantics(
                label: isEnglish ? 'Voice input' : 'Boses na input',
                button: true,
                child: GestureDetector(
                  onTap: onVoiceInput,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: bigButtonMode ? 60 : 52,
                    height: bigButtonMode ? 60 : 52,
                    decoration: BoxDecoration(
                      color: isListening
                          ? AppTheme.emergencyRed
                          : theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isListening
                                      ? AppTheme.emergencyRed
                                      : theme.colorScheme.primary)
                                  .withAlpha(77),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      isListening ? Icons.stop_rounded : Icons.mic_rounded,
                      color: Colors.white,
                      size: bigButtonMode ? 28 : 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (isListening) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.emergencyRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isEnglish
                        ? 'Listening — speak clearly...'
                        : 'Nakikinig — magsalita nang malinaw...',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.emergencyRed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
