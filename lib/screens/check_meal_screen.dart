import 'package:flutter/material.dart';
import 'package:healthy_eating_diary/models/food.dart';
import 'package:provider/provider.dart';
import 'package:healthy_eating_diary/main.dart';

class CheckMealScreen extends StatelessWidget {
  final String mealName;
  const CheckMealScreen({super.key, required this.mealName});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();
    var foodList = appState.allSelectedFood[appState.getMealIndex(mealName)];
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
                MealHeader(mealName: mealName),
                ListOfSelectedDishes(foodList: foodList,),
                const FinishCheckingButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListOfSelectedDishes extends StatelessWidget {
  final List<Food> foodList;
  final ScrollController _scrollController = ScrollController();

  ListOfSelectedDishes({Key? key, required this.foodList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return foodList.isEmpty
        ? const Center(child: Text('Еды нет'))
        : SizedBox(
            width: 500,
            height: 400,
            child: Scrollbar(
              thickness: 12.0,
              thumbVisibility: true, 
              controller: _scrollController,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: foodList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(foodList[index].toString()),
                  );
                },
              ),
            ),
          );
  }
}
class MealHeader extends StatelessWidget {
  String mealName;
  MealHeader({
    super.key,
    required this.mealName
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "$mealName:",
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class FinishCheckingButton extends StatelessWidget {
  const FinishCheckingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: ElevatedButton(
        onPressed: () {
          if (true) {
            Navigator.pop(context);
          }
        },
        child: const Icon(
          Icons.arrow_back,
          size: 30.0,
        ),
      ),
    );
  }
}