import 'package:flutter/material.dart';

import '../presentation/add_reminder_screen/add_reminder_screen.dart';
import '../presentation/emergency_contacts_screen/emergency_contacts_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String homeScreen = '/home-screen';
  static const String addReminderScreen = '/add-reminder-screen';
  static const String emergencyContactsScreen = '/emergency-contacts-screen';
  static const String settingsScreen = '/settings-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeScreen(),
    homeScreen: (context) => const HomeScreen(),
    addReminderScreen: (context) => const AddReminderScreen(),
    emergencyContactsScreen: (context) => const EmergencyContactsScreen(),
    settingsScreen: (context) => const SettingsScreen(),
  };
}
