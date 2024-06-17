import 'package:flutter/material.dart';
import 'package:healthy_eating_diary/widgets/scaffold_with_panel.dart';
import 'package:provider/provider.dart';
import 'package:healthy_eating_diary/screens/registration_screen.dart';
import 'package:healthy_eating_diary/models/person.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainAppState(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.purple,
          ),
        title: 'Дневник здорового питания',
        home: Consumer<MainAppState>(
          builder: (context, mainAppState, child) {
            if (mainAppState.user.isEmpty()) {
              return const RegistrationScreen();
            } else {
              return const ScaffoldWithPanel();
            }
          },
        ),
      ),
    );
  }
}

class MainAppState extends ChangeNotifier{
  Person user = Person.empty();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController genderCtrl = TextEditingController();
  TextEditingController ageCtrl = TextEditingController();
  TextEditingController weightCtrl = TextEditingController();
  TextEditingController heightCtrl = TextEditingController();
  void saveProfileDataFromTextFields(){
    user.name = nameCtrl.text.trim() ;
    user.gender = genderCtrl.text.trim();
    user.age = int.parse(ageCtrl.text.trim());
    user.weight = double.parse(weightCtrl.text.trim());
    user.height = double.parse(heightCtrl.text.trim());
    saveProfileDataToSharedPrefs();
    notifyListeners();
  }
  void sendProfileDataToTextFields(){
    nameCtrl.text = user.name;
    genderCtrl.text = user.gender;
    ageCtrl.text = user.age.toString();
    weightCtrl.text = user.weight.toString();
    heightCtrl.text = user.height.toString();
    notifyListeners();
  }
  void saveProfileDataToSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', user.name);
    prefs.setString('gender', user.gender);
    prefs.setInt('age', user.age);
    prefs.setDouble('weight', user.weight);
    prefs.setDouble('height', user.height);
  }
  Future<Person> readProfileDataFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    var name = prefs.getString('name');
    var gender = prefs.getString('gender');
    var age = prefs.getInt('age');
    var weight = prefs.getDouble('weight');
    var height = prefs.getDouble('height');
    if (name == null || gender == null || age == null || weight == null || height == null){
      return Person.empty();
    }
    else{
      return Person(name: name, gender: gender, age: age, weight: weight, height: height);
    }
  }
  MainAppState() {
    readProfileDataFromSharedPrefs().then((userData) {
      user = userData;
      notifyListeners();
    });
    sendProfileDataToTextFields();
  }
}
