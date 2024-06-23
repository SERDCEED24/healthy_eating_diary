import 'package:json_annotation/json_annotation.dart';

part 'food.g.dart';

@JsonSerializable()
class Food {
  String name;
  double calories;
  double proteins;
  double fats;
  double carbohydrates;
  double weight;
  Food(
      {required this.name,
      required this.calories,
      required this.proteins,
      required this.fats,
      required this.carbohydrates,
      required this.weight
  });
  @override
  String toString() {
    return "$name, К/Б/Ж/У - ${calories(user.weight % 1 == 0) ? user.weight.toStringAsFixed(0) : user.weight.toString()}/$proteins/$fats/$carbohydrates,\nВес - $weight грамм";
  }
  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
  Map<String, dynamic> toJson() => _$FoodToJson(this);
}
