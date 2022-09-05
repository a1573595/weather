part of 'detail_page.dart';

class _WeekWeather extends StatelessWidget {
  const _WeekWeather(this.daily, {Key? key}) : super(key: key);

  final List<Daily> daily;

  @override
  Widget build(BuildContext context) {
    /// 計算氣溫最大與最小值
    /// 用於計算氣溫條比例
    var maxValue = daily.map((e) => e.temp.day).reduce(max).toInt();
    var minValue = daily.map((e) => e.temp.day).reduce(min).toInt();
    var len = maxValue - minValue;

    return Column(
      children: daily
          .map((value) => _buildWeather(
              minValue,
              len,
              DateTime.fromMillisecondsSinceEpoch(value.dt * 1000),
              value.weathers[0].main,
              value.weathers[0].icon,
              value.temp.day.toInt()))
          .toList(),
    );
  }

  Widget _buildWeather(int minValue, int len, DateTime date, String main,
      String icon, int temp) {
    var width = ScreenUtil().screenWidth / 4;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        children: [
          SizedBox(width: 40.r, child: Text(DateFormat('EEE').format(date))),
          CachedNetworkImage(
            height: 40.r,
            width: 40.r,
            imageUrl: '${ImageUtil.openWeatherImageUrlPrefix}$icon.png',
            placeholder: (context, url) => const SizedBox(),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error_outline),
          ),
          SizedBox(width: 16.r),
          Container(
            height: 4.r,
            width: width + width * (temp - minValue) / len,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange,
                Colors.white,
              ],
            )),
          ),
          SizedBox(width: 16.r),
          Text('${temp.toStringAsFixed(0)}°'),
        ],
      ),
    );
  }
}
