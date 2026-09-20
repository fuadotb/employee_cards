import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'employee_card_page.dart';

class HomePage extends StatefulWidget {
  final void Function(Locale locale) onLanguageChanged;

  const HomePage({
    super.key,
    required this.onLanguageChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;



  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),

        body: SafeArea(
          child: [
  const _HomeContent(),
  const _ServicesContent(),
  _MoreContent(
    onLanguageChanged: widget.onLanguageChanged,
  ),
][_currentIndex],
        ),

        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view),
              label: 'الخدمات',
            ),
            NavigationDestination(
              icon: Icon(Icons.more_horiz),
              selectedIcon: Icon(Icons.more_horiz),
              label: 'المزيد',
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 22,
            horizontal: 20,
          ),
          color: const Color(0xFFFFFFFF),
          child: Center(
            child: Image.asset(
              'assets/images/logo.png',
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
        ),

        const Expanded(
          child: Center(
            child: Text(
              'مرحباً بك  في خدمات الموظفين',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ServicesContent extends StatelessWidget {
  const _ServicesContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 22,
            horizontal: 20,
          ),
          color: const Color(0xFF006870),
          child: const Text(
            'الخدمات',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.05,
              children: [
                _ServiceCard(
                  title: 'بطاقة الموظف',
                  icon: Icons.badge_outlined,
                  onTap: () {
                                      
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EmployeeCardPage(),
                    ),
                  );
                  },
                ),

                const _ServiceCard(
                  title: 'قريباً',
                  icon: Icons.apps_outlined,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MoreContent extends StatelessWidget {
  final void Function(Locale locale) onLanguageChanged;

  const _MoreContent({
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 22,
            horizontal: 20,
          ),
          color: const Color(0xFF006870),
          child: Text(
            l10n.more,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        ListTile(
          leading: const Icon(Icons.language),
          title: Text(l10n.language),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('العربية'),
                        onTap: () {
                          onLanguageChanged(
                            const Locale('ar'),
                          );
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('English'),
                        onTap: () {
                          onLanguageChanged(
                            const Locale('en'),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const _ServiceCard({
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFE6F3F3),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                size: 34,
                color: const Color(0xFF006870),
              ),
            ),

            const SizedBox(height: 14),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}