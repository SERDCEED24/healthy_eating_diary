import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthy_eating_diary/main.dart';
import 'package:healthy_eating_diary/widgets/scaffold_with_panel.dart';


class FillMealScreen extends StatelessWidget {
  FillMealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 243, 255),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('assets/images/editing.png', scale: 3,),
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

class ListOfDishes extends StatelessWidget {
  const ListOfDishes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Placeholder();
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ScaffoldWithPanel(),
              ),
            );
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