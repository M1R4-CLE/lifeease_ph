import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class AppNavigation extends StatelessWidget {
  final int currentIndex;
  final bool bigButtonMode;

  const AppNavigation({
    super.key,
    required this.currentIndex,
    required this.bigButtonMode,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    String routeName;
    switch (index) {
      case 0:
        routeName = AppRoutes.homeScreen;
        break;
      case 1:
        routeName = AppRoutes.addReminderScreen;
        break;
      case 2:
        routeName = AppRoutes.emergencyContactsScreen;
        break;
      case 3:
        routeName = AppRoutes.settingsScreen;
        break;
      default:
        routeName = AppRoutes.homeScreen;
    }

    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) => _onItemTapped(context, index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline_rounded),
          label: 'Add',
        ),
        NavigationDestination(
          icon: Icon(Icons.contact_phone_rounded),
          label: 'Contacts',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_rounded),
          label: 'Settings',
        ),
      ],
    );
  }
}
