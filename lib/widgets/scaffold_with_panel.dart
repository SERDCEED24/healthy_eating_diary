import 'package:flutter/material.dart';
import 'package:healthy_eating_diary/screens/charts_screen.dart';
import 'package:healthy_eating_diary/screens/diary_screen.dart';
import 'package:healthy_eating_diary/screens/profile_screen_normal.dart';
import 'package:healthy_eating_diary/screens/user_guide_screen.dart';

class ScaffoldWithPanel extends StatefulWidget {
  const ScaffoldWithPanel({super.key});

  @override
  State<ScaffoldWithPanel> createState() => _ScaffoldWithPanelState();
}

class _ScaffoldWithPanelState extends State<ScaffoldWithPanel> {
  int currentPageIndex = 0;
  final routes = [const ProfileScreen(), const DiaryScreen(), const ChartsScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 243, 255),
        bottomNavigationBar: NavigationBar(
          destinations: const[
            NavigationDestination(
              icon: Icon(Icons.person), 
              label: "Профиль"
            ),
            NavigationDestination(
              icon: Icon(Icons.book), 
              label: "Дневник"
            ),
            NavigationDestination(
              icon: Icon(Icons.multiline_chart), 
              label: "Графики"
            )
          ],
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          } ,
        ),
        body: Stack(
        children: [
          routes[currentPageIndex],
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserGuideScreen(),
                    ),
                  );
                },
                child: const Icon(Icons.question_mark),
              ),
            ),
          ),
        ],
      ),
    );
  }
}