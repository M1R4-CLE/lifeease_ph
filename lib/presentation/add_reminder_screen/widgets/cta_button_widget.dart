import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


class CtaButtonWidget extends StatefulWidget {
  final bool isEnglish;
  final bool isLoading;
  final bool bigButtonMode;
  final VoidCallback onTap;

  const CtaButtonWidget({
    super.key,
    required this.isEnglish,
    required this.isLoading,
    required this.bigButtonMode,
    required this.onTap,
  });

  @override
  State<CtaButtonWidget> createState() => _CtaButtonWidgetState();
}

class _CtaButtonWidgetState extends State<CtaButtonWidget>
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
      end: 0.97,
    ).animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minHeight = widget.bigButtonMode ? 64.0 : 56.0;
    final fontSize = widget.bigButtonMode ? 18.0 : 16.0;
    final label = widget.isEnglish ? 'Save Reminder' : 'I-save ang Paalala';

    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) =>
          Transform.scale(scale: _scaleAnim.value, child: child),
      child: GestureDetector(
        onTapDown: (_) {
          if (!widget.isLoading) {
            _pressCtrl.forward();
            HapticFeedback.mediumImpact();
          }
        },
        onTapUp: (_) {
          _pressCtrl.reverse();
          if (!widget.isLoading) widget.onTap();
        },
        onTapCancel: () => _pressCtrl.reverse(),
        child: Semantics(
          button: true,
          label: label,
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: minHeight),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withAlpha(217),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withAlpha(89),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.isLoading) ...[
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    widget.isEnglish ? 'Saving...' : 'Sino-save...',
                    style: GoogleFonts.nunitoSans(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ] else ...[
                  Text(
                    label,
                    style: GoogleFonts.nunitoSans(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
