import 'package:app/helper/jwt_helper.dart';
import 'package:app/pages/history_page.dart';
import 'package:app/pages/home_page.dart';
import 'package:app/pages/login_or_register/login_or_register_page.dart';
import 'package:app/pages/settings_page.dart';
import 'package:app/pages/statistics_page.dart';
import 'package:app/theme/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  await initializeHive();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JWTHelper.getActiveJWT() != null ? const HomePage() : const LoginOrRegisterPage(isLogin: true),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        '/login_or_register_page': (context) => const LoginOrRegisterPage(isLogin: true),
        '/home_page': (context) => const HomePage(),
        '/settings_page': (context) => const SettingsPage(),
        '/history_page': (context) => const HistoryPage(),
        '/statistics_page': (context) => const StatisticsPage(),
      },
    );
  }
}

Future<void> initializeHive() async {
  await Hive.initFlutter();

  try {
    if (!Hive.isBoxOpen('userBox')) await Hive.openBox('userBox');
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing Hive: $e');
    }
  }
}
