import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'screens/home_page.dart';

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

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      locale: _locale,

      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF006870),
      ),

      home: HomePage(
        onLanguageChanged: changeLanguage,
      ),
    );
  }
}