import 'package:assesment/YearlyData.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChartScreen extends ConsumerWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartDataAsyncValue = ref.watch(chartDataProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Chart Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(100),
        child: Column(
          children: [
            Flexible(
              child: chartDataAsyncValue.when(
                data: (chartData) => LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: chartData.length - 1.toDouble(),
                    minY: 0,
                    maxY: chartData
                        .map((e) => e.cumulative)
                        .reduce((a, b) => a > b ? a : b),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          interval: 1,
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            return Text(chartData[index].year);
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1000000,
                          getTitlesWidget: (value, meta) {
                            return SizedBox(
                                child: Text(
                                    '${(value / 1000000).toStringAsFixed(0)}M'));
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: chartData
                            .asMap()
                            .entries
                            .map((e) =>
                                FlSpot(e.key.toDouble(), e.value.deployment))
                            .toList(),
                        isCurved: true,
                        barWidth: 2,
                      ),
                    ],
                  ),
                ),
                loading: () => CircularProgressIndicator(),
                error: (error, stackTrace) => Text('Error: $error'),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              onPressed: () => context.go('/'),
              child: Text("Home page"),
            ),
          ],
        ),
      ),
    );
  }
}
