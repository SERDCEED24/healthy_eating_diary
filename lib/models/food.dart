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
    List<String> allButName = [];
    for (var el in [calories, proteins, fats, carbohydrates, weight]) {
      allButName.add((el % 1 == 0) ? el.toStringAsFixed(0) : el.toString());
    }
    return "$name, К/Б/Ж/У - ${allButName[0]}/${allButName[1]}/${allButName[2]}/${allButName[3]},\nВес - ${allButName[4]} грамм";
  }
  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
  Map<String, dynamic> toJson() => _$FoodToJson(this);
}
