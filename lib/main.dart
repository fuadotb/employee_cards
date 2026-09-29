import 'package:employee_cards/core/theme/app_theme.dart';
import 'package:employee_cards/routes/route_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const EmployeeCardsApp());
}

class EmployeeCardsApp extends StatefulWidget {
  const EmployeeCardsApp({super.key});

  @override
  State<EmployeeCardsApp> createState() => _EmployeeCardsAppState();
}

class _EmployeeCardsAppState extends State<EmployeeCardsApp> {
  Locale _locale = const Locale('ar');
  ThemeMode _themeMode = ThemeMode.system;

  late final router = RouteApp.routes(
    changeLanguage,
    changeTheme,
    () => _themeMode,
  );

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      backButtonDispatcher: router.backButtonDispatcher,
    );
  }
}
