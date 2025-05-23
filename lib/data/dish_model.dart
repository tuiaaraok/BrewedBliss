import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'dish_model.g.dart';

@HiveType(typeId: 1)
class DishModel {
  @HiveField(0)
  String dishName;
  @HiveField(1)
  String price;
  @HiveField(2)
  String category;
  @HiveField(3)
  int count;
  @HiveField(4)
  Uint8List? image;
  DishModel({
    required this.dishName,
    required this.price,
    required this.category,
    required this.image,
    this.count = 0,
  });
}
