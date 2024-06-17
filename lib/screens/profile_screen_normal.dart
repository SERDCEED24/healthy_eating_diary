import 'package:flutter/material.dart';
import 'package:healthy_eating_diary/screens/profile_screen_edit.dart';
import 'package:provider/provider.dart';
import 'package:healthy_eating_diary/main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MainAppState>();
    return SafeArea(
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/images/profile.png', scale: 3,),
              const ProfileHeader(),
              const UserDataDisplay(),
              const EditProfileButton(),
            ],
          ),
        ),
      );
  }
}

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfile(),
            ),
          );
        },
        child: const Icon(
          Icons.edit,
          size: 30.0,
        ),
      ),
    );
  }
}

class UserDataDisplay extends StatelessWidget {
  const UserDataDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();
    var userData = appState.user;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Имя: ${userData.name}',
            style: const TextStyle(
              fontSize: 25,
            ),
          ),
          Text(
            'Пол: ${userData.gender}',
            style: const TextStyle(
              fontSize: 25,
            ),
          ),
          Text(
            'Возраст: ${userData.age}',
            style: const TextStyle(
              fontSize: 25,
            ),
          ),
          Text(
            'Вес: ${(userData.weight % 1 == 0) ? userData.weight.toStringAsFixed(0) : userData.weight.toString()} кг',
            style: const TextStyle(
              fontSize: 25,
            ),
          ),
          Text(
            'Рост: ${(userData.height % 1 == 0) ? userData.height.toStringAsFixed(0) : userData.height.toString()} см',
            style: const TextStyle(
              fontSize: 25,
            ),
          ),
        ]
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var screenName = "Профиль";
    var info = "Ваши данные:";
    return Column(
      children: [
        Text(
          screenName,
          style: const TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          info,
          style: const TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}