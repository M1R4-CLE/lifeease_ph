import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/add_contact_bottom_sheet_widget.dart';
import './widgets/contact_section_header_widget.dart';
import './widgets/emergency_contact_card_widget.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen>
    with TickerProviderStateMixin {
  final bool _isEnglish = true;
  final bool _bigButtonMode = true;

  final List<Map<String, dynamic>> _contactMaps = [
    {
      'id': 'ec1',
      'name': 'Maria Santos',
      'phone': '+63 917 123 4567',
      'relationship': 'Daughter',
      'tintColor': 0xFFD4EDE8,
      'iconColor': 0xFF2D7A4F,
    },
    {
      'id': 'ec2',
      'name': 'Dr. Jose Reyes',
      'phone': '+63 918 987 6543',
      'relationship': 'Family Doctor',
      'tintColor': 0xFFE8E8FF,
      'iconColor': 0xFF5B6BF8,
    },
  ];

  late AnimationController _listEntryCtrl;

  @override
  void initState() {
    super.initState();
    _listEntryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _listEntryCtrl.dispose();
    super.dispose();
  }

  List<EmergencyContact> get _contacts => _contactMaps
      .map(
        (m) => EmergencyContact(
          id: m['id'] as String,
          name: m['name'] as String,
          phone: m['phone'] as String,
          relationship: m['relationship'] as String,
        ),
      )
      .toList();

  bool get _canAddMore => _contactMaps.length < 3;

  void _onAddContact() {
    if (!_canAddMore) {
      HapticFeedback.mediumImpact();
      _showMaxContactsDialog();
      return;
    }
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddContactBottomSheetWidget(
        isEnglish: _isEnglish,
        bigButtonMode: _bigButtonMode,
        onSave: _onContactSaved,
      ),
    );
  }

  void _onContactSaved(Map<String, dynamic> contactMap) {
    final tints = [
      {'tintColor': 0xFFFFECE8, 'iconColor': 0xFFB45309},
      {'tintColor': 0xFFFEF3C7, 'iconColor': 0xFFB45309},
      {'tintColor': 0xFFE0F2FE, 'iconColor': 0xFF0369A1},
    ];
    final tintIndex = _contactMaps.length % tints.length;
    setState(() {
      _contactMaps.add({...contactMap, ...tints[tintIndex]});
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              _isEnglish
                  ? 'Contact saved successfully!'
                  : 'Nai-save ang contact!',
              style: GoogleFonts.nunitoSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _onDeleteContact(String id) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          _isEnglish ? 'Remove Contact?' : 'Alisin ang Contact?',
          style: GoogleFonts.nunitoSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          _isEnglish
              ? 'This contact will be removed from your emergency list.'
              : 'Aalisin ang contact na ito sa iyong listahan ng emergency.',
          style: GoogleFonts.nunitoSans(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              _isEnglish ? 'Cancel' : 'Kanselahin',
              style: GoogleFonts.nunitoSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _contactMaps.removeWhere((m) => m['id'] == id));
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.emergencyRed,
              minimumSize: const Size(80, 44),
            ),
            child: Text(
              _isEnglish ? 'Remove' : 'Alisin',
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

  void _showMaxContactsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(
              Icons.info_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 26,
            ),
            const SizedBox(width: 12),
            Text(
              _isEnglish ? 'Maximum Reached' : 'Naabot na ang Pinakamataas',
              style: GoogleFonts.nunitoSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          _isEnglish
              ? 'You can store up to 3 emergency contacts. Remove one to add another.'
              : 'Maaari kang mag-imbak ng hanggang 3 emergency contacts. Mag-alis ng isa para magdagdag ng bago.',
          style: GoogleFonts.nunitoSans(fontSize: 14, height: 1.5),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            style: FilledButton.styleFrom(minimumSize: const Size(80, 44)),
            child: Text(
              'OK',
              style: GoogleFonts.nunitoSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get _isTablet => MediaQuery.of(context).size.width >= 600;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: theme.colorScheme.primary,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.colorScheme.onSurface,
            size: 22,
          ),
        ),
        title: Text(
          _isEnglish ? 'Emergency Contacts' : 'Mga Emergency Contact',
          style: GoogleFonts.nunitoSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_canAddMore)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: _onAddContact,
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'add',
                    color: theme.colorScheme.primary,
                    size: 22,
                  ),
                ),
                tooltip: _isEnglish ? 'Add Contact' : 'Magdagdag ng Contact',
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: _contactMaps.isEmpty
            ? EmptyStateWidget(
                icon: Icons.contact_phone_rounded,
                title: _isEnglish
                    ? 'No Emergency Contacts'
                    : 'Walang Emergency Contacts',
                subtitle: _isEnglish
                    ? 'Add up to 3 people who should be contacted in an emergency. They will be reachable with one tap.'
                    : 'Magdagdag ng hanggang 3 tao na dapat makipag-ugnayan sa emergency. Maaabot sila sa isang tap.',
                ctaLabel: _isEnglish ? 'Add Contact' : 'Magdagdag ng Contact',
                onCtaTap: _onAddContact,
              )
            : _isTablet
            ? _buildTabletLayout()
            : _buildPhoneLayout(),
      ),
      bottomNavigationBar: AppNavigation(
        currentIndex: 2,
        bigButtonMode: _bigButtonMode,
      ),
      floatingActionButton: EmergencyFabWidget(contacts: _contacts),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildPhoneLayout() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContactSectionHeaderWidget(
            contactCount: _contactMaps.length,
            maxContacts: 3,
            isEnglish: _isEnglish,
            bigButtonMode: _bigButtonMode,
          ),
          const SizedBox(height: 16),
          ...List.generate(_contactMaps.length, (index) {
            final contact = _contactMaps[index];
            return _AnimatedContactItem(
              index: index,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: EmergencyContactCardWidget(
                  contactMap: contact,
                  isEnglish: _isEnglish,
                  bigButtonMode: _bigButtonMode,
                  onDelete: () => _onDeleteContact(contact['id'] as String),
                ),
              ),
            );
          }),
          if (_canAddMore) ...[
            const SizedBox(height: 8),
            _AddContactPromptCard(
              isEnglish: _isEnglish,
              bigButtonMode: _bigButtonMode,
              onTap: _onAddContact,
            ),
          ],
          const SizedBox(height: 24),
          _EmergencyInfoCard(
            isEnglish: _isEnglish,
            bigButtonMode: _bigButtonMode,
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContactSectionHeaderWidget(
            contactCount: _contactMaps.length,
            maxContacts: 3,
            isEnglish: _isEnglish,
            bigButtonMode: _bigButtonMode,
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
            ),
            itemCount: _contactMaps.length + (_canAddMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _contactMaps.length) {
                return _AddContactPromptCard(
                  isEnglish: _isEnglish,
                  bigButtonMode: _bigButtonMode,
                  onTap: _onAddContact,
                );
              }
              final contact = _contactMaps[index];
              return EmergencyContactCardWidget(
                contactMap: contact,
                isEnglish: _isEnglish,
                bigButtonMode: _bigButtonMode,
                onDelete: () => _onDeleteContact(contact['id'] as String),
              );
            },
          ),
          const SizedBox(height: 20),
          _EmergencyInfoCard(
            isEnglish: _isEnglish,
            bigButtonMode: _bigButtonMode,
          ),
        ],
      ),
    );
  }
}

class _AnimatedContactItem extends StatefulWidget {
  final int index;
  final Widget child;
  const _AnimatedContactItem({required this.index, required this.child});

  @override
  State<_AnimatedContactItem> createState() => _AnimatedContactItemState();
}

class _AnimatedContactItemState extends State<_AnimatedContactItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350 + widget.index * 80),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    Future.delayed(Duration(milliseconds: widget.index * 60), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(opacity: _fade, child: widget.child),
    );
  }
}

// ──────────────────────────────────────────────
// Add Contact Prompt Card
// ──────────────────────────────────────────────
class _AddContactPromptCard extends StatelessWidget {
  final bool isEnglish;
  final bool bigButtonMode;
  final VoidCallback onTap;

  const _AddContactPromptCard({
    required this.isEnglish,
    required this.bigButtonMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: theme.colorScheme.primary.withAlpha(77),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'add',
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              isEnglish
                  ? 'Add Emergency Contact'
                  : 'Magdagdag ng Emergency Contact',
              style: GoogleFonts.nunitoSans(
                fontSize: bigButtonMode ? 16 : 15,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Emergency Info Card
// ──────────────────────────────────────────────
class _EmergencyInfoCard extends StatelessWidget {
  final bool isEnglish;
  final bool bigButtonMode;

  const _EmergencyInfoCard({
    required this.isEnglish,
    required this.bigButtonMode,
  });

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.warningContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.warning.withAlpha(77), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_rounded, color: AppTheme.warning, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEnglish
                      ? 'How Emergency Calls Work'
                      : 'Paano Gumagana ang Emergency Calls',
                  style: GoogleFonts.nunitoSans(
                    fontSize: bigButtonMode ? 15 : 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.warning,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEnglish
                      ? 'Tapping the red Emergency button opens your contacts list. Tap "Call" to open your phone dialer — no auto-call.'
                      : 'Ang pag-tap sa pulang Emergency button ay nagbubukas ng iyong listahan ng contacts. I-tap ang "Tawagan" para buksan ang iyong dialer — walang awtomatikong tawag.',
                  style: GoogleFonts.nunitoSans(
                    fontSize: bigButtonMode ? 13 : 12,
                    color: AppTheme.warning,
                    height: 1.5,
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
