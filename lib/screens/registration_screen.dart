import 'package:flutter/material.dart';
import 'package:healthy_eating_diary/widgets/scaffold_with_panel.dart';
import 'package:provider/provider.dart';
import 'package:healthy_eating_diary/main.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 243, 255),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('assets/images/greeting.png', scale: 3,),
                  const RegHeader(),
                  Forms(formKey: _formKey),
                  NextButton(formKey: _formKey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const NextButton({required this.formKey});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();
    return SizedBox(
      width: 90,
      height: 90,
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            appState.saveProfileDataFromTextFields;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ScaffoldWithPanel(),
              ),
            );
          }
        },
        child: const Icon(
          Icons.arrow_forward_rounded,
          size: 30.0,
        ),
      ),
    );
  }
}

class RegHeader extends StatelessWidget {
  const RegHeader({Key? key});

  @override
  Widget build(BuildContext context) {
    var greeting = "Приветствуем!";
    var prompt = "Для продолжения введите свои данные:";
    return Column(
      children: [
        Text(
          greeting,
          style: const TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          prompt,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class Forms extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const Forms({Key? key, required this.formKey});

  @override
  State<Forms> createState() => _FormsState();
}

class _FormsState extends State<Forms> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          GenTextField(
            helpText: 'Имя',
            ctrl: appState.nameCtrl,
            val: (value) {
              if (value == null || value.isEmpty) {
                return 'Ошибка! Введите имя!';
              }
              return null;
            },
          ),
          GenTextField(
            helpText: 'Пол',
            ctrl: appState.genderCtrl,
            val: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !(value.trim() == 'Мужчина' || value.trim()  == 'Женщина')) {
                return 'Ошибка! Введите "Мужчина" или "Женщина"!';
              }
              return null;
            },
          ),
          GenTextField(
            helpText: 'Возраст',
            ctrl: appState.ageCtrl,
            val: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите возраст';
              }
              int? age = int.tryParse(value);
              if (age == null || age <= 0 || age > 150) {
                return 'Введите корректный возраст';
              }
              return null;
            },
          ),
          GenTextField(
            helpText: 'Вес (кг)',
            ctrl: appState.weightCtrl,
            val: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите вес';
              }
              double? weight = double.tryParse(value);
              if (weight == null || weight <= 0 || weight > 1000) {
                return 'Введите корректный вес';
              }
              return null;
            },
          ),
          GenTextField(
            helpText: 'Рост (см)',
            ctrl: appState.heightCtrl,
            val: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите рост';
              }
              double? height = double.tryParse(value);
              if (height == null || height <= 0 || height > 300) {
                return 'Введите корректный рост';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

class GenTextField extends StatefulWidget {
  final String helpText;
  final String? Function(String?)? val;
  final TextEditingController ctrl;

  const GenTextField({
    Key? key,
    required this.helpText,
    required this.ctrl,
    required this.val,
  }) : super(key: key);

  @override
  State<GenTextField> createState() => _GenTextFieldState();
}

class _GenTextFieldState extends State<GenTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.helpText,
        ),
        controller: widget.ctrl,
        validator: widget.val,
      ),
    );
  }
}
