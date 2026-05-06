import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Preferences state
  bool _bigButtonMode = true;
  bool _isEnglish = true;
  bool _emergencyCountdownEnabled = false;
  int _countdownSeconds = 3;
  String? _lastBackupDate;
  bool _isBackingUp = false;

  static const String _keyBigButton = 'pref_big_button_mode';
  static const String _keyLanguage = 'pref_language_en';
  static const String _keyCountdownEnabled = 'pref_countdown_enabled';
  static const String _keyCountdownSeconds = 'pref_countdown_seconds';
  static const String _keyLastBackup = 'pref_last_backup_date';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bigButtonMode = prefs.getBool(_keyBigButton) ?? true;
      _isEnglish = prefs.getBool(_keyLanguage) ?? true;
      _emergencyCountdownEnabled = prefs.getBool(_keyCountdownEnabled) ?? false;
      _countdownSeconds = prefs.getInt(_keyCountdownSeconds) ?? 3;
      _lastBackupDate = prefs.getString(_keyLastBackup);
    });
  }

  Future<void> _savePref(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) await prefs.setBool(key, value);
    if (value is int) await prefs.setInt(key, value);
    if (value is String) await prefs.setString(key, value);
  }

  void _onBigButtonToggle(bool val) {
    HapticFeedback.lightImpact();
    setState(() => _bigButtonMode = val);
    _savePref(_keyBigButton, val);
  }

  void _onLanguageChanged(bool isEnglish) {
    HapticFeedback.lightImpact();
    setState(() => _isEnglish = isEnglish);
    _savePref(_keyLanguage, isEnglish);
  }

  void _onCountdownToggle(bool val) {
    HapticFeedback.lightImpact();
    setState(() => _emergencyCountdownEnabled = val);
    _savePref(_keyCountdownEnabled, val);
  }

  void _onCountdownSecondsChanged(int seconds) {
    HapticFeedback.selectionClick();
    setState(() => _countdownSeconds = seconds);
    _savePref(_keyCountdownSeconds, seconds);
  }

  Future<void> _performBackup() async {
    HapticFeedback.mediumImpact();
    setState(() => _isBackingUp = true);
    // Simulate backup operation — replace with real export logic
    await Future.delayed(const Duration(seconds: 2));
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    await _savePref(_keyLastBackup, dateStr);
    setState(() {
      _isBackingUp = false;
      _lastBackupDate = dateStr;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEnglish
                ? 'Backup completed successfully!'
                : 'Matagumpay na na-backup!',
            style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      );
    }
  }

  Future<void> _restoreBackup() async {
    HapticFeedback.mediumImpact();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text(
          _isEnglish ? 'Restore Backup?' : 'I-restore ang Backup?',
          style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        content: Text(
          _isEnglish
              ? 'This will replace your current data with the last backup. Continue?'
              : 'Papalitan nito ang iyong kasalukuyang data ng huling backup. Ituloy?',
          style: GoogleFonts.nunitoSans(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              _isEnglish ? 'Cancel' : 'Kanselahin',
              style: GoogleFonts.nunitoSans(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(
              _isEnglish ? 'Restore' : 'I-restore',
              style: GoogleFonts.nunitoSans(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEnglish
                ? 'Data restored successfully!'
                : 'Matagumpay na na-restore!',
            style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      );
    }
  }

  double get _titleFontSize => _bigButtonMode ? 18.0 : 16.0;
  double get _bodyFontSize => _bigButtonMode ? 15.0 : 14.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.initial!),
          tooltip: _isEnglish ? 'Back' : 'Bumalik',
        ),
        title: Text(
          _isEnglish ? 'Settings' : 'Mga Setting',
          style: GoogleFonts.nunitoSans(
            fontSize: _bigButtonMode ? 22.0 : 20.0,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // ── Section 1: Accessibility ──────────────────────────────
          _SectionHeader(
            label: _isEnglish ? 'Accessibility' : 'Accessibility',
            bigButtonMode: _bigButtonMode,
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            child: _ToggleRow(
              icon: Icons.accessibility_new_rounded,
              iconColor: AppTheme.primary,
              iconBg: AppTheme.primaryContainer,
              title: _isEnglish ? 'Big Button Mode' : 'Malaking Button',
              subtitle: _isEnglish
                  ? 'Larger text and buttons for easier use'
                  : 'Mas malaking teksto at mga button',
              value: _bigButtonMode,
              onChanged: _onBigButtonToggle,
              titleFontSize: _titleFontSize,
              bodyFontSize: _bodyFontSize,
            ),
          ),
          const SizedBox(height: 20),

          // ── Section 2: Language ───────────────────────────────────
          _SectionHeader(
            label: _isEnglish ? 'Language' : 'Wika',
            bigButtonMode: _bigButtonMode,
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.lavenderTint,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Icon(
                          Icons.language_rounded,
                          color: AppTheme.secondary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _isEnglish ? 'Select Language' : 'Pumili ng Wika',
                          style: GoogleFonts.nunitoSans(
                            fontSize: _titleFontSize,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _LanguageChip(
                          label: 'English',
                          flag: '🇺🇸',
                          isSelected: _isEnglish,
                          onTap: () => _onLanguageChanged(true),
                          bigButtonMode: _bigButtonMode,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _LanguageChip(
                          label: 'Filipino',
                          flag: '🇵🇭',
                          isSelected: !_isEnglish,
                          onTap: () => _onLanguageChanged(false),
                          bigButtonMode: _bigButtonMode,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Section 3: Emergency Countdown ───────────────────────
          _SectionHeader(
            label: _isEnglish ? 'Emergency' : 'Emergency',
            bigButtonMode: _bigButtonMode,
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            child: Column(
              children: [
                _ToggleRow(
                  icon: Icons.timer_rounded,
                  iconColor: AppTheme.emergencyRed,
                  iconBg: AppTheme.errorContainer,
                  title: _isEnglish
                      ? 'Emergency Countdown'
                      : 'Emergency Countdown',
                  subtitle: _isEnglish
                      ? 'Show countdown before calling emergency contact'
                      : 'Magpakita ng countdown bago tumawag',
                  value: _emergencyCountdownEnabled,
                  onChanged: _onCountdownToggle,
                  titleFontSize: _titleFontSize,
                  bodyFontSize: _bodyFontSize,
                ),
                if (_emergencyCountdownEnabled) ...[
                  Divider(
                    height: 1,
                    color: theme.colorScheme.outlineVariant,
                    indent: 16,
                    endIndent: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEnglish
                              ? 'Countdown Duration'
                              : 'Tagal ng Countdown',
                          style: GoogleFonts.nunitoSans(
                            fontSize: _bodyFontSize,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [3, 5, 10].map((sec) {
                            final isSelected = _countdownSeconds == sec;
                            return GestureDetector(
                              onTap: () => _onCountdownSecondsChanged(sec),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: _bigButtonMode ? 72 : 64,
                                height: _bigButtonMode ? 52 : 44,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.emergencyRed
                                      : theme
                                            .colorScheme
                                            .surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(14.0),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.emergencyRed
                                        : theme.colorScheme.outlineVariant,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${sec}s',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: _bigButtonMode ? 17.0 : 15.0,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? Colors.white
                                          : theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Section 4: Data Backup ────────────────────────────────
          _SectionHeader(
            label: _isEnglish ? 'Data & Backup' : 'Data at Backup',
            bigButtonMode: _bigButtonMode,
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.mintTint,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Icon(
                          Icons.backup_rounded,
                          color: AppTheme.success,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEnglish
                                  ? 'Backup & Restore'
                                  : 'Backup at Restore',
                              style: GoogleFonts.nunitoSans(
                                fontSize: _titleFontSize,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            if (_lastBackupDate != null)
                              Text(
                                '${_isEnglish ? 'Last backup' : 'Huling backup'}: $_lastBackupDate',
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              )
                            else
                              Text(
                                _isEnglish
                                    ? 'No backup yet'
                                    : 'Wala pang backup',
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: _isEnglish ? 'Back Up Now' : 'I-backup Ngayon',
                          icon: Icons.cloud_upload_rounded,
                          color: AppTheme.success,
                          bgColor: AppTheme.successContainer,
                          isLoading: _isBackingUp,
                          onTap: _isBackingUp ? null : _performBackup,
                          bigButtonMode: _bigButtonMode,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionButton(
                          label: _isEnglish ? 'Restore' : 'I-restore',
                          icon: Icons.restore_rounded,
                          color: AppTheme.warning,
                          bgColor: AppTheme.warningContainer,
                          isLoading: false,
                          onTap: _lastBackupDate == null
                              ? null
                              : _restoreBackup,
                          bigButtonMode: _bigButtonMode,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Reusable sub-widgets ──────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final bool bigButtonMode;

  const _SectionHeader({required this.label, required this.bigButtonMode});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 2),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.nunitoSans(
          fontSize: bigButtonMode ? 12.0 : 11.0,
          fontWeight: FontWeight.w800,
          color: theme.colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;

  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final double titleFontSize;
  final double bodyFontSize;

  const _ToggleRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.titleFontSize,
    required this.bodyFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.nunitoSans(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.nunitoSans(
                    fontSize: bodyFontSize - 1,
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  final String label;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;
  final bool bigButtonMode;

  const _LanguageChip({
    required this.label,
    required this.flag,
    required this.isSelected,
    required this.onTap,
    required this.bigButtonMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: bigButtonMode ? 14 : 12,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : theme.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.nunitoSans(
                fontSize: bigButtonMode ? 15.0 : 14.0,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? AppTheme.primary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color? bgColor;
  final bool isLoading;
  final VoidCallback? onTap;
  final bool bigButtonMode;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.isLoading,
    required this.onTap,
    required this.bigButtonMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: bigButtonMode ? 14 : 12,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey.shade100 : bgColor,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(
            color: isDisabled ? Colors.grey.shade300 : color.withAlpha(80),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: color),
              )
            else
              Icon(
                icon,
                color: isDisabled ? Colors.grey : color,
                size: bigButtonMode ? 20 : 18,
              ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunitoSans(
                  fontSize: bigButtonMode ? 14.0 : 13.0,
                  fontWeight: FontWeight.w700,
                  color: isDisabled ? Colors.grey : color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
