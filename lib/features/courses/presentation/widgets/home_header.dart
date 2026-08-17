import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/notification_bell.dart';

/// The green, rounded-bottom header at the top of the Home screen: greeting,
/// notification bell, and the class/mentor search field.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.userName,
    this.hasUnreadNotifications = false,
    this.onNotificationTap,
    this.onSearchTap,
    super.key,
  });

  final String userName;
  final bool hasUnreadNotifications;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSearchTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'homeGreeting'.tr(namedArgs: {'name': userName}),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: scheme.onPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'homeSubtitle'.tr(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: scheme.onPrimary.withValues(
                                  alpha: 0.85,
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                  NotificationBell(
                    hasUnread: hasUnreadNotifications,
                    onTap: onNotificationTap,
                    color: scheme.onPrimary,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppSearchField(
                hintText: 'searchHint'.tr(),
                readOnly: true,
                onTap: onSearchTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
