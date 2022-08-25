import 'package:flutter/widgets.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final VoidCallback? resumeCallBack;
  final VoidCallback? suspendingCallBack;

  late AppLifecycleState _lastState;

  LifecycleEventHandler({
    this.resumeCallBack,
    this.suspendingCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_lastState == AppLifecycleState.paused && resumeCallBack != null) {
          resumeCallBack!();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (suspendingCallBack != null) {
          suspendingCallBack!();
        }
        break;
    }

    _lastState = state;
  }
}