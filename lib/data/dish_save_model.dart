import 'package:hive_flutter/hive_flutter.dart';

part 'dish_save_model.g.dart';

@HiveType(typeId: 3)
class DishSaveModel {
  @HiveField(0)
  bool isCash;
  @HiveField(1)
  double total;
  @HiveField(2)
  DateTime date;
  DishSaveModel({
    required this.date,
    required this.isCash,
    required this.total,
  });
}
