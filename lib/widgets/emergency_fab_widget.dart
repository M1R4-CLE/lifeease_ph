import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class EmergencyContact {
  final String id;
  final String name;
  final String phone;
  final String relationship;

  const EmergencyContact({
    required this.id,
    required this.name,
    required this.phone,
    required this.relationship,
  });
}

class EmergencyFabWidget extends StatefulWidget {
  final List<EmergencyContact> contacts;
  final bool showCountdown;

  const EmergencyFabWidget({
    super.key,
    required this.contacts,
    this.showCountdown = true,
  });

  @override
  State<EmergencyFabWidget> createState() => _EmergencyFabWidgetState();
}

class _EmergencyFabWidgetState extends State<EmergencyFabWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onEmergencyTap(BuildContext context) {
    HapticFeedback.heavyImpact();
    if (widget.contacts.isEmpty) {
      _showNoContactsDialog(context);
    } else {
      _showContactsBottomSheet(context);
    }
  }

  void _showNoContactsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: AppTheme.emergencyRed, size: 28),
            const SizedBox(width: 12),
            Text(
              'No Emergency Contacts',
              style: GoogleFonts.nunitoSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          'Please add emergency contacts first so we can help you quickly.',
          style: GoogleFonts.nunitoSans(fontSize: 15, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'OK',
              style: GoogleFonts.nunitoSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, '/emergency-contacts-screen');
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.emergencyRed,
              minimumSize: const Size(100, 44),
            ),
            child: Text(
              'Add Contact',
              style: GoogleFonts.nunitoSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EmergencyContactsSheet(
        contacts: widget.contacts,
        showCountdown: widget.showCountdown,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _pulseAnimation.value, child: child);
      },
      child: Semantics(
        label: 'Emergency call button',
        button: true,
        child: GestureDetector(
          onTap: () => _onEmergencyTap(context),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.emergencyRed,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.emergencyRed.withAlpha(102),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.emergency_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmergencyContactsSheet extends StatefulWidget {
  final List<EmergencyContact> contacts;
  final bool showCountdown;

  const _EmergencyContactsSheet({
    required this.contacts,
    required this.showCountdown,
  });

  @override
  State<_EmergencyContactsSheet> createState() =>
      _EmergencyContactsSheetState();
}

class _EmergencyContactsSheetState extends State<_EmergencyContactsSheet> {
  String? _callingContactId;
  int _countdown = 3;
  bool _isCounting = false;

  void _initiateCall(BuildContext context, EmergencyContact contact) async {
    HapticFeedback.mediumImpact();
    if (!widget.showCountdown) {
      _launchDialer(contact.phone);
      return;
    }

    setState(() {
      _callingContactId = contact.id;
      _isCounting = true;
      _countdown = 3;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.phone_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Calling ${contact.name} in $_countdown seconds...',
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _callingContactId = null;
                  _isCounting = false;
                });
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: Text(
                'CANCEL',
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.amber,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
        backgroundColor: const Color(0xFF2A2C3E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    for (int i = 3; i >= 1; i--) {
      if (!mounted || !_isCounting) return;
      setState(() => _countdown = i);
      await Future.delayed(const Duration(seconds: 1));
    }

    if (!mounted || !_isCounting) return;
    _launchDialer(contact.phone);
    if (mounted) Navigator.pop(context);
  }

  void _launchDialer(String phone) {
    // TODO: Replace with url_launcher package — Uri.parse('tel:$phone')
    // url_launcher.launchUrl(Uri.parse('tel:$phone'))
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(31),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.errorContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.emergency_rounded,
                      color: AppTheme.emergencyRed,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Call',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Choose a contact to call',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...widget.contacts.map(
              (contact) => _ContactCallTile(
                contact: contact,
                isCalling: _callingContactId == contact.id,
                onCall: () => _initiateCall(context, contact),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _ContactCallTile extends StatelessWidget {
  final EmergencyContact contact;
  final bool isCalling;
  final VoidCallback onCall;

  const _ContactCallTile({
    required this.contact,
    required this.isCalling,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCalling
              ? AppTheme.errorContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: isCalling
              ? Border.all(color: AppTheme.emergencyRed, width: 2)
              : null,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: isCalling
                  ? AppTheme.emergencyRed
                  : theme.colorScheme.primaryContainer,
              child: Text(
                contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                style: GoogleFonts.nunitoSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isCalling ? Colors.white : theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    contact.relationship,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 13,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    contact.phone,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onCall,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: isCalling ? AppTheme.emergencyRed : AppTheme.success,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.call_rounded, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
