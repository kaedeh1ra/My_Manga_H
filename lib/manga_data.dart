import 'package:hive/hive.dart';

part 'manga_data.g.dart';

@HiveType(typeId: 0)
class MangaData {
  @HiveField(0)
  String title;

  @HiveField(1)
  List<String> pagePaths;

  MangaData({required this.title, required this.pagePaths});
}
