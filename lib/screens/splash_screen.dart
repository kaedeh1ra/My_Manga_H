import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../initialized.dart';
import '1screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box>(
      future: Future.wait([
        // Используем Future.wait для одновременного выполнения
        Hive.openBox('initialized'),
        Future.delayed(const Duration(seconds: 3)), // Задержка 3 секунды
      ]).then((results) => results[0]),
      builder: (BuildContext context, AsyncSnapshot<Box> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            // Анимированный экран загрузки
            body: Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -50 * _animation.value),
                    child: child,
                  );
                },
                child: Text('Добавьте сюда анимку пока база грузится'),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final box = snapshot.data!;
          if (box.get('initialized') == null) {
            box.put(
              'initialized',
              Initialized(
                isApplyPolicy: false,
                isCreateFirstManga: false,
                isCheckedMangaFirstly: false,
              ),
            );
          }
          final initialized = box.get('initialized') as Initialized;
          return initialized.isApplyPolicy ? MainScreen() : StartPages();
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          return const Scaffold(
            // Возвращаем пустой Scaffold, если данных нет
            body: SizedBox(
              child: Text('Возникла ошибка загрузки данных('),
            ),
          );
        }
      },
    );
  }
}
