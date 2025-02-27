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
    with TickerProviderStateMixin {
  // Use TickerProviderStateMixin

  late AnimationController _cloudController; // Controller for cloud bounce
  late Animation<double> _cloudAnimation;

  late AnimationController _fadeController; // Controller for fade-in
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Cloud Bounce Animation
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _cloudAnimation = CurvedAnimation(
      parent: _cloudController,
      curve: Curves.easeInOut,
    );

    // Fade-in Animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward(); // Start fade-in immediately
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box>(
      future: Future.wait([
        Hive.openBox('initialized'),
        Future.delayed(const Duration(seconds: 5)),
      ]).then((results) => results[0]),
      builder: (BuildContext context, AsyncSnapshot<Box> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Stack(
              children: [
                Center(
                  child: AnimatedBuilder(
                    animation: _cloudAnimation, // Use _cloudAnimation here
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, -50 * _cloudAnimation.value),
                        child: child,
                      );
                    },
                    child: Image.asset(
                      'assets/images/loadingCloud.png',
                      fit: BoxFit.fitWidth,
                      width: 200,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Image.asset(
                      'assets/images/loading_top_cloud.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Image.asset(
                      'assets/images/loading_bottom_cloud.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
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
          final ColorScheme colorScheme = Theme.of(context).colorScheme;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    initialized.isApplyPolicy ? MainScreen() : StartPages(),
              ),
            );
          });

          // Возвращаем пустой контейнер, пока выполняется навигация
          return Container(
            color: colorScheme.background,
          );
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
