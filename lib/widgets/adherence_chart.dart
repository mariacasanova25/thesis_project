import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:thesis_project/models/prescription.dart';

class AdherenceScatterChart extends StatelessWidget {
  final Prescription data;

  const AdherenceScatterChart({super.key, required this.data});

  List<DateTime> generateDaysList() {
    List<DateTime> days = [];
    DateTime date = data.startDate;

    days.add(date);
    while (date.isBefore(DateTime.now())) {
      date = date.add(const Duration(days: 1));
      date = DateTime(date.year, date.month, date.day);
      if (date.isAtSameMomentAs(DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)) ||
          date.isBefore(DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
        days.add(date);
      }
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> daysList = generateDaysList();
    return SizedBox(
      width: 300,
      height: 200,
      child: ScatterChart(
        ScatterChartData(
          scatterSpots: _createScatterSpots(),
          minX: 0,
          maxX: daysList.length.toDouble(),
          minY: 0,
          maxY: 100,
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(color: Colors.black, width: 1),
              bottom: BorderSide(color: Colors.black, width: 1),
              right: BorderSide.none,
              top: BorderSide.none,
            ),
          ),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  );
                  int index = value.toInt() - 1;
                  if (index >= 0 && index < daysList.length) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 4.0,
                      child: Text(
                        '${daysList[index].day}/${daysList[index].month}',
                        style: style,
                      ),
                    );
                  } else {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 4.0,
                      child: const Text(''),
                    );
                  }
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          scatterTouchData: ScatterTouchData(
            enabled: true,
            handleBuiltInTouches: true,
          ),
        ),
      ),
    );
  }

  List<ScatterSpot> _createScatterSpots() {
    List<ScatterSpot> scatterSpots = [];
    List<DateTime> daysList = generateDaysList();
    for (int i = 0; i < daysList.length; i++) {
      double adherenceValue = data.getAdherence(daysList[i]);
      // print("CHART ${data.getAdherence(daysList[i])} ${daysList[i]}");

      scatterSpots.add(
        ScatterSpot(i + 1, adherenceValue),
      );
    }
    return scatterSpots;
  }
}
