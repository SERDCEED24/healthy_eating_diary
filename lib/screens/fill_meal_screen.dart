import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:healthy_eating_diary/models/food.dart';
import 'package:provider/provider.dart';
import 'package:healthy_eating_diary/main.dart';

class FillMealScreen extends StatelessWidget {
  final int mealIndex;
  const FillMealScreen({super.key, required this.mealIndex});
  
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
                ListOfDishes(mealIndex: mealIndex,),
                FillingSummary(mealIndex: mealIndex,),
                FinishSelectingButton(mealIndex: mealIndex,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FillingSummary extends StatelessWidget {
  final int mealIndex;

  const FillingSummary({
    super.key,
    required this.mealIndex,
  });

  @override
  Widget build(BuildContext context) {
    var mealNames = ["Завтрак", "Обед", "Ужин"];
    var appState = context.watch<MainAppState>();
    var substanceList = appState.getKbzhuList();
    var calNorm = appState.mealNorms[mealNames[mealIndex]];
    var norms = [calNorm, calNorm * 0.3 / 4, calNorm * 0.3 / 9, calNorm * 0.4 / 4];
    return Column(
      children: [
        Text(
          'Выбрано КБЖУ: ${substanceList[0].round()}, ${substanceList[1].round()}, ${substanceList[2].round()}, ${substanceList[3].round()}',
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          'Норма КБЖУ для ${["завтрака", "обеда", "ужина"][mealIndex]}: ${norms[0].round()}, ${norms[1].round()}, ${norms[2].round()}, ${norms[3].round()}',
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}

class ListOfDishes extends StatefulWidget {
  final int mealIndex;
  const ListOfDishes({
    super.key,
    required this.mealIndex
  });

  @override
  State<ListOfDishes> createState() => _ListOfDishesState();
}

class _ListOfDishesState extends State<ListOfDishes> {
  List<Food> foodList = [];
  List<Food> selectedFoodList = [];
  List<Food> displayedFoodList = [];

  TextEditingController searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadFoodList();
  }

  Future<void> _loadFoodList() async {
    var input = await rootBundle.loadString('assets/food_db.json');
    var json = jsonDecode(input) as List<dynamic>;
    List<Food> loadedFoodList =
        json.map((dynamic e) => Food.fromJson(e as Map<String, dynamic>)).toList();

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
    context.read<MainAppState>().updateSelectedFoods(selectedFoodList, widget.mealIndex);
  }

  void _toggleSelectionOn(Food food) {
    if (!selectedFoodList.contains(food)) {
      setState(() {
        selectedFoodList.add(food);
      });
    } else {
      selectedFoodList.removeWhere((item) => item.name == food.name);
      selectedFoodList.add(food);
    }
    context.read<MainAppState>().updateSelectedFoods(selectedFoodList, widget.mealIndex);
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
                height: 380,
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  thickness: 12,
                  child: ListView.builder(
                    controller: _scrollController,
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
                              child: Text(
                                food.toString(),
                                softWrap: true,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    _toggleSelectionOn(food);
                                    _decrementWeight(food);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    _toggleSelectionOn(food);
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
  final int mealIndex;
  const FinishSelectingButton({super.key, required this.mealIndex});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();
    return SizedBox(
      width: 90,
      height: 90,
      child: ElevatedButton(
        onPressed: () {
          if (true) {
            appState.updateDiaryInformation(mealIndex);
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
