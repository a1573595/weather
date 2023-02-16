import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// EdgeUtil需要等待ScreenUtilInit
class EdgeUtil {
  static double screenHorizontal = 24;
  static double screenVertical = 16;

  static EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: screenHorizontal, vertical: screenVertical);
  static EdgeInsets screenHorizontalPadding = EdgeInsets.symmetric(horizontal: screenHorizontal);
  static EdgeInsets screenVerticalPadding = EdgeInsets.symmetric(vertical: screenVertical);

  static EdgeInsets listviewVerticalPadding = EdgeInsets.symmetric(vertical: screenVertical);

  static EdgeInsets cardPadding = EdgeInsets.all(8.r);

  static initAfterScreenUtil() {
    screenHorizontal = 24.r;
    screenVertical = 16.r;

    screenPadding = EdgeInsets.symmetric(horizontal: screenHorizontal, vertical: screenVertical);

    screenHorizontalPadding = EdgeInsets.symmetric(horizontal: screenHorizontal);

    screenVerticalPadding = EdgeInsets.symmetric(vertical: screenVertical);

    listviewVerticalPadding = EdgeInsets.symmetric(vertical: screenVertical);

    cardPadding = EdgeInsets.all(8.r);
  }
}
