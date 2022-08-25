import 'package:flutter/widgets.dart';

class EdgeUtil {
  static const screenHorizontal = 24.0;
  static const screenVertical = 16.0;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
      horizontal: screenHorizontal, vertical: screenVertical);

  static const EdgeInsets screenHorizontalPadding =
      EdgeInsets.symmetric(horizontal: screenHorizontal);

  static const EdgeInsets listviewVerticalPadding =
      EdgeInsets.symmetric(vertical: screenVertical);

  static const EdgeInsets cardPadding = EdgeInsets.symmetric(horizontal: 8.0);
}
