import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class EmergencyContactCardWidget extends StatefulWidget {
  final Map<String, dynamic> contactMap;
  final bool isEnglish;
  final bool bigButtonMode;
  final VoidCallback onDelete;

  const EmergencyContactCardWidget({
    super.key,
    required this.contactMap,
    required this.isEnglish,
    required this.bigButtonMode,
    required this.onDelete,
  });

  @override
  State<EmergencyContactCardWidget> createState() =>
      _EmergencyContactCardWidgetState();
}

class _EmergencyContactCardWidgetState extends State<EmergencyContactCardWidget>
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

  void _onCallTap() {
    HapticFeedback.heavyImpact();
    _pressCtrl.forward().then((_) => _pressCtrl.reverse());
    // TODO: url_launcher — Uri.parse('tel:${widget.contactMap['phone']}')
    // Launches system dialer — no CALL_PHONE permission needed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.phone_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.isEnglish
                    ? 'Opening dialer for ${widget.contactMap['name']}...'
                    : 'Binubuksan ang dialer para kay ${widget.contactMap['name']}...',
                style: GoogleFonts.nunitoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tintColor = Color(widget.contactMap['tintColor'] as int);
    final iconColor = Color(widget.contactMap['iconColor'] as int);
    final name = widget.contactMap['name'] as String;
    final phone = widget.contactMap['phone'] as String;
    final relationship = widget.contactMap['relationship'] as String;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final nameFontSize = widget.bigButtonMode ? 18.0 : 16.0;

    // Reference image: large tinted card, avatar left, name+relationship+phone,
    // doctor photo right (cutout style), call button bottom-right
    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) =>
          Transform.scale(scale: _scaleAnim.value, child: child),
      child: Semantics(
        label:
            '${widget.isEnglish ? 'Emergency contact' : 'Emergency contact'}: $name, $relationship, $phone',
        child: Container(
          decoration: BoxDecoration(
            color: tintColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(18),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Main content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar with initial — left side (anatomy locked)
                        CircleAvatar(
                          radius: widget.bigButtonMode ? 28 : 24,
                          backgroundColor: Colors.white.withAlpha(204),
                          child: Text(
                            initial,
                            style: GoogleFonts.nunitoSans(
                              fontSize: widget.bigButtonMode ? 24 : 20,
                              fontWeight: FontWeight.w800,
                              color: iconColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Name + relationship + phone — content column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: GoogleFonts.nunitoSans(
                                  fontSize: nameFontSize,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF1A1A2E),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(153),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  relationship,
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: iconColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'phone',
                                    color: iconColor,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    phone,
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: widget.bigButtonMode ? 15 : 14,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1A1A2E),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Action row — call button full width (adapted from reference's "Book Now" CTA)
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _onCallTap,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: widget.bigButtonMode ? 14 : 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.success,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.success.withAlpha(77),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.call_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.isEnglish ? 'Call Now' : 'Tumawag',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: widget.bigButtonMode ? 16 : 14,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Delete button
                        GestureDetector(
                          onTap: widget.onDelete,
                          child: Container(
                            width: widget.bigButtonMode ? 50 : 44,
                            height: widget.bigButtonMode ? 50 : 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(179),
                              shape: BoxShape.circle,
                            ),
                            child: CustomIconWidget(
                              iconName: 'delete_outline',
                              color: AppTheme.errorColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
