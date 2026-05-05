
import '../../../core/app_export.dart';

class HomeAppBarWidget extends StatelessWidget {
  final String greeting;
  final String userName;
  final String avatarUrl;
  final String avatarSemanticLabel;
  final VoidCallback onNotificationTap;
  final bool bigButtonMode;

  const HomeAppBarWidget({
    super.key,
    required this.greeting,
    required this.userName,
    required this.avatarUrl,
    required this.avatarSemanticLabel,
    required this.onNotificationTap,
    this.bigButtonMode = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nameSize = bigButtonMode ? 18.0 : 16.0;
    final greetSize = bigButtonMode ? 14.0 : 13.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          // Avatar
          ClipOval(
            child: CustomImageWidget(
              imageUrl: avatarUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              semanticLabel: avatarSemanticLabel,
            ),
          ),
          const SizedBox(width: 12),
          // Greeting column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: GoogleFonts.nunitoSans(
                    fontSize: nameSize,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  greeting,
                  style: GoogleFonts.nunitoSans(
                    fontSize: greetSize,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Notification bell
          Semantics(
            label: 'Notifications',
            button: true,
            child: InkWell(
              onTap: onNotificationTap,
              borderRadius: BorderRadius.circular(50),
              splashColor: theme.colorScheme.primaryContainer,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'notifications',
                      color: theme.colorScheme.onSurface,
                      size: 24,
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppTheme.emergencyRed,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
