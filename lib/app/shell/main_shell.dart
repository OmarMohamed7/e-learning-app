import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mentor_stream_flutter/features/account/presentation/pages/account_page.dart';
import 'package:mentor_stream_flutter/features/courses/presentation/pages/home_page.dart';
import 'package:mentor_stream_flutter/features/courses/presentation/pages/my_courses_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../theme/theme_controller.dart';

class MainShell extends ConsumerWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schema = Theme.of(context).colorScheme;
    final themeMode = ref.watch(themeModeProvider);

    final brightness = themeMode == ThemeMode.system
        ? MediaQuery.platformBrightnessOf(context)
        : (themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light);

    final barBackgroundColor =
        (brightness == Brightness.dark ? Colors.black : Colors.white)
            .withValues(alpha: 0.7);

    return Scaffold(
      body: navigationShell,

      bottomNavigationBar: PersistentTabView(
        tabs: [
          PersistentTabConfig(
            screen: HomePage(),
            item: ItemConfig(
              icon: Icon(Icons.home),
              title: "Home".tr(),
              activeForegroundColor: schema.primary,
            ),
          ),
          PersistentTabConfig(
            screen: MyCoursesPage(),
            item: ItemConfig(
              icon: Icon(Icons.menu_book, color: Colors.white),
              title: "My Courses".tr(),
              activeForegroundColor: schema.primary,
            ),
          ),
          PersistentTabConfig(
            screen: AccountPage(),
            item: ItemConfig(
              icon: Icon(Icons.person),
              title: "Account".tr(),
              activeForegroundColor: schema.primary,
            ),
          ),
        ],
        backgroundColor: barBackgroundColor,
        navBarBuilder: (navBarConfig) =>
            Style13BottomNavBar(navBarConfig: navBarConfig),
      ),
    );
  }
}
