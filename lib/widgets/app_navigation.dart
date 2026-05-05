import '../core/app_export.dart';
import '../routes/app_routes.dart';

class AppNavigation extends StatelessWidget {
  final int currentIndex;
  final bool bigButtonMode;

  const AppNavigation({
    super.key,
    required this.currentIndex,
    this.bigButtonMode = true,
  });

  void _onDestinationSelected(BuildContext context, int index) {
    if (index == currentIndex) return;
    final routes = [
      AppRoutes.homeScreen,
      AppRoutes.addReminderScreen,
      AppRoutes.emergencyContactsScreen,
      AppRoutes.settingsScreen,
    ];
    if (index < routes.length) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        routes[index],
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navHeight = bigButtonMode ? 80.0 : 72.0;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: navHeight,
          child: Row(
            children: [
              _NavItem(
                icon: 'home_outlined',
                activeIcon: 'home',
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => _onDestinationSelected(context, 0),
                bigButtonMode: bigButtonMode,
              ),
              _NavItem(
                icon: 'alarm_outlined',
                activeIcon: 'alarm',
                label: 'Reminders',
                isActive: currentIndex == 1,
                onTap: () => _onDestinationSelected(context, 1),
                bigButtonMode: bigButtonMode,
              ),
              _NavItem(
                icon: 'emergency_outlined',
                activeIcon: 'emergency',
                label: 'Emergency',
                isActive: currentIndex == 2,
                onTap: () => _onDestinationSelected(context, 2),
                bigButtonMode: bigButtonMode,
              ),
              _NavItem(
                icon: 'settings_outlined',
                activeIcon: 'settings',
                label: 'Settings',
                isActive: currentIndex == 3,
                onTap: () => _onDestinationSelected(context, 3),
                bigButtonMode: bigButtonMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool bigButtonMode;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.bigButtonMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelSize = bigButtonMode ? 13.0 : 12.0;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                color: isActive
                    ? theme.colorScheme.primaryContainer
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
              ),
              child: CustomIconWidget(
                iconName: isActive ? activeIcon : icon,
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                size: bigButtonMode ? 26 : 24,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.nunitoSans(
                fontSize: labelSize,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
