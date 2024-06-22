import 'package:json_annotation/json_annotation.dart';

part 'food.g.dart';

@JsonSerializable()
class Food {
  String name;
  double calories;
  double proteins;
  double fats;
  double carbohydrates;
  Food(
      {required this.name,
      required this.calories,
      required this.proteins,
      required this.fats,
      required this.carbohydrates
  });
  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
  Map<String, dynamic> toJson() => _$FoodToJson(this);
}
