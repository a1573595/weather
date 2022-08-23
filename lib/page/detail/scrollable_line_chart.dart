part of 'detail_page.dart';

class _ScrollAbleLineChart extends StatelessWidget {
  const _ScrollAbleLineChart(this.hourly, {Key? key}) : super(key: key);

  final List<Hourly> hourly;

  /// 圖表配置資料
  LineChartData get chartData => LineChartData(
        /// 圖表資料
        lineBarsData: [lineChartBarData],

        /// 圖表指標文字範圍
        showingTooltipIndicators: hourly.mapIndexed((index, value) {
          return ShowingTooltipIndicators([
            LineBarSpot(lineChartBarData, index, lineChartBarData.spots[index]),
          ]);
        }).toList(),

        /// 圖表指標圖示/文字
        lineTouchData: lineTouchData,

        /// 圖表網格
        gridData: FlGridData(show: false),

        /// 圖表刻度
        titlesData: titlesData,

        /// 圖表邊界
        borderData: borderData,

        /// X軸範圍
        minX: 0,
        maxX: 23,

        /// Y軸範圍
        minY: hourly.map((e) => e.temp).reduce(min).toInt() - 10,
        maxY: hourly.map((e) => e.temp).reduce(max).toInt() + 5,
      );

  /// 圖表邊界
  FlBorderData get borderData => FlBorderData(
        show: false,
        // border: const Border(
        //   bottom: BorderSide(width: 2),
        // ),
      );

  /// 圖表刻度
  FlTitlesData get titlesData => FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
      );

  /// 圖表底部時間刻度
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var date =
        DateTime.fromMillisecondsSinceEpoch(hourly[value.toInt()].dt * 1000);
    Widget text = Text(DateFormat("HH:00").format(date));

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  /// 圖表資料
  LineChartBarData get lineChartBarData => LineChartBarData(

      /// 圖表指標範圍
      showingIndicators: hourly.mapIndexed((i, e) => i).toList(),
      isCurved: true,
      color: Colors.pinkAccent.shade100,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            Colors.pinkAccent.shade200,
            Colors.pinkAccent.shade100,
            Colors.white
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      // gradient: const LinearGradient(
      //   colors: [
      //     Color(0xff12c2e9),
      //     Color(0xffc471ed),
      //     Color(0xfff64f59),
      //   ],
      //   stops: [0.1, 0.4, 0.9],
      //   begin: Alignment.centerLeft,
      //   end: Alignment.centerRight,
      // ),
      spots: hourly
          .mapIndexed((index, value) =>
              FlSpot(index.toDouble(), value.temp.toInt().toDouble()))
          .toList());

  /// 圖表指標圖示/文字
  LineTouchData get lineTouchData => LineTouchData(
        enabled: false,
        /// 圖表指標圖示
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              FlLine(color: Colors.white, dashArray: [3, 5]),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 4,
                  strokeColor: Colors.pinkAccent.shade200,
                ),
              ),
            );
          }).toList();
        },

        /// 圖表指標文字
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
            return lineBarsSpot.map((lineBarSpot) {
              return LineTooltipItem(
                "${lineBarSpot.y.toStringAsFixed(0)}°",
                const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              );
            }).toList();
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          const SizedBox(
            width: 24,
          ),
          SizedBox(
            width: 1200,
            height: 300,
            child: LineChart(
              chartData,
              swapAnimationDuration: const Duration(milliseconds: 500),
            ),
          ),
          const SizedBox(
            width: 24,
          ),
        ],
      ),
    );
  }
}
