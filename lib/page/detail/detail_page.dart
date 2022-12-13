import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather/model/daily.dart';
import 'package:weather/model/hourly.dart';
import 'package:weather/model/one_call.dart';
import 'package:weather/repository/WeatherRepository.dart';
import 'package:weather/utils/edge_util.dart';
import 'package:weather/utils/helper.dart';
import 'package:weather/utils/image_util.dart';

part 'detail_view_model.dart';

part 'line_chart.dart';

part 'scrollable_line_chart.dart';

part 'week_weather.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(_oneCallProvider).when(
        data: (data) => _InfoBody(data),
        error: (e, st) => Text(e.toString()),
        loading: () => const _BlankBody());
  }
}

class _BlankBody extends StatelessWidget {
  const _BlankBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Text(
                '',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                )),
          ),
          const SizedBox(
            height: 28,
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Text(
                '',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}

class _InfoBody extends StatelessWidget {
  const _InfoBody(this.data, {Key? key}) : super(key: key);

  final OneCall data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeUtil.screenVerticalPadding,
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Next 24 Hours',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          // _LineChart(data.hourly.take(24).toList()),
          _ScrollAbleLineChart(data.hourly.take(24).toList()),
          SizedBox(height: 24.r),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Next 7 Days',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          SizedBox(height: 12.r),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _WeekWeather(data.daily.take(7).toList()),
          ),
        ],
      ),
    );
  }
}
