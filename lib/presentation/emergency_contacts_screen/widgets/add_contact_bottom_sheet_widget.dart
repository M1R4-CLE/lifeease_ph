import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class AddContactBottomSheetWidget extends StatefulWidget {
  final bool isEnglish;
  final bool bigButtonMode;
  final Function(Map<String, dynamic>) onSave;

  const AddContactBottomSheetWidget({
    super.key,
    required this.isEnglish,
    required this.bigButtonMode,
    required this.onSave,
  });

  @override
  State<AddContactBottomSheetWidget> createState() =>
      _AddContactBottomSheetWidgetState();
}

class _AddContactBottomSheetWidgetState
    extends State<AddContactBottomSheetWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _relationshipController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  void _onSave() async {
    HapticFeedback.mediumImpact();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() => _isLoading = false);
      widget.onSave({
        'id': 'ec_${DateTime.now().millisecondsSinceEpoch}',
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'relationship': _relationshipController.text.trim(),
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputFontSize = widget.bigButtonMode ? 18.0 : 16.0;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.errorContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.contact_phone_rounded,
                          color: AppTheme.emergencyRed,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isEnglish
                                ? 'Add Emergency Contact'
                                : 'Magdagdag ng Emergency Contact',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            widget.isEnglish
                                ? 'They will be called in emergencies'
                                : 'Tatawagan sila sa emergency',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Name field
                  _buildFieldLabel(
                    widget.isEnglish ? 'Full Name' : 'Buong Pangalan',
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    style: GoogleFonts.nunitoSans(
                      fontSize: inputFontSize,
                      color: theme.colorScheme.onSurface,
                    ),
                    decoration: _buildInputDecoration(
                      hintText: widget.isEnglish
                          ? 'e.g. Maria Santos'
                          : 'hal. Maria Santos',
                      prefixIcon: Icons.person_rounded,
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return widget.isEnglish
                            ? 'Please enter a name'
                            : 'Mangyaring maglagay ng pangalan';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Phone field
                  _buildFieldLabel(
                    widget.isEnglish ? 'Phone Number' : 'Numero ng Telepono',
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    style: GoogleFonts.nunitoSans(
                      fontSize: inputFontSize,
                      color: theme.colorScheme.onSurface,
                    ),
                    keyboardType: TextInputType.phone,
                    decoration: _buildInputDecoration(
                      hintText: '+63 917 XXX XXXX',
                      prefixIcon: Icons.phone_rounded,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return widget.isEnglish
                            ? 'Please enter a phone number'
                            : 'Mangyaring maglagay ng numero';
                      }
                      if (v.trim().length < 7) {
                        return widget.isEnglish
                            ? 'Please enter a valid phone number'
                            : 'Mangyaring maglagay ng tamang numero';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Relationship field
                  _buildFieldLabel(
                    widget.isEnglish ? 'Relationship' : 'Relasyon sa Inyo',
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _relationshipController,
                    style: GoogleFonts.nunitoSans(
                      fontSize: inputFontSize,
                      color: theme.colorScheme.onSurface,
                    ),
                    decoration: _buildInputDecoration(
                      hintText: widget.isEnglish
                          ? 'e.g. Daughter, Doctor, Son'
                          : 'hal. Anak, Doktor, Anak na lalaki',
                      prefixIcon: Icons.group_rounded,
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return widget.isEnglish
                            ? 'Please enter the relationship'
                            : 'Mangyaring ilagay ang relasyon';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),
                  // Save CTA
                  GestureDetector(
                    onTap: _isLoading ? null : _onSave,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: widget.bigButtonMode ? 18 : 15,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.emergencyRed,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.emergencyRed.withAlpha(77),
                            blurRadius: 16,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isLoading) ...[
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ] else ...[
                            const Icon(
                              Icons.contact_phone_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                          ],
                          Text(
                            _isLoading
                                ? (widget.isEnglish
                                      ? 'Saving...'
                                      : 'Sino-save...')
                                : (widget.isEnglish
                                      ? 'Save Contact'
                                      : 'I-save ang Contact'),
                            style: GoogleFonts.nunitoSans(
                              fontSize: widget.bigButtonMode ? 17 : 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Cancel
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        widget.isEnglish ? 'Cancel' : 'Kanselahin',
                        style: GoogleFonts.nunitoSans(
                          fontSize: widget.bigButtonMode ? 16 : 14,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: GoogleFonts.nunitoSans(
        fontSize: widget.bigButtonMode ? 15 : 14,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    final theme = Theme.of(context);
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.nunitoSans(
        fontSize: 15,
        color: theme.colorScheme.onSurfaceVariant.withAlpha(153),
      ),
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest,
      prefixIcon: Icon(
        prefixIcon,
        color: theme.colorScheme.onSurfaceVariant,
        size: 20,
      ),
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
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppTheme.errorColor, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppTheme.errorColor, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 18,
        vertical: widget.bigButtonMode ? 20 : 16,
      ),
    );
  }
}
