import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_manga_h/initialized.dart';
import 'package:my_manga_h/screens/1screens.dart';
import 'package:flutter/material.dart';
import 'package:my_manga_h/theme.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(InitializedAdapter());
  await Hive.openBox('initialized');

  await Hive.openBox('images');
  runApp(SumiStudioApp());
}

class SumiStudioApp extends StatelessWidget {
  const SumiStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sumi Studio',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      home: SplashScreen(),
    );
  }
}
