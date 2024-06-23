import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:healthy_eating_diary/models/food.dart';
import 'package:provider/provider.dart';
import 'package:healthy_eating_diary/main.dart';
import 'package:healthy_eating_diary/widgets/scaffold_with_panel.dart';

class FillMealScreen extends StatelessWidget {
  const FillMealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 243, 255),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/editing.png',
                  scale: 3,
                ),
                const SelectionHeader(),
                const ListOfDishes(),
                const FinishSelectingButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListOfDishes extends StatefulWidget {
  const ListOfDishes({
    super.key,
  });

  @override
  State<ListOfDishes> createState() => _ListOfDishesState();
}

class _ListOfDishesState extends State<ListOfDishes> {
  Future<List<Food>> readJsonFile() async {
    var input = await rootBundle.loadString('assets/food_db.json');
    var json = jsonDecode(input) as List<dynamic>;
    return json
        .map((dynamic e) => Food.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<Food> foodList = [];
  List<Food> selectedFoodList = [];

  @override
  void initState() {
    super.initState();
    _loadFoodList();
  }

  Future<void> _loadFoodList() async {
    List<Food> loadedFoodList = await readJsonFile();
    setState(() {
      foodList = loadedFoodList;
    });
  }

  void _toggleSelection(Food food) {
    if (!selectedFoodList.contains(food)) {
      setState(() {
        foodList.add(food);
      });
    } else {
      setState(() {
        foodList.remove(food);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return foodList.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
          width: 500,
          height: 500,
          child: ListView.builder(
              itemCount: foodList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(foodList[index].toString()),
                  trailing: Checkbox(
                    value: selectedFoodList.contains(foodList[index]),
                    onChanged: (bool? value) {
                      _toggleSelection(foodList[index]);
                    },
                  ),
                  onTap: () {
                    _toggleSelection(foodList[index]);
                  },
                );
              },
            ),
        );
  }
}

class SelectionHeader extends StatelessWidget {
  const SelectionHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var prompt = "Выберите блюда из списка:";
    return Text(
      prompt,
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class FinishSelectingButton extends StatelessWidget {
  const FinishSelectingButton({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();
    return SizedBox(
      width: 90,
      height: 90,
      child: ElevatedButton(
        onPressed: () {
          if (true) {
            appState.saveProfileDataFromTextFields();
            Navigator.pop(context);
          }
        },
        child: const Icon(
          Icons.check,
          size: 30.0,
        ),
      ),
    );
  }
}
