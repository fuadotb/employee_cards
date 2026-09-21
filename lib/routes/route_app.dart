
import 'package:employee_cards/screens/bottom_nav_bar.dart';
import 'package:employee_cards/screens/more.dart';
import 'package:employee_cards/screens/services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home_page.dart';
import '../screens/employee_card_page.dart';
import 'route_key.dart';

class RouteApp {
  static GoRouter routes(
    void Function(Locale locale) onLanguageChanged,
  ) {
    return GoRouter(
      initialLocation: RouteKey.home,

      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainShell(
              navigationShell: navigationShell,
            );
          },

          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteKey.home,
                  builder: (context, state) {
                    return const HomePage();
                  },
                ),
              ],
            ),

            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteKey.services,
                  builder: (context, state) {
                    return const ServicesPage();
                  },
                ),
              ],
            ),

            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteKey.more,
                  builder: (context, state) {
                    return MorePage(
                      onLanguageChanged: onLanguageChanged,
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        GoRoute(
          path: RouteKey.employeeCard,
          builder: (context, state) {
            return const EmployeeCardPage();
          },
        ),
      ],
    );
  }
}

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,

      bottomNavigationBar: BottomNavBar(
        navigationShell: navigationShell,
      ),
    );
  }
}
