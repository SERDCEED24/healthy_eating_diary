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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              const Mascot(),
              SquarePainter(),
              const SizedBox(
                height: 30,
              ),
              const Meals()
            ],
          ),
        ),
      ),
    );
  }
}                                                                                                                                                                                                                                                                                                                                     

class SquarePainter extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    final mainAppState = context.watch<MainAppState>();
    final List<double> norm = [
      mainAppState.kcalNormal,
      mainAppState.proteinsNormal,
      mainAppState.fatsNormal,
      mainAppState.carbsNormal,
    ];

    final List<double> fact = mainAppState.consumedSubstances; 
    double squareSize = 10.0; // Фиксированный размер квадрата в пикселях
    EdgeInsetsGeometry padding = const EdgeInsets.only(top: 20, bottom: 25, left: 80, right: 80); // Задание отступов

    return Padding(
      padding: padding,
      child: Center(
        child: GridView.builder(
          padding: EdgeInsets.zero, // Обнуляем внутренние отступы у GridView
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 50.0,
            crossAxisSpacing: 35.0,
          ),
          shrinkWrap: true,
          itemCount: 4,
          itemBuilder: (context, index) {
            String text;
            switch (index) {
              case 0:
                text = 'К (${fact[0].round()})';
                break;
              case 1:
                text = 'Б (${fact[1].round()})';
                break;
              case 2:
                text = 'Ж (${fact[2].round()})';
                break;
              case 3:
                text = 'У (${fact[3].round()})';
                break;
              default:
                text = '';
            }
            return Container(
              height: 10,
              width: 10, // Отступы вокруг каждого квадрата
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: CustomPaint(
                size: const Size(10, 10),
                painter: MyPainter(norm: norm[index], fact: fact[index], text: text),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final double norm;
  final double fact;
  final String text;

  MyPainter({required this.norm, required this.fact, required this.text});

  @override
  void paint(Canvas canvas, Size size) {
    double percentage = (fact / norm) * 100;
    double fillHeight = size.height * (percentage / 100);

    // Ограничим fillHeight размером квадрата
    double cappedFillHeight = fillHeight.clamp(0, size.height);
    double overflowHeight = fillHeight > size.height ? fillHeight - size.height : 0;

    Paint paint = Paint()..color = const Color.fromARGB(255, 215, 158, 224);

    // Отрисовка заполненной области
    canvas.drawRect(
      Rect.fromLTWH(0, size.height - cappedFillHeight, size.width, cappedFillHeight),
      paint,
    );

    // Отрисовка overflow
    if (overflowHeight > 0) {
      canvas.drawRect(
        Rect.fromLTWH(0, -10, size.width, 10),
        paint,
      );
    }

    Paint borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Отрисовка рамки квадрата
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, borderPaint);

    // Отрисовка буквы "К" в центре квадрата
    TextSpan span = TextSpan(
      style: TextStyle(color: Colors.black, fontSize: size.width / 5), // Динамически устанавливаем размер шрифта
      text: text,
    );

    TextPainter textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: size.width);
    Offset textOffset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    textPainter.paint(canvas, textOffset);

    // Отрисовка текста под квадратом
    TextSpan spanBelow = TextSpan(
      style: TextStyle(color: Colors.black, fontSize: size.width / 6), // Динамически устанавливаем размер шрифта
      text: '${norm.round()}',
    );

    TextPainter textPainterBelow = TextPainter(
      text: spanBelow,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainterBelow.layout(minWidth: 0, maxWidth: size.width);
    Offset textOffsetBelow = Offset(
      (size.width - textPainterBelow.width) / 2,
      size.height + 10, // Располагаем текст под квадратом с отступом
    );

    textPainterBelow.paint(canvas, textOffsetBelow);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is MyPainter) {
      return norm != oldDelegate.norm || fact != oldDelegate.fact || text != oldDelegate.text;
    }
    return true;
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
        const SizedBox(height: 10,),
        GenMeal(mealName: "Обед"),
        const SizedBox(height: 10,),
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
    return SizedBox(
      height: 70,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: mealName,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: "\nФакт: ${appState.consumedCaloriesPerMeal[appState.getMealIndex(mealName)].round()} ккал.  Цель: ${appState.mealNorms[mealName].round()} ккал.",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              ),
              appState.isMealFilled(mealName) ? CheckMealButton(mealName: mealName,) : AddFoodButton(mealName: mealName) 
            ],
          ),
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
        child: const Icon(Icons.chevron_right));
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
          width: 220,
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
