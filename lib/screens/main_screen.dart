import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_manga_h/manga_data.dart';
import 'package:my_manga_h/widgets/button.dart';
import 'package:my_manga_h/widgets/manga_card.dart';
import 'package:my_manga_h/widgets/sumi-banner.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            SumiStudioBanner(
              text: 'Идеи',
              onTap: () {},
            ),
            Buttondef(
              icon: Icons.add,
              onTap: () async {
                final mangaIndex = Hive.box<MangaData>('mangas').length;
                final firstPagePath =
                    'path/to/manga/$mangaIndex/0.png'; // Пока заглушка, позже заменим на реальное сохранение
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
                        ),
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          final imagePath = box.getAt(index);
                          return MangaCard(imagePath: 'assets/images/i.webp');
                        },
                      )
                    : Image.asset('assets/images/i.webp');
              },
            ),
            SizedBox(height: 20),
            FittedBox(
              fit: BoxFit.cover,
              child: Image.asset(
                'assets/images/i.webp',
              ),
            )
          ],
        ),
      ),
    );
  }
}
