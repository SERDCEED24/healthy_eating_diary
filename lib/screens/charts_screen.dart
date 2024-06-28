import 'package:flutter/material.dart';
import 'package:healthy_eating_diary/main.dart';
import 'package:healthy_eating_diary/screens/diary_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

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
                height: 8,
              ),
              ChartHeader(),
              Charts(),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartHeader extends StatelessWidget {
  const ChartHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();
    var headers = ["Калории", "Белки", "Жиры", "Углеводы"];
    return Text(
            headers[appState.chartSubstanceIndex],
            style: const TextStyle(
               fontSize: 22,
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
    var appState = context.watch<MainAppState>();
    return Column(
      children: [
        OneChart(real: appState.chartPointsReal, norm: appState.chartPointsNorm, substanceIndex: appState.chartSubstanceIndex,),
        const ChartsButtons(),
      ],
    );
  }
}

class OneChart extends StatelessWidget {
  final List<double> real;
  final List<double> norm;
  final int substanceIndex;

  const OneChart({super.key, required this.real, required this.norm, required this.substanceIndex});

  @override
  Widget build(BuildContext context) {
    double maxYValue = 3000;

    switch (substanceIndex) {
      case 1:
        maxYValue = maxYValue * 0.075;
        break;
      case 2:
        maxYValue = maxYValue * 0.03;
        break;
      case 3:
        maxYValue = maxYValue * 0.1;
        break;
    }

    maxYValue = _calculateMaxYValue(real, norm, maxYValue);
    double stepSize = maxYValue / 12;

    return SizedBox(
      height: 400,
      child: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.7,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceEvenly,
                  maxY: maxYValue + (maxYValue * 0.05), 
                  minY: 0,
                  barGroups: _createBarGroups(),
                  titlesData: _buildTitlesData(stepSize),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,  
                    drawHorizontalLine: true, 
                    horizontalInterval: stepSize,
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(
                        color: Colors.grey,
                        strokeWidth: 1,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.deepPurple[100], 'Норма'),
                const SizedBox(width: 20),
                _buildLegendItem(Colors.deepPurpleAccent, 'Реальность'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateMaxYValue(List<double> real, List<double> norm, double maxYValue) {
    double maxReal = real.isNotEmpty ? real.reduce((a, b) => a > b ? a : b) : 0;
    double maxNorm = norm.isNotEmpty ? norm.reduce((a, b) => a > b ? a : b) : 0;
    double calculatedMax = (maxReal > maxNorm ? maxReal : maxNorm) * 1.2;

    return calculatedMax > 0 ? calculatedMax : maxYValue;
  }

  List<BarChartGroupData> _createBarGroups() {
    return List.generate(real.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: norm[index],
            color: Colors.deepPurple[100],
            width: 15,
          ),
          BarChartRodData(
            toY: real[index],
            color: Colors.deepPurpleAccent,
            width: 15,
          ),
        ],
        barsSpace: 5,
      );
    });
  }

  FlTitlesData _buildTitlesData(double stepSize) {
    stepSize = stepSize > 0 ? stepSize : 1;

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
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,  
          reservedSize: 40,
          interval: stepSize,
          getTitlesWidget: (value, meta) {
            return Text(value.toStringAsFixed(0));
          },
        ),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,  
        ),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(
          showTitles: false
        )
      )
      
    );
  }

  Widget _buildLegendItem(Color? color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}




class ChartsButtons extends StatelessWidget {
  const ChartsButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();
    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => {appState.changeChartValues(0)},
                child: const Text(
                  'К',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () => {appState.changeChartValues(1)},
                child: const Text(
                  'Б',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () => {appState.changeChartValues(2)},
                child: const Text(
                  'Ж',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () => {appState.changeChartValues(3)},
                child: const Text(
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
    var appState = context.watch<MainAppState>();
    var perc = appState.percDiff.round();
    String lastWords =  'выполнена на $perc%!';
    if (perc > 100){
      lastWords = 'перевыполнена на ${perc - 100}%.';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 220,
          height: 160,
          child: Card(
            child: Center(
              child: Text(
                'Норма по ${["калориям", "белкам", "жирам", "углеводам"][appState.chartSubstanceIndex]} $lastWords',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ),
        Image.asset(
          'assets/images/advice.png',
          scale: 3.0,
        ),
      ],
    );
  }
}