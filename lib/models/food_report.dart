import 'package:json_annotation/json_annotation.dart';

part 'food_report.g.dart';

@JsonSerializable()
class FoodReport {
  double calories;
  double proteins;
  double fats;
  double carbohydrates;
  double caloriesNormal;
  double proteinsNormal;
  double fatsNormal;
  double carbohydratesNormal;

  FoodReport(
      {required this.calories,
      required this.proteins,
      required this.fats,
      required this.carbohydrates,
      required this.caloriesNormal,
      required this.proteinsNormal,
      required this.fatsNormal,
      required this.carbohydratesNormal
  });

  factory FoodReport.fromJson(Map<String, dynamic> json) => _$FoodReportFromJson(json);
  Map<String, dynamic> toJson() => _$FoodReportToJson(this);
}
