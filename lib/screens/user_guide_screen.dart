import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 243, 255),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //MealHeader(mealName: mealName),
                  PDF(),
                  BackFromGuideButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PDF extends StatefulWidget {
  const PDF({
    super.key,
  });

  @override
  State<PDF> createState() => _PDFState();
}

class _PDFState extends State<PDF> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 800,
      width: 500,
      child: SfPdfViewer.asset(
        'assets/user_guide.pdf'
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

class BackFromGuideButton extends StatelessWidget {
  const BackFromGuideButton({super.key});

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