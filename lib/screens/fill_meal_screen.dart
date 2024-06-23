import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:healthy_eating_diary/models/food.dart';
import 'package:provider/provider.dart';
import 'package:healthy_eating_diary/main.dart';

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
  List<Food> foodList= [];
  List<Food> selectedFoodList = [];
  List<Food> displayedFoodList = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFoodList();
  }

  Future<void> _loadFoodList() async {
    var input = await rootBundle.loadString('assets/food_db.json');
    var json = jsonDecode(input) as List<dynamic>;
    List<Food> loadedFoodList = json.map((dynamic e) => Food.fromJson(e as Map<String, dynamic>)).toList();

    setState(() {
      foodList = loadedFoodList;
      displayedFoodList = loadedFoodList;
    });
  }

  void _toggleSelection(Food food) {
    if (!selectedFoodList.contains(food)) {
      setState(() {
        selectedFoodList.add(food);
      });
    } else {
      setState(() {
        selectedFoodList.remove(food);
      });
    }
  }

  void _incrementWeight(Food food) {
    setState(() {
      food.weight += 10;
    });
  }

  void _decrementWeight(Food food) {
    if (food.weight > 50) { 
      setState(() {
        food.weight -= 10;
      });
    }
  }

  void _performSearch(String query) {
    List<Food> results = [];

    if (query.isEmpty) {
      results = foodList;
    } else {
      results = foodList.where((food) => food.name.toLowerCase().contains(query.toLowerCase())).toList();
    }

    setState(() {
      displayedFoodList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return foodList.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  onChanged: _performSearch,
                  decoration: InputDecoration(
                    labelText: 'Поиск блюд',
                    hintText: 'Введите название блюда',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        _performSearch('');
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 500,
                height:400,
                child: ListView.builder(
                  itemCount: displayedFoodList.length,
                  itemBuilder: (context, index) {
                    Food food = displayedFoodList[index];
                    bool isSelected = selectedFoodList.contains(food);
                
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(food.toString(), softWrap: true,)
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  _decrementWeight(food);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  _incrementWeight(food);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          _toggleSelection(food);
                        },
                      ),
                      onTap: () {
                        _toggleSelection(food);
                      },
                    );
                  },
                ),
              ),
            ],
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
