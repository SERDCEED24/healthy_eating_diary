import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
              SizedBox(height: 50,),
              StatusBars(),
              SizedBox(height: 50,),
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
            StatusRow(statusBarName: 'Калории'),
            SizedBox(height: 16.0,),
            StatusRow(statusBarName: 'Белки'),
            SizedBox(height: 16.0,),
            StatusRow(statusBarName: 'Жиры'),
            SizedBox(height: 16.0,),
            StatusRow(statusBarName: 'Углеводы'),
          ],
        ),
      ),
    );
  }
}

class StatusRow extends StatelessWidget {
  String statusBarName;

  StatusRow({
    super.key,
    required this.statusBarName
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$statusBarName:',
          style: const TextStyle(
                fontSize: 20,
              ),
        ),
        const Card(
          child: Card(child: SizedBox(),),
        )
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
        GenMeal(mealName: "Перекус"),
      ],
    );
  }
}

class GenMeal extends StatelessWidget {
  String mealName;
  GenMeal({
    super.key,
    required this.mealName
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              mealName,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const ElevatedButton(
              onPressed: null, 
              child: Icon(
                Icons.add
              )
            )
          ],
        ),
      ),
    );
  }
}

class Mascot extends StatelessWidget {
  const Mascot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          width: 250,
          height: 130,
          child: Card(
            child: Center(
              child: Text(
                'Совет дня: ешьте больше каши!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ),
        Image.asset(
          'assets/images/advice_c.png',
          scale: 3.0,
        ),
      ],
    );
  }
}