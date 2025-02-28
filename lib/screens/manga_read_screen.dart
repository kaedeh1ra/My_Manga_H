import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_manga_h/screens/1screens.dart';
import '../manga_data.dart';
import 'package:path_provider/path_provider.dart';

class MangaReadScreen extends StatefulWidget {
  final int mangaIndex;

  const MangaReadScreen({super.key, required this.mangaIndex});

  @override
  _MangaReadScreenState createState() => _MangaReadScreenState();
}

class _MangaReadScreenState extends State<MangaReadScreen> {
  late Future<DataModel> _dataFuture;
  late Box<MangaData> mangaBox;
  late MangaData _manga;
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    mangaBox = Hive.box<MangaData>('mangas');
    _manga = mangaBox.getAt(widget.mangaIndex)!;
    _titleController.text = _manga.title;
    _dataFuture = _fetchData();
  }

  Future<DataModel> _fetchData() async {
    await Future.delayed(const Duration(seconds: 1));
    return DataModel(
        DateTime.now().toString()); // Replace with your data source
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          onChanged: (value) {
            setState(() {
              _manga.title = value;
              mangaBox.putAt(widget.mangaIndex, _manga);
            });
          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                final appDir = await getApplicationDocumentsDirectory();
                final mangaIndex = widget.mangaIndex;
                final mangaDir = Directory('${appDir.path}/manga/$mangaIndex');

                // Создаем директорию, если ее нет
                if (!mangaDir.existsSync()) {
                  mangaDir.createSync(recursive: true);
                }

                final nextPageIndex = _manga.pagePaths.length;
                final fileName = '$nextPageIndex.png';
                final filePath = '${mangaDir.path}/$fileName';

                // Загружаем изображение из assets
                final byteData = await rootBundle.load('assets/images/0.png');
                final buffer = byteData.buffer;

                // Сохраняем изображение в директорию
                final file = File(filePath);
                await file.writeAsBytes(buffer.asUint8List(
                    byteData.offsetInBytes, byteData.lengthInBytes));

                setState(() {
                  _manga.pagePaths.add(filePath);
                  mangaBox.putAt(widget.mangaIndex, _manga);
                });
              }),
        ],
      ),
      body: FutureBuilder<DataModel>(
          future: _dataFuture,
          builder: (context, snapshot) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisExtent:
                      (MediaQuery.of(context).size.width / 9 * 16) + 2),
              itemCount: _manga.pagePaths.length,
              itemBuilder: (context, index) {
                final pagePath = _manga.pagePaths[index];
                return Dismissible(
                  key: Key(pagePath),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    setState(() {
                      _manga.pagePaths.removeAt(index);
                      mangaBox.putAt(widget.mangaIndex, _manga);
                    });
                    if (_manga.pagePaths.isEmpty) {
                      await mangaBox.deleteAt(widget.mangaIndex);
                      Navigator.pop(context);
                    }
                    // Здесь можно добавить удаление файла из файловой системы
                  },
                  background: Container(
                    color: Colors.red,
                    child: Icon(CupertinoIcons.trash),
                  ),
                  child: GestureDetector(
                    onDoubleTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DrawingScreen(
                                    pagePath: pagePath,
                                    pictureIndex: index,
                                  )));
                    },
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.file(
                          File(pagePath),
                          fit: BoxFit.cover,
                        )),
                  ),
                );
              },
            );
          }),
    );
  }
}

class DataModel {
  final String value;
  DataModel(this.value);
}
