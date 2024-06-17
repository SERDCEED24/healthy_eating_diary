import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthy_eating_diary/main.dart';
import 'package:healthy_eating_diary/screens/registration_screen.dart';
import 'package:healthy_eating_diary/widgets/scaffold_with_panel.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                  const EditHeader(),
                  Forms(formKey: _formKey),
                  FinishEditingButton(formKey: _formKey),
                ],
              ),
            ),
          ),
        ),
    );
  }
}

class EditHeader extends StatelessWidget {
  const EditHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var prompt = "Отредактируйте свои данные:";
    return Text(
      prompt,
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class FinishEditingButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const FinishEditingButton({required this.formKey});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();
    return SizedBox(
      width: 90,
      height: 90,
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
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