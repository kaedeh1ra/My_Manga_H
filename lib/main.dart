import 'package:flutter/material.dart';
import 'package:my_manga_h/screens/1screens.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hentai ah ah',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      // Change to ThemeMode.light to see the light the
      home: DrawingScreen(),
    );
  }
}
