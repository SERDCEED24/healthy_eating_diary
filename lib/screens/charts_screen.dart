import 'package:flutter/material.dart';
import 'package:healthy_eating_diary/screens/diary_screen.dart';
import 'package:fl_chart/fl_chart.dart';

//import 'package:provider/provider.dart';
//import 'package:healthy_eating_diary/main.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              MascotForCharts(),
              SizedBox(
                height: 50,
              ),
              Charts(),
            ],
          ),
        ),
      ),
    );
  }
}

class Charts extends StatelessWidget {
  const Charts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OneChart(),
        const ChartsButtons(),
      ],
    );
  }
}

class OneChart extends StatelessWidget {
  final List<double> realCalories = [2000, 1800, 2200, 2100, 2500, 2400, 2300];
  final List<double> normCalories = [2000, 2000, 2000, 2000, 2000, 2000, 2000];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          maxY: 3000,
          minY: 0,
          barGroups: _createBarGroups(),
          titlesData: _buildTitlesData(),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          ),
        ),
      );
  }

  List<BarChartGroupData> _createBarGroups() {
    return List.generate(realCalories.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: normCalories[index],
            color: Colors.deepPurple[100],
            width: 15,
          ),
          BarChartRodData(
            toY: realCalories[index],
            color: Colors.deepPurpleAccent,
            width: 15,
          ),
        ],
        barsSpace: 5,
      );
    });
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            switch (value.toInt()) {
              case 0:
                return const Text('Пн');
              case 1:
                return const Text('Вт');
              case 2:
                return const Text('Ср');
              case 3:
                return const Text('Чт');
              case 4:
                return const Text('Пт');
              case 5:
                return const Text('Сб');
              case 6:
                return const Text('Вс');
              default:
                return const Text('');
            }
          },
          reservedSize: 40,
        ),
      ),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
        ),
      ),
    );
  }
}

class ChartsButtons extends StatelessWidget {
  const ChartsButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: null,
                child: Text(
                  'К',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: null,
                child: Text(
                  'Б',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: null,
                child: Text(
                  'Ж',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: null,
                child: Text(
                  'У',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
  }
}

class MascotForCharts extends StatelessWidget {
  const MascotForCharts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          width: 220,
          height: 130,
          child: Card(
            child: Center(
              child: Text(
                'Норма по калориям выполнена на 84%!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
        Image.asset(
          'assets/images/happy.png',
          scale: 3.0,
        ),
      ],
    );
  }
}