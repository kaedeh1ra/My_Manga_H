import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_manga_h/initialized.dart';
import 'package:my_manga_h/screens/1screens.dart';
import 'package:my_manga_h/widgets/button.dart';

class StartPages extends StatefulWidget {
  const StartPages({super.key});

  @override
  State<StartPages> createState() => _StartPagesState();
}

class _StartPagesState extends State<StartPages> with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    var checkedValue = 5;

    return Container(
      color: colorScheme.background,
      child: ValueListenableBuilder(
          valueListenable: Hive.box('initialized').listenable(),
          builder: (context, value, _) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                PageView(
                  /// [PageView.scrollDirection] defaults to [Axis.horizontal].
                  /// Use [Axis.vertical] to scroll vertically.
                  controller: _pageViewController,
                  onPageChanged: _handlePageViewChanged,
                  children: <Widget>[
                    FirstWidget(),
                    SecondWidget(),
                    ThirdWidget(),
                  ],
                ),
                PageIndicator(
                  tabController: _tabController,
                  currentPageIndex: _currentPageIndex,
                  onUpdateCurrentPageIndex: _updateCurrentPageIndex,
                  isOnDesktopAndWeb: _isOnDesktopAndWeb,
                ),
              ],
            );
          }),
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    if (!_isOnDesktopAndWeb) {
      return;
    }
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  bool get _isOnDesktopAndWeb =>
      kIsWeb ||
      switch (defaultTargetPlatform) {
        TargetPlatform.macOS ||
        TargetPlatform.linux ||
        TargetPlatform.windows =>
          true,
        TargetPlatform.android ||
        TargetPlatform.iOS ||
        TargetPlatform.fuchsia =>
          false,
      };
}

/// Page indicator for desktop and web platforms.
///
/// On Desktop and Web, drag gesture for horizontal scrolling in a PageView is disabled by default.
/// You can defined a custom scroll behavior to activate drag gestures,
/// see https://docs.flutter.dev/release/breaking-changes/default-scroll-behavior-drag.
///
/// In this sample, we use a TabPageSelector to navigate between pages,
/// in order to build natural behavior similar to other desktop applications.
class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
    required this.isOnDesktopAndWeb,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    if (!isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 0) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex - 1);
            },
            icon: const Icon(Icons.arrow_left_rounded, size: 32.0),
          ),
          TabPageSelector(
            controller: tabController,
            color: colorScheme.surface,
            selectedColor: colorScheme.primary,
          ),
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 2) {
                return;
              }

              onUpdateCurrentPageIndex(currentPageIndex + 1);
            },
            icon: const Icon(Icons.arrow_right_rounded, size: 32.0),
          ),
        ],
      ),
    );
  }
}

class FirstWidget extends StatelessWidget {
  const FirstWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Flexible(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Expanded(
                  child: SizedBox(
                height: 1,
              )),
              Image.asset(
                'assets/images/st_page_1_cloud.png',
                height: 320,
              ),
              SizedBox(
                height: 0,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Buttondef(
                  height: 60,
                  textSize: 30,
                  onTap: () {},
                  rounded: 20,
                  isTextInside: true,
                  text: '------------------->',
                ),
              ),
              Image.asset(
                'assets/images/loading_bottom_cloud.png',
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondWidget extends StatelessWidget {
  const SecondWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Flexible(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Expanded(
                  child: SizedBox(
                height: 1,
              )),
              Image.asset(
                'assets/images/st_page_2_cloud.png',
                height: 320,
              ),
              SizedBox(
                height: 0,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Buttondef(
                  height: 60,
                  textSize: 30,
                  onTap: () {},
                  rounded: 20,
                  isTextInside: true,
                  text: '------------------->',
                ),
              ),
              Image.asset(
                'assets/images/loading_bottom_cloud.png',
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThirdWidget extends StatelessWidget {
  const ThirdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    /// TODO: Есть кнопка готовая Buttondef() Посмотри её аргументы и добавь на неё принятие политики и переход на другой экран
    return Flexible(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Expanded(
                  child: SizedBox(
                height: 1,
              )),
              Image.asset(
                'assets/images/st_page_3_cloud.png',
                height: 300,
              ),
              SizedBox(
                height: 0,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Buttondef(
                  height: 60,
                  onTap: () {
                    _updateInitialBox();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ),
                    );
                  },
                  rounded: 20,
                  isTextInside: true,
                  text: 'Я согласен на обработку персональный данных',
                ),
              ),
              Image.asset(
                'assets/images/loading_bottom_cloud.png', // Путь к вашему изображению
                fit: BoxFit.cover, // Или другой fit
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateInitialBox() async {
    final box = await Hive.openBox('initialized');
    final initialized = box.get('initialized') as Initialized;
    final updatedInitialized = Initialized(
      isApplyPolicy: true,
      isCreateFirstManga: initialized.isCreateFirstManga,
      isCheckedMangaFirstly: initialized.isCheckedMangaFirstly,
    );
    await box.put('initialized', updatedInitialized);

    await box.close();
  }
}
