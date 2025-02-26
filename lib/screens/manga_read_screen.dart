import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../manga_data.dart';
import 'package:path_provider/path_provider.dart';

class MangaReadScreen extends StatefulWidget {
  final int mangaIndex;

  MangaReadScreen({required this.mangaIndex});

  @override
  _MangaReadScreenState createState() => _MangaReadScreenState();
}

class _MangaReadScreenState extends State<MangaReadScreen> {
  late final Box<MangaData> _mangaBox;
  late MangaData _manga;
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mangaBox = Hive.box<MangaData>('mangas');
    _manga = _mangaBox.getAt(widget.mangaIndex)!;
    _titleController.text = _manga.title;
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
              _mangaBox.putAt(widget.mangaIndex, _manga);
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final imagePicker = ImagePicker();
              final pickedImage =
                  await imagePicker.pickImage(source: ImageSource.gallery);
              if (pickedImage != null) {
                final appDir = await getApplicationDocumentsDirectory();
                final mangaIndex = widget.mangaIndex;
                final mangaDir = Directory('${appDir.path}/manga/$mangaIndex');
                final nextPageIndex = _manga.pagePaths.length;
                final fileName = '$nextPageIndex.png';
                final savedImage = await File(pickedImage.path)
                    .copy('${mangaDir.path}/$fileName');

                setState(() {
                  _manga.pagePaths.add(savedImage.path);
                  _mangaBox.putAt(widget.mangaIndex, _manga);
                });
              }
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisExtent: MediaQuery.of(context).size.width / 9 * 16),
        itemCount: _manga.pagePaths.length,
        itemBuilder: (context, index) {
          final pagePath = _manga.pagePaths[index];
          return Dismissible(
            key: Key(pagePath),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                _manga.pagePaths.removeAt(index);
                _mangaBox.putAt(widget.mangaIndex, _manga);
              });
              // Здесь можно добавить удаление файла из файловой системы
            },
            background: Container(
              color: Colors.red,
              child: Icon(CupertinoIcons.trash),
            ),
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.file(
                  File(pagePath),
                  fit: BoxFit.cover,
                )),
          );
        },
      ),
    );
  }
}
