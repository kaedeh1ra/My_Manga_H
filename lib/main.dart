import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_manga_h/initialized.dart';
import 'package:my_manga_h/screens/1screens.dart';
import 'package:flutter/material.dart';
import 'package:my_manga_h/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'manga_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  Hive.registerAdapter(InitializedAdapter());
  await Hive.openBox('initialized');
  Hive.registerAdapter(MangaDataAdapter());
  await Hive.openBox<MangaData>('mangas');
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

      /// При запуске приложения активируется экран с загрузочной анимацией
    );
  }
}
