import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_manga_h/initialized.dart';
import 'package:my_manga_h/screens/1screens.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(InitializedAdapter());
  await Hive.openBox('initialized');
  runApp(SumiStudioApp());
}

class SumiStudioApp extends StatelessWidget {
  const SumiStudioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Box>(
        future: Hive.openBox('initialized'),
        builder: (BuildContext context, AsyncSnapshot<Box> snapshot) {
          if (snapshot.hasData) {
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
            return Scaffold(
              body: !initialized.isApplyPolicy ? StartPages() : MainScreen(),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
