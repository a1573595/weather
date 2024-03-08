import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:weather/router/app_page.dart';
import 'package:weather/utils/extension_util.dart';

part 'shake_detector.dart';

class LogConsoleOnShake extends StatefulWidget {
  const LogConsoleOnShake(this.child, {super.key, this.debugOnly = true, this.dark = false});

  final Widget? child;
  final bool debugOnly;
  final bool dark;

  @override
  State<LogConsoleOnShake> createState() => _LogConsoleOnShakeState();
}

class _LogConsoleOnShakeState extends State<LogConsoleOnShake> {
  ShakeDetector? _detector;

  @override
  void initState() {
    super.initState();

    if (widget.debugOnly) {
      assert(() {
        _init();
        return true;
      }());
    } else {
      _init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }

  _init() {
    _detector = ShakeDetector(_openLogConsole)..startListening();
  }

  _openLogConsole() async {
    final router = GoRouter.of(context);
    if (!router.currentLocation.contains(AppPage.logConsole.path)) {
      router.push(AppPage.logConsole.fullPath);
    }
  }

  @override
  void dispose() {
    _detector?.stopListening();
    super.dispose();
  }
}
