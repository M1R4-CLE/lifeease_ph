import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class BigButtonRowWidget extends StatelessWidget {
  final bool bigButtonMode;
  final bool isEnglish;
  final VoidCallback onAddReminder;
  final VoidCallback onSpeakCommand;

  const BigButtonRowWidget({
    super.key,
    required this.bigButtonMode,
    required this.isEnglish,
    required this.onAddReminder,
    required this.onSpeakCommand,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    if (isTablet) {
      return Column(
        children: [
          _BigButton(
            label: isEnglish ? 'Add Reminder' : 'Magdagdag ng Paalala',
            labelFontSize: bigButtonMode ? 22 : 18,
            iconName: 'add_circle',
            color: AppTheme.primary,
            onTap: onAddReminder,
            bigButtonMode: bigButtonMode,
          ),
          const SizedBox(height: 14),
          _BigButton(
            label: isEnglish ? 'Speak Command' : 'Magsalita ng Utos',
            labelFontSize: bigButtonMode ? 22 : 18,
            iconName: 'mic',
            color: AppTheme.secondary,
            onTap: onSpeakCommand,
            bigButtonMode: bigButtonMode,
          ),
        ],
      );
    }
    return Row(
      children: [
        Expanded(
          child: _BigButton(
            label: isEnglish ? 'Add\nReminder' : 'Magdagdag\nng Paalala',
            labelFontSize: bigButtonMode ? 18 : 15,
            iconName: 'add_circle',
            color: AppTheme.primary,
            onTap: onAddReminder,
            bigButtonMode: bigButtonMode,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _BigButton(
            label: isEnglish ? 'Speak\nCommand' : 'Magsalita\nng Utos',
            labelFontSize: bigButtonMode ? 18 : 15,
            iconName: 'mic',
            color: AppTheme.secondary,
            onTap: onSpeakCommand,
            bigButtonMode: bigButtonMode,
          ),
        ),
      ],
    );
  }
}

class _BigButton extends StatefulWidget {
  final String label;
  final double labelFontSize;
  final String iconName;
  final Color color;
  final VoidCallback onTap;
  final bool bigButtonMode;

  const _BigButton({
    required this.label,
    required this.labelFontSize,
    required this.iconName,
    required this.color,
    required this.onTap,
    required this.bigButtonMode,
  });

  @override
  State<_BigButton> createState() => _BigButtonState();
}

class _BigButtonState extends State<_BigButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    _pressCtrl.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(_) {
    _pressCtrl.reverse();
    widget.onTap();
  }

  void _onTapCancel() => _pressCtrl.reverse();

  @override
  Widget build(BuildContext context) {
    final minHeight = widget.bigButtonMode ? 90.0 : 72.0;

    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) =>
          Transform.scale(scale: _scaleAnim.value, child: child),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Semantics(
          button: true,
          label: widget.label.replaceAll('\n', ' '),
          child: Container(
            constraints: BoxConstraints(minHeight: minHeight),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [widget.color, widget.color.withAlpha(217)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withAlpha(77),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: widget.iconName,
                  color: Colors.white,
                  size: widget.bigButtonMode ? 32 : 26,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    widget.label,
                    style: GoogleFonts.nunitoSans(
                      fontSize: widget.labelFontSize,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
