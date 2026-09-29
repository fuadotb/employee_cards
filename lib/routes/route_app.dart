
import 'package:employee_cards/core/theme/app_colors.dart';
import 'package:employee_cards/screens/bottom_nav_bar.dart';
import 'package:employee_cards/screens/more.dart';
import 'package:employee_cards/screens/services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home_screen/home_page.dart';
import '../screens/emplyee/employee_card_page.dart';
import '../screens/home_screen/news_detail_page.dart';
import '../screens/assistant_page.dart';
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

        GoRoute(
          path: RouteKey.newsDetail,
          builder: (context, state) {
            final newsId = int.tryParse(
              state.pathParameters['id'] ?? '',
            );

            return NewsDetailPage(newsId: newsId ?? 0);
          },
        ),

        GoRoute(
          path: RouteKey.assistant,
          builder: (context, state) {
            return const AssistantPage();
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

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          context.push(RouteKey.assistant);
        },
        child: const Icon(
          Icons.support_agent_rounded,
          color: Colors.white,
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        navigationShell: navigationShell,
      ),
    );
  }
}
