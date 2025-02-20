import 'package:hive/hive.dart';

part 'initialized.g.dart';

@HiveType(typeId: 1)
class Initialized {
  Initialized(
      {required this.isApplyPolicy,
      required this.isCreateFirstManga,
      required this.isCheckedMangaFirstly});

  @HiveField(0)
  late bool isApplyPolicy;

  @HiveField(1)
  late bool isCreateFirstManga;

  @HiveField(2)
  late bool isCheckedMangaFirstly;
}
