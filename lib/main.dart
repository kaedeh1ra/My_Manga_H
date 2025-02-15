import 'package:my_manga_h/screens/1screens.dart';
import 'package:flutter/material.dart';

void main() => runApp(const PageViewExampleApp());

class PageViewExampleApp extends StatelessWidget {
  const PageViewExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('PageView Sample')),
        body: PageViewExample(),
      ),
    );
  }
}
