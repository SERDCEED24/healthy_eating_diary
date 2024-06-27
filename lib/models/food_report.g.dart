// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodReport _$FoodReportFromJson(Map<String, dynamic> json) => FoodReport(
      calories: (json['calories'] as num).toDouble(),
      proteins: (json['proteins'] as num).toDouble(),
      fats: (json['fats'] as num).toDouble(),
      carbohydrates: (json['carbohydrates'] as num).toDouble(),
      caloriesNormal: (json['caloriesNormal'] as num).toDouble(),
      proteinsNormal: (json['proteinsNormal'] as num).toDouble(),
      fatsNormal: (json['fatsNormal'] as num).toDouble(),
      carbohydratesNormal: (json['carbohydratesNormal'] as num).toDouble(),
    );

Map<String, dynamic> _$FoodReportToJson(FoodReport instance) =>
    <String, dynamic>{
      'calories': instance.calories,
      'proteins': instance.proteins,
      'fats': instance.fats,
      'carbohydrates': instance.carbohydrates,
      'caloriesNormal': instance.caloriesNormal,
      'proteinsNormal': instance.proteinsNormal,
      'fatsNormal': instance.fatsNormal,
      'carbohydratesNormal': instance.carbohydratesNormal,
    };
