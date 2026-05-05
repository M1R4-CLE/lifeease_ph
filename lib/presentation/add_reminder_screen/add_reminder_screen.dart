import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../core/app_export.dart';
import './widgets/cta_button_widget.dart';
import './widgets/recurrence_selector_widget.dart';
import './widgets/reminder_form_header_widget.dart';
import './widgets/time_slot_grid_widget.dart';

// TODO: Replace with Riverpod/Bloc for production

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final bool _isEnglish = true;
  final bool _bigButtonMode = true;
  bool _isListening = false;

  // SpeechToText instance
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _speechAvailable = false;

  String _selectedRecurrence = 'once';
  int _selectedHour = -1; // -1 = none selected
  bool _isPM = false;
  bool _isLoading = false;

  // Pre-fill from suggestion if passed via route arguments
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      if (args.containsKey('suggestedHour')) {
        final suggestedHour = args['suggestedHour'] as int;
        if (_selectedHour == -1) {
          setState(() {
            _selectedHour = suggestedHour > 12
                ? suggestedHour - 12
                : suggestedHour;
            _isPM = suggestedHour >= 12;
          });
        }
      }
      // Pre-fill title from voice command on home screen
      if (args.containsKey('voiceTitle')) {
        final voiceTitle = args['voiceTitle'] as String;
        if (_titleController.text.isEmpty && voiceTitle.isNotEmpty) {
          _titleController.text = voiceTitle;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onError: (error) => debugPrint('STT error: $error'),
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted) setState(() => _isListening = false);
        }
      },
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    if (_isListening) _speech.stop();
    _titleController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _emergencyContacts =
      [
            EmergencyContact(
              id: 'ec1',
              name: 'Maria Santos',
              phone: '+63 917 123 4567',
              relationship: 'Daughter',
            ),
            EmergencyContact(
              id: 'ec2',
              name: 'Dr. Jose Reyes',
              phone: '+63 918 987 6543',
              relationship: 'Family Doctor',
            ),
          ]
          .map(
            (e) => {
              'id': e.id,
              'name': e.name,
              'phone': e.phone,
              'relationship': e.relationship,
            },
          )
          .toList();

  List<EmergencyContact> get _contacts => _emergencyContacts
      .map(
        (m) => EmergencyContact(
          id: m['id'] as String,
          name: m['name'] as String,
          phone: m['phone'] as String,
          relationship: m['relationship'] as String,
        ),
      )
      .toList();

  Future<void> _onVoiceInput() async {
    HapticFeedback.mediumImpact();

    if (!_speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEnglish
                ? 'Speech recognition not available on this device.'
                : 'Hindi available ang speech recognition sa device na ito.',
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    } else {
      setState(() {
        _isListening = true;
        _titleController.clear();
      });
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _titleController.text = result.recognizedWords;
          });
          if (result.finalResult) {
            setState(() => _isListening = false);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 4),
        localeId: _isEnglish ? 'en_US' : 'fil_PH',
        cancelOnError: true,
        partialResults: true,
      );
    }
  }

  Future<void> _onSave() async {
    HapticFeedback.mediumImpact();
    if (!_formKey.currentState!.validate()) return;
    if (_selectedHour == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEnglish
                ? 'Please select a time for your reminder.'
                : 'Pumili ng oras para sa iyong paalala.',
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO: ReminderRepository.save(Reminder(...)) — SQLite/Hive
    // TODO: AlarmManager.setExactAndAllowWhileIdle(reminderId, triggerTime)
    // TODO: SuggestionPatternRepository.recordHour(_selectedHour + (_isPM ? 12 : 0))
    // TODO: SyncQueue.enqueue(SyncEvent.reminderCreated)

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() => _isLoading = false);
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
                    ? 'Reminder saved! You will be notified.'
                    : 'Nai-save ang paalala! Aabisuhan ka.',
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    }
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
          _isEnglish ? 'Add Reminder' : 'Magdagdag ng Paalala',
          style: GoogleFonts.nunitoSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isTablet ? _buildTabletLayout() : _buildPhoneLayout(),
      ),
      bottomNavigationBar: AppNavigation(
        currentIndex: 1,
        bigButtonMode: _bigButtonMode,
      ),
      floatingActionButton: EmergencyFabWidget(contacts: _contacts),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildPhoneLayout() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReminderFormHeaderWidget(
              titleController: _titleController,
              isEnglish: _isEnglish,
              bigButtonMode: _bigButtonMode,
              isListening: _isListening,
              onVoiceInput: _onVoiceInput,
            ),
            const SizedBox(height: 24),
            _buildSectionLabel(
              _isEnglish ? 'Repeat Schedule' : 'Ulitin ang Iskedyul',
            ),
            const SizedBox(height: 12),
            RecurrenceSelectorWidget(
              selected: _selectedRecurrence,
              isEnglish: _isEnglish,
              bigButtonMode: _bigButtonMode,
              onChanged: (val) => setState(() => _selectedRecurrence = val),
            ),
            const SizedBox(height: 24),
            _buildSectionLabel(_isEnglish ? 'Pick a Time' : 'Pumili ng Oras'),
            const SizedBox(height: 8),
            _buildAmPmToggle(),
            const SizedBox(height: 12),
            TimeSlotGridWidget(
              selectedHour: _selectedHour,
              isPM: _isPM,
              isEnglish: _isEnglish,
              bigButtonMode: _bigButtonMode,
              onHourSelected: (h) => setState(() => _selectedHour = h),
            ),
            const SizedBox(height: 32),
            CtaButtonWidget(
              isEnglish: _isEnglish,
              isLoading: _isLoading,
              bigButtonMode: _bigButtonMode,
              onTap: _onSave,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Form(
      key: _formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReminderFormHeaderWidget(
                    titleController: _titleController,
                    isEnglish: _isEnglish,
                    bigButtonMode: _bigButtonMode,
                    isListening: _isListening,
                    onVoiceInput: _onVoiceInput,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionLabel(
                    _isEnglish ? 'Repeat Schedule' : 'Ulitin ang Iskedyul',
                  ),
                  const SizedBox(height: 12),
                  RecurrenceSelectorWidget(
                    selected: _selectedRecurrence,
                    isEnglish: _isEnglish,
                    bigButtonMode: _bigButtonMode,
                    onChanged: (val) =>
                        setState(() => _selectedRecurrence = val),
                  ),
                ],
              ),
            ),
          ),
          VerticalDivider(
            width: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel(
                    _isEnglish ? 'Pick a Time' : 'Pumili ng Oras',
                  ),
                  const SizedBox(height: 8),
                  _buildAmPmToggle(),
                  const SizedBox(height: 12),
                  TimeSlotGridWidget(
                    selectedHour: _selectedHour,
                    isPM: _isPM,
                    isEnglish: _isEnglish,
                    bigButtonMode: _bigButtonMode,
                    onHourSelected: (h) => setState(() => _selectedHour = h),
                  ),
                  const SizedBox(height: 32),
                  CtaButtonWidget(
                    isEnglish: _isEnglish,
                    isLoading: _isLoading,
                    bigButtonMode: _bigButtonMode,
                    onTap: _onSave,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: GoogleFonts.nunitoSans(
        fontSize: _bigButtonMode ? 17 : 15,
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildAmPmToggle() {
    final theme = Theme.of(context);
    return Row(
      children: [
        _AmPmChip(
          label: _isEnglish ? 'AM' : 'Umaga',
          selected: !_isPM,
          bigButtonMode: _bigButtonMode,
          onTap: () => setState(() => _isPM = false),
          theme: theme,
        ),
        const SizedBox(width: 10),
        _AmPmChip(
          label: _isEnglish ? 'PM' : 'Hapon/Gabi',
          selected: _isPM,
          bigButtonMode: _bigButtonMode,
          onTap: () => setState(() => _isPM = true),
          theme: theme,
        ),
      ],
    );
  }
}

class _AmPmChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool bigButtonMode;
  final VoidCallback onTap;
  final ThemeData theme;

  const _AmPmChip({
    required this.label,
    required this.selected,
    required this.bigButtonMode,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: bigButtonMode ? 24 : 18,
          vertical: bigButtonMode ? 12 : 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.nunitoSans(
            fontSize: bigButtonMode ? 16 : 14,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}