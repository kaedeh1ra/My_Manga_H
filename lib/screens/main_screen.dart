import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Box<String> imagesBox;

  @override
  void initState() {
    super.initState();
    imagesBox = Hive.box<String>('images');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sumi Studio !!")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Виджеты с картинками в два столбца
            ValueListenableBuilder(
              valueListenable: imagesBox.listenable(),
              builder: (context, Box<String> box, _) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  padding: const EdgeInsets.all(10),
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final imagePath = box.getAt(index);
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: imagePath != null
                          ? Image.file(
                              File(imagePath),
                              fit: BoxFit.cover,
                            )
                          : const SizedBox(), // Обработка null
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // TODO: Реализуйте логику выбора изображения (например, с помощью image_picker)
          // Временный путь для примера (замените на реальный путь к изображению)
          String tempImagePath = '/path/to/your/image.jpg';

          // Сохраняем путь к изображению в Hive
          await imagesBox.add(tempImagePath);

          setState(() {}); // Обновляем UI
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
