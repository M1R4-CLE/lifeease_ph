import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_navigation.dart';
import '../../widgets/emergency_fab_widget.dart';
import './widgets/big_button_row_widget.dart';
import './widgets/home_app_bar_widget.dart';
import './widgets/home_search_bar_widget.dart';
import './widgets/next_appointment_widget.dart';
import './widgets/reminder_list_widget.dart';
import './widgets/suggestion_card_widget.dart';

// TODO: Replace with Riverpod/Bloc for production

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final bool _bigButtonMode = true;
  bool _showSuggestion = true;
  final int _suggestedHour = 8;
  final bool _isEnglish = true;

  // SpeechToText instance
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _speechAvailable = false;

  // TODO: Replace with local DB query (SQLite/Hive)
  final List<Map<String, dynamic>> _reminderMaps = [
    {
      'id': 'r1',
      'title': 'Take Blood Pressure Medicine',
      'titleFil': 'Uminom ng gamot para sa presyon',
      'time': '08:00 AM',
      'status': 'pending',
      'iconName': 'pill',
      'tintColor': 0xFFD4EDE8,
      'iconColor': 0xFF2D7A4F,
      'date': 'Today',
    },
    {
      'id': 'r2',
      'title': 'Morning Walk — 30 Minutes',
      'titleFil': 'Umaga na lakad — 30 minuto',
      'time': '07:00 AM',
      'status': 'done',
      'iconName': 'heart',
      'tintColor': 0xFFE8E8FF,
      'iconColor': 0xFF5B6BF8,
      'date': 'Today',
    },
    {
      'id': 'r3',
      'title': 'Doctor Appointment — Dr. Cruz',
      'titleFil': 'Appointment sa doktor — Dr. Cruz',
      'time': '10:30 AM',
      'status': 'upcoming',
      'iconName': 'medical',
      'tintColor': 0xFFFFECE8,
      'iconColor': 0xFFB45309,
      'date': 'Today',
    },
    {
      'id': 'r4',
      'title': 'Take Vitamin D Supplement',
      'titleFil': 'Uminom ng Vitamin D',
      'time': '12:00 PM',
      'status': 'pending',
      'iconName': 'pill',
      'tintColor': 0xFFFEF3C7,
      'iconColor': 0xFFB45309,
      'date': 'Today',
    },
    {
      'id': 'r5',
      'title': 'Afternoon Rest',
      'titleFil': 'Hapon na pahinga',
      'time': '02:00 PM',
      'status': 'missed',
      'iconName': 'snooze',
      'tintColor': 0xFFFFE4E4,
      'iconColor': 0xFFB91C1C,
      'date': 'Yesterday',
    },
  ];

  // TODO: Replace with EmergencyContactRepository.getAll()
  final List<EmergencyContact> _emergencyContacts = [
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
  ];

  late AnimationController _greetingController;
  late Animation<double> _greetingFade;

  @override
  void initState() {
    super.initState();
    _greetingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _greetingFade = CurvedAnimation(
      parent: _greetingController,
      curve: Curves.easeOutCubic,
    );
    _greetingController.forward();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onError: (error) => debugPrint('STT error: $error'),
      onStatus: (status) => debugPrint('STT status: $status'),
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _greetingController.dispose();
    super.dispose();
  }

  String get _greeting {
    final hour = TimeOfDay.now().hour;
    if (_isEnglish) {
      if (hour < 12) return 'Good Morning! ☀️';
      if (hour < 17) return 'Good Afternoon! 🌤️';
      return 'Good Evening! 🌙';
    } else {
      if (hour < 12) return 'Magandang Umaga! ☀️';
      if (hour < 17) return 'Magandang Hapon! 🌤️';
      return 'Magandang Gabi! 🌙';
    }
  }

  String get _headlineText {
    final pendingCount = _reminderMaps
        .where((r) => r['status'] == 'pending')
        .length;
    final missedCount = _reminderMaps
        .where((r) => r['status'] == 'missed')
        .length;
    if (_isEnglish) {
      if (missedCount > 0) {
        return '$missedCount missed reminder${missedCount > 1 ? 's' : ''}. Check now!';
      }
      if (pendingCount > 0) {
        return '$pendingCount reminder${pendingCount > 1 ? 's' : ''} for today.';
      }
      return 'All done for today! 🎉';
    } else {
      if (missedCount > 0) {
        return '$missedCount napalampas na paalala. Tingnan na!';
      }
      if (pendingCount > 0) return '$pendingCount paalala para ngayon.';
      return 'Tapos na lahat ngayon! 🎉';
    }
  }

  void _onSuggestionAccepted() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(
      context,
      AppRoutes.addReminderScreen,
      arguments: {'suggestedHour': _suggestedHour},
    );
  }

  void _onSuggestionDismissed() {
    HapticFeedback.lightImpact();
    setState(() => _showSuggestion = false);
  }

  void _onAddReminder() {
    HapticFeedback.mediumImpact();
    Navigator.pushNamed(context, AppRoutes.addReminderScreen);
  }

  void _onSpeakCommand() {
    HapticFeedback.mediumImpact();
    _showVoiceInputSheet();
  }

  void _showVoiceInputSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _VoiceInputSheet(
        isEnglish: _isEnglish,
        speech: _speech,
        speechAvailable: _speechAvailable,
        onCommandRecognized: (transcript) {
          Navigator.pop(ctx);
          Navigator.pushNamed(
            context,
            AppRoutes.addReminderScreen,
            arguments: {'voiceTitle': transcript},
          );
        },
      ),
    );
  }

  void _onReminderStatusChanged(String id, String newStatus) {
    HapticFeedback.lightImpact();
    // TODO: Update via ReminderRepository.updateStatus(id, newStatus)
    setState(() {
      final idx = _reminderMaps.indexWhere((r) => r['id'] == id);
      if (idx != -1) {
        _reminderMaps[idx] = Map.from(_reminderMaps[idx])
          ..['status'] = newStatus;
      }
    });
  }

  bool get _isTablet => MediaQuery.of(context).size.width >= 600;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _isTablet ? _buildTabletLayout() : _buildPhoneLayout(),
      ),
      bottomNavigationBar: AppNavigation(
        currentIndex: 0,
        bigButtonMode: _bigButtonMode,
      ),
      floatingActionButton: EmergencyFabWidget(
        contacts: _emergencyContacts,
        showCountdown: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildPhoneLayout() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _greetingFade,
            child: HomeAppBarWidget(
              greeting: _greeting,
              userName: 'Lola Nena',
              avatarUrl:
                  'https://images.pexels.com/photos/3768131/pexels-photo-3768131.jpeg',
              avatarSemanticLabel:
                  'Elderly Filipino woman smiling, short white hair, wearing blue blouse',
              onNotificationTap: () {},
              bigButtonMode: _bigButtonMode,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildHeadline(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: HomeSearchBarWidget(
              isEnglish: _isEnglish,
              onMicTap: _onSpeakCommand,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: NextAppointmentWidget(
              isEnglish: _isEnglish,
              reminderMaps: _reminderMaps
                  .where(
                    (r) =>
                        r['status'] == 'upcoming' || r['status'] == 'pending',
                  )
                  .take(1)
                  .toList(),
            ),
          ),
        ),
        if (_showSuggestion)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: SuggestionCardWidget(
                suggestedHour: _suggestedHour,
                isEnglish: _isEnglish,
                onAccept: _onSuggestionAccepted,
                onDismiss: _onSuggestionDismissed,
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: BigButtonRowWidget(
              bigButtonMode: _bigButtonMode,
              isEnglish: _isEnglish,
              onAddReminder: _onAddReminder,
              onSpeakCommand: _onSpeakCommand,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: ReminderListWidget(
              reminderMaps: _reminderMaps,
              isEnglish: _isEnglish,
              bigButtonMode: _bigButtonMode,
              onStatusChanged: _onReminderStatusChanged,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeAppBarWidget(
                  greeting: _greeting,
                  userName: 'Lola Nena',
                  avatarUrl:
                      'https://images.pexels.com/photos/3768131/pexels-photo-3768131.jpeg',
                  avatarSemanticLabel:
                      'Elderly Filipino woman smiling, short white hair, wearing blue blouse',
                  onNotificationTap: () {},
                  bigButtonMode: _bigButtonMode,
                ),
                const SizedBox(height: 16),
                _buildHeadline(),
                const SizedBox(height: 16),
                HomeSearchBarWidget(
                  isEnglish: _isEnglish,
                  onMicTap: _onSpeakCommand,
                ),
                const SizedBox(height: 20),
                BigButtonRowWidget(
                  bigButtonMode: _bigButtonMode,
                  isEnglish: _isEnglish,
                  onAddReminder: _onAddReminder,
                  onSpeakCommand: _onSpeakCommand,
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
          flex: 6,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                NextAppointmentWidget(
                  isEnglish: _isEnglish,
                  reminderMaps: _reminderMaps
                      .where(
                        (r) =>
                            r['status'] == 'upcoming' ||
                            r['status'] == 'pending',
                      )
                      .take(1)
                      .toList(),
                ),
                if (_showSuggestion) ...[
                  const SizedBox(height: 16),
                  SuggestionCardWidget(
                    suggestedHour: _suggestedHour,
                    isEnglish: _isEnglish,
                    onAccept: _onSuggestionAccepted,
                    onDismiss: _onSuggestionDismissed,
                  ),
                ],
                const SizedBox(height: 20),
                ReminderListWidget(
                  reminderMaps: _reminderMaps,
                  isEnglish: _isEnglish,
                  bigButtonMode: _bigButtonMode,
                  onStatusChanged: _onReminderStatusChanged,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeadline() {
    final theme = Theme.of(context);
    final hasMissed = _reminderMaps.any((r) => r['status'] == 'missed');
    return Text(
      _headlineText,
      style: GoogleFonts.nunitoSans(
        fontSize: _bigButtonMode ? 26 : 24,
        fontWeight: FontWeight.w800,
        color: hasMissed ? AppTheme.errorColor : theme.colorScheme.onSurface,
        height: 1.3,
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Voice Input Sheet (inline — home-screen specific)
// ──────────────────────────────────────────────
class _VoiceInputSheet extends StatefulWidget {
  final bool isEnglish;
  final stt.SpeechToText speech;
  final bool speechAvailable;
  final ValueChanged<String> onCommandRecognized;

  const _VoiceInputSheet({
    required this.isEnglish,
    required this.speech,
    required this.speechAvailable,
    required this.onCommandRecognized,
  });

  @override
  State<_VoiceInputSheet> createState() => _VoiceInputSheetState();
}

class _VoiceInputSheetState extends State<_VoiceInputSheet>
    with SingleTickerProviderStateMixin {
  bool _isListening = false;
  String _transcribedText = '';
  late AnimationController _micPulse;
  late Animation<double> _micScale;

  @override
  void initState() {
    super.initState();
    _micPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _micScale = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _micPulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    if (_isListening) widget.speech.stop();
    _micPulse.dispose();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    HapticFeedback.mediumImpact();
    if (!widget.speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEnglish
                ? 'Speech recognition not available on this device.'
                : 'Hindi available ang speech recognition sa device na ito.',
          ),
        ),
      );
      return;
    }

    if (_isListening) {
      await widget.speech.stop();
      _micPulse.stop();
      _micPulse.reset();
      setState(() => _isListening = false);
    } else {
      setState(() {
        _isListening = true;
        _transcribedText = '';
      });
      _micPulse.repeat(reverse: true);
      await widget.speech.listen(
        onResult: (result) {
          setState(() {
            _transcribedText = result.recognizedWords;
          });
          if (result.finalResult && _transcribedText.isNotEmpty) {
            _micPulse.stop();
            _micPulse.reset();
            setState(() => _isListening = false);
            widget.onCommandRecognized(_transcribedText);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 4),
        localeId: widget.isEnglish ? 'en_US' : 'fil_PH',
        cancelOnError: true,
        partialResults: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                widget.isEnglish ? 'Speak a Command' : 'Magsalita ng Utos',
                style: GoogleFonts.nunitoSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.isEnglish
                    ? 'Say: "Remind me to take medicine at 8 AM"'
                    : 'Sabihin: "Paalalahanin ako uminom ng gamot ng ika-8 ng umaga"',
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AnimatedBuilder(
                animation: _micScale,
                builder: (context, child) =>
                    Transform.scale(scale: _micScale.value, child: child),
                child: GestureDetector(
                  onTap: _toggleListening,
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: _isListening
                          ? AppTheme.emergencyRed
                          : theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              (_isListening
                                      ? AppTheme.emergencyRed
                                      : theme.colorScheme.primary)
                                  .withAlpha(89),
                          blurRadius: 24,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _isListening
                    ? (widget.isEnglish ? 'Listening...' : 'Nakikinig...')
                    : (widget.isEnglish
                          ? 'Tap to speak'
                          : 'I-tap para magsalita'),
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _isListening
                      ? AppTheme.emergencyRed
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (_transcribedText.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _transcribedText,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}