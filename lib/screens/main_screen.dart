import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_manga_h/manga_data.dart';
import 'package:path/path.dart' as path;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_manga_h/widgets/button.dart';
import 'package:my_manga_h/widgets/manga_card.dart';
import 'package:my_manga_h/widgets/sumi-banner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'manga_read_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Box<MangaData> mangaBox;

  @override
  void initState() {
    super.initState();
    mangaBox = Hive.box<MangaData>('mangas');
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            SumiStudioBanner(
              text: 'Идеи',
              onTap: () {
                _launchUrl('https://ru.freepik.com/');
              },
            ),
            Buttondef(
              icon: Icons.add,
              onTap: () async {
                final mangaIndex = Hive.box<MangaData>('mangas').length;
                final appDir = await getApplicationDocumentsDirectory();
                final mangaDir = Directory('${appDir.path}/manga/$mangaIndex');

                // Проверяем, существует ли директория, и создаем, если нет
                if (!await mangaDir.exists()) {
                  await mangaDir.create(recursive: true);
                }

                // Копируем 0.png из assets
                final assetBundle = DefaultAssetBundle.of(context);
                final byteData = await assetBundle.load('assets/images/0.png');
                final buffer = byteData.buffer;
                final firstPagePath = path.join(mangaDir.path, '0.png');
                await File(firstPagePath).writeAsBytes(buffer.asUint8List(
                    byteData.offsetInBytes, byteData.lengthInBytes));

                final newManga =
                    MangaData(title: 'Новая манга', pagePaths: [firstPagePath]);
                await Hive.box<MangaData>('mangas').add(newManga);
                setState(() {}); // Обновляем UI
              },
            ),
            // Виджеты с картинками в два столбца
            ValueListenableBuilder(
              valueListenable: mangaBox.listenable(),
              builder: (context, Box<MangaData> box, _) {
                return mangaBox.length != 0
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1,
                            mainAxisExtent: 250),
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          final manga = box.getAt(index)!;
                          return GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MangaReadScreen(mangaIndex: index))),
                              child: MangaCard(
                                manga: manga,
                              ));
                        },
                      )
                    : Image.asset(
                        'assets/images/cloud1.png',
                        width: MediaQuery.of(context).size.width * 0.85,
                      );
              },
            ),
            SizedBox(height: 20),
            FittedBox(
              fit: BoxFit.cover,
              child: Image.asset(
                'assets/images/clouds2.png',
              ),
            )
          ],
        ),
      ),
    );
  }
}
