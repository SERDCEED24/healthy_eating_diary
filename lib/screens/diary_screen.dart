import 'package:flutter/material.dart';
import 'package:healthy_eating_diary/main.dart';
import 'package:healthy_eating_diary/screens/check_meal_screen.dart';
import 'package:healthy_eating_diary/screens/fill_meal_screen.dart';
import 'package:provider/provider.dart';
import 'package:healthy_eating_diary/widgets/message.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Mascot(),
              SizedBox(
                height: 50,
              ),
              StatusBars(),
              SizedBox(
                height: 50,
              ),
              Meals()
            ],
          ),
        ),
      ),
    );
  }
}

class StatusBars extends StatelessWidget {
  const StatusBars({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            StatusRow(statusBarName: "Калории"),
            const SizedBox(
              height: 16.0,
            ),
            StatusRow(statusBarName: "Белки"),
            const SizedBox(
              height: 16.0,
            ),
            StatusRow(statusBarName: "Жиры"),
            const SizedBox(
              height: 16.0,
            ),
            StatusRow(statusBarName: "Углеводы"),
          ],
        ),
      ),
    );
  }
}

class StatusRow extends StatelessWidget {
  String statusBarName;

  StatusRow({super.key, required this.statusBarName});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();
    return Row(
      children: [
        Text(
          '$statusBarName:',
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        Text(
          '   ${appState.consumedSubstances[appState.getSubstanceIndex(statusBarName)].round()}/${appState.dailyNorms[statusBarName].round()}',
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

class Meals extends StatelessWidget {
  const Meals({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GenMeal(mealName: "Завтрак"),
        GenMeal(mealName: "Обед"),
        GenMeal(mealName: "Ужин"),
      ],
    );
  }
}

class GenMeal extends StatelessWidget {
  String mealName;
  GenMeal({super.key, required this.mealName});
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$mealName    ${appState.consumedCaloriesPerMeal[appState.getMealIndex(mealName)].round()}/${appState.mealNorms[mealName].round()}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            appState.isMealFilled(mealName) ? CheckMealButton(mealName: mealName,) : AddFoodButton(mealName: mealName) 
          ],
        ),
      ),
    );
  }
}

class AddFoodButton extends StatelessWidget {
  const AddFoodButton({
    super.key,
    required this.mealName,
  });

  final String mealName;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FillMealScreen(mealIndex: appState.getMealIndex(mealName)),
            ),
          );
        },
        child: const Icon(Icons.add));
  }
}

class CheckMealButton extends StatelessWidget {
  const CheckMealButton({
    super.key,
    required this.mealName,
  });

  final String mealName;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckMealScreen(mealName: mealName),
            ),
          );
        },
        child: const Icon(Icons.check));
  }
}

class Mascot extends StatelessWidget {
  const Mascot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();
    var message = Message(appState);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 245,
          height: 180,
          child: Card(
            child: Center(
              child: Text(
                message.createMessage(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        Image.asset(
          message.photo(),
          scale: 3.0,
        ),
      ],
    );
  }
}
