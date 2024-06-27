import 'package:flutter/material.dart';
import 'package:healthy_eating_diary/models/food_report.dart';
import 'package:healthy_eating_diary/widgets/scaffold_with_panel.dart';
import 'package:provider/provider.dart';
import 'package:healthy_eating_diary/screens/registration_screen.dart';
import 'package:healthy_eating_diary/models/person.dart';
import 'package:healthy_eating_diary/models/food.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainAppState(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        title: 'Дневник здорового питания',
        home: Consumer<MainAppState>(
          builder: (context, mainAppState, child) {
            if (mainAppState.user.isEmpty()) {
              return const RegistrationScreen();
            } else {
              return const ScaffoldWithPanel();
            }
          },
        ),
      ),
    );
  }
}

class MainAppState extends ChangeNotifier {
  Person user = Person.empty();
  double kcalNormal = 0.0;
  double proteinsNormal = 0.0;
  double carbsNormal = 0.0;
  double fatsNormal = 0.0;
  int chartSubstanceIndex = 0;
  var dailyNorms = {};
  var mealNorms = {};
  List<double> chartPointsReal = []; 
  List<double> chartPointsNorm = []; 
  var consumedSubstances = [0.0, 0.0, 0.0, 0.0];
  var consumedCaloriesPerMeal = [0.0, 0.0, 0.0];
  List<Food> selectedFoodList = [];
  List<List<Food>> allSelectedFood = [[], [], []];
  Map<String, FoodReport> reports = {};
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController genderCtrl = TextEditingController();
  TextEditingController ageCtrl = TextEditingController();
  TextEditingController weightCtrl = TextEditingController();
  TextEditingController heightCtrl = TextEditingController();
  void saveProfileDataFromTextFields() {
    user.name = nameCtrl.text.trim();
    String gender = genderCtrl.text.trim();
    if (gender == "М"){
      gender = 'Мужчина';
    }
    if (gender == "Ж"){
      gender = "Женщина";
    }
    user.gender = gender;
    user.age = int.parse(ageCtrl.text.trim());
    user.weight = double.parse(weightCtrl.text.trim());
    user.height = double.parse(heightCtrl.text.trim());
    saveProfileDataToSharedPrefs();
    notifyListeners();
  }

  void sendProfileDataToTextFields() {
    if (user.isEmpty()) {
      nameCtrl.text = "";
      genderCtrl.text = "";
      ageCtrl.text = "";
      weightCtrl.text = "";
      heightCtrl.text = "";
    } 
    else {
      nameCtrl.text = user.name;
      genderCtrl.text = user.gender;
      ageCtrl.text = user.age.toString();
      weightCtrl.text = (user.weight % 1 == 0) ? user.weight.toStringAsFixed(0) : user.weight.toString();
      heightCtrl.text = (user.height % 1 == 0) ? user.height.toStringAsFixed(0) : user.height.toString();
    }
    notifyListeners();
  }

  void changeChartValues(int substanceIndex){
    chartSubstanceIndex = substanceIndex;
    
    var caloriesReal = List<double>.filled(7, 0.0);
    var caloriesNorms = List<double>.filled(7, 0.0);
    var proteinsReal = List<double>.filled(7, 0.0);
    var proteinsNorms = List<double>.filled(7, 0.0);
    var fatsReal = List<double>.filled(7, 0.0);
    var fatsNorms = List<double>.filled(7, 0.0);
    var carbsReal = List<double>.filled(7, 0.0);
    var carbsNorms = List<double>.filled(7, 0.0);

    for (String dateStr in reports.keys) {
      DateTime date = DateFormat('dd.MM.yyyy').parse(dateStr);
      int dayIndex = date.weekday - 1;
      FoodReport report = reports[dateStr]!;
      caloriesReal[dayIndex] = report.calories;
      caloriesNorms[dayIndex] = report.caloriesNormal;
      proteinsReal[dayIndex] = report.proteins;
      proteinsNorms[dayIndex] = report.proteinsNormal;
      fatsReal[dayIndex] = report.fats;
      fatsNorms[dayIndex] = report.fatsNormal;
      carbsReal[dayIndex] = report.carbohydrates;
      carbsNorms[dayIndex] = report.carbohydratesNormal;
    }

    switch (substanceIndex){
      case 0:
        chartPointsNorm = caloriesNorms;
        chartPointsReal = caloriesReal;
      case 1:
        chartPointsNorm = proteinsNorms;
        chartPointsReal = proteinsReal;
      case 2:
        chartPointsNorm = fatsNorms;
        chartPointsReal = fatsReal;
      case 3:
        chartPointsNorm = carbsNorms;
        chartPointsReal = carbsReal;
    }
    notifyListeners();
  }

  void saveDiaryDataToSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('day', DateTime.now().day);
    prefs.setDouble('calories_breakfast', consumedCaloriesPerMeal[0]);
    prefs.setDouble('calories_lunch', consumedCaloriesPerMeal[1]);
    prefs.setDouble('calories_dinner', consumedCaloriesPerMeal[2]);
    prefs.setDouble('calories_day', consumedSubstances[0]);
    prefs.setDouble('proteins_day', consumedSubstances[1]);
    prefs.setDouble('fats_day', consumedSubstances[2]);
    prefs.setDouble('carbs_day', consumedSubstances[3]);
    prefs.setString('last_saved_date', DateTime.now().toIso8601String());
  }

  void readDiaryDataFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    String? lastSavedDate = prefs.getString('last_saved_date');

    if (lastSavedDate != null) {
      DateTime lastDate = DateTime.parse(lastSavedDate);
      DateTime currentDate = DateTime.now();
      if (lastDate.year != currentDate.year || lastDate.month != currentDate.month || lastDate.day != currentDate.day) {
        _resetDiaryData();
      } 
      else {
        consumedCaloriesPerMeal[0] = prefs.getDouble('calories_breakfast') ?? 0.0;
        consumedCaloriesPerMeal[1] = prefs.getDouble('calories_lunch') ?? 0.0;
        consumedCaloriesPerMeal[2] = prefs.getDouble('calories_dinner') ?? 0.0;
        consumedSubstances[0] = prefs.getDouble('calories_day') ?? 0.0;
        consumedSubstances[1] = prefs.getDouble('proteins_day') ?? 0.0;
        consumedSubstances[2] = prefs.getDouble('fats_day') ?? 0.0;
        consumedSubstances[3] = prefs.getDouble('carbohydrates_day') ?? 0.0;
      }
    } 
    else {
      _resetDiaryData();
    }

    notifyListeners();
  }

  void saveReportsToJson() async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(reports.map((key, value) => MapEntry(key, value.toJson())));
    await prefs.setString('foodReports', jsonString);
  }
  void addOrReplaceReport() {
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("dd.MM.yyyy");
    String nowStr = dateFormat.format(now);
    if (reports.length == 7){
      reports.clear();
    }
    reports[nowStr] = FoodReport(calories: consumedSubstances[0], 
                                 proteins: consumedSubstances[1], 
                                 fats: consumedSubstances[2],
                                 carbohydrates: consumedSubstances[3], 
                                 caloriesNormal: kcalNormal, 
                                 proteinsNormal: proteinsNormal, 
                                 fatsNormal: fatsNormal, 
                                 carbohydratesNormal: carbsNormal);
  }
  Future<void> loadReportsFromJson() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('foodReports');
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      reports = jsonMap.map((key, value) => MapEntry(key, FoodReport.fromJson(value)));
      notifyListeners();
    }
  }

  void _resetDiaryData() {
    consumedCaloriesPerMeal[0] = 0.0;
    consumedCaloriesPerMeal[1] = 0.0;
    consumedCaloriesPerMeal[2] = 0.0;
    consumedSubstances[0] = 0.0;
    consumedSubstances[1] = 0.0;
    consumedSubstances[2] = 0.0;
    consumedSubstances[3] = 0.0;
  }

  void saveProfileDataToSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', user.name);
    prefs.setString('gender', user.gender);
    prefs.setInt('age', user.age);
    prefs.setDouble('weight', user.weight);
    prefs.setDouble('height', user.height);
  }

  Future<Person> readProfileDataFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    var name = prefs.getString('name');
    var gender = prefs.getString('gender');
    var age = prefs.getInt('age');
    var weight = prefs.getDouble('weight');
    var height = prefs.getDouble('height');
    if (name == null ||
        gender == null ||
        age == null ||
        weight == null ||
        height == null) {
      return Person.empty();
    } else {
      return Person(
          name: name, gender: gender, age: age, weight: weight, height: height);
    }
  }
  void updateSelectedFoods(List<Food> selectedFood, int mealIndex){
    selectedFoodList = selectedFood;
    allSelectedFood[mealIndex] = selectedFood;
  }
  void updateDiaryInformation(int mealIndex){
    if (selectedFoodList.isNotEmpty){
      consumedSubstances[0] = consumedSubstances[0] + selectedFoodList.fold(0, (sum, food) => sum + (food.calories / 100 * food.weight));
      consumedSubstances[1] = consumedSubstances[1] + selectedFoodList.fold(0, (sum, food) => sum + (food.proteins / 100 * food.weight));
      consumedSubstances[2] = consumedSubstances[2] + selectedFoodList.fold(0, (sum, food) => sum + (food.fats / 100 * food.weight));
      consumedSubstances[3] = consumedSubstances[3] + selectedFoodList.fold(0, (sum, food) => sum + (food.carbohydrates / 100 * food.weight));
      consumedCaloriesPerMeal[mealIndex] = selectedFoodList.fold(0, (sum, food) => sum + (food.calories / 100 * food.weight));
      saveDiaryDataToSharedPrefs();
      saveAllSelectedMeals();
      addOrReplaceReport();
      saveReportsToJson();
      notifyListeners();
    }
  }
  bool isMealFilled(String mealName){
    if (consumedCaloriesPerMeal[getMealIndex(mealName)] > 0){
      return true;
    }
    return false;
  }
  void calculateNorms() {
    if (user.gender == 'Мужчина') {
      kcalNormal = (66.5 +
              (13.75 * user.weight) +
              (5.003 * user.height) -
              (6.775 * user.age)) *
          1.375;
    } else {
      kcalNormal = (655.1 +
              (9.563 * user.weight) +
              (1.85 * user.height) -
              (4.676 * user.age)) *
          1.375;
    }
    proteinsNormal = kcalNormal * 0.3 / 4;
    fatsNormal = kcalNormal * 0.3 / 9;
    carbsNormal = kcalNormal * 0.4 / 4;
    mealNorms["Завтрак"] = kcalNormal * 0.25;
    mealNorms["Обед"] = kcalNormal * 0.4;
    mealNorms["Ужин"] = kcalNormal * 0.35;
    dailyNorms["Калории"] = kcalNormal;
    dailyNorms["Белки"] = proteinsNormal;
    dailyNorms["Жиры"] = fatsNormal;
    dailyNorms["Углеводы"] = carbsNormal;
  }
  int getMealIndex(String mealName){
    switch (mealName){
      case "Завтрак":
        return 0;
      case "Обед":
        return 1;
      case "Ужин":
        return 2;
    }
    return 0;
  }
  int getSubstanceIndex(String substanceName){
    switch (substanceName){
      case "Калории":
        return 0;
      case "Белки":
        return 1;
      case "Жиры":
        return 2;
      case "Углеводы":
        return 3;
    }
    return 0;
  }
  String convertMealsToJson(List<List<Food>> meals) {
    List<List<Map<String, dynamic>>> jsonMeals = meals
        .map((meal) => meal.map((food) => food.toJson()).toList())
        .toList();
    return jsonEncode(jsonMeals);
  }
  List<List<Food>> extractMealsFromJson(String jsonString) {
    List<dynamic> jsonMeals = jsonDecode(jsonString);
    return jsonMeals
        .map((meal) =>
            (meal as List<dynamic>).map((food) => Food.fromJson(food)).toList())
        .toList();
  }
  Future<void> saveAllSelectedMeals() async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = convertMealsToJson(allSelectedFood);
    await prefs.setString('allSelectedFood', jsonString);
  }
  Future<void> loadAllSelectedMeals() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('allSelectedFood');
    if (jsonString != null) {
      allSelectedFood = extractMealsFromJson(jsonString);
      notifyListeners();
    }
  }
  MainAppState() {
    _initializeProfile();
    readDiaryDataFromSharedPrefs();
    loadReportsFromJson();
    notifyListeners();
  }
  Future<void> _initializeProfile() async {
    user = await readProfileDataFromSharedPrefs();
    sendProfileDataToTextFields();
    calculateNorms();
    loadAllSelectedMeals();
    notifyListeners();
  }
}
