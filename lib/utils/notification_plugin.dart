import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var notificationUtil = NotificationUtil();

class NotificationUtil {
  final FlutterLocalNotificationsPlugin _np = FlutterLocalNotificationsPlugin();

  init() {
    var android = const AndroidInitializationSettings("@mipmap/ic_launcher");

    /// iOS需要在AppDelegate註冊UNUserNotificationCenterDelegate
    var ios = DarwinInitializationSettings(
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification);

    /// 不要等待完成，iOS會卡在權限請求
    _np.initialize(
      InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          _onDidReceiveBackgroundNotificationResponse,
    );
  }

  /// iOS10以前前景通知需要額外顯示
  void _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page

    debugPrint('onDidReceiveLocalNotification payload: $payload');

    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title),
    //     content: Text(body),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: Text('Ok'),
    //         onPressed: () async {
    //           Navigator.of(context, rootNavigator: true).pop();
    //           await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => SecondScreen(payload),
    //             ),
    //           );
    //         },
    //       )
    //     ],
    //   ),
    // );
  }

  /// 前景通知Callback
  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    debugPrint('notification payload: ${response.payload}');

    /// do something
  }

  /// 背景通知Callback
  /// 需要宣告為靜態fun
  static void _onDidReceiveBackgroundNotificationResponse(
      NotificationResponse response) {
    debugPrint('notification payload: ${response.payload}');

    /// do something
  }

  /// 清除指定ID的通知
  /// tag為Android專用
  /// 若指定tag則ID與tag要都匹配才能在Android上生效
  void cancelNotification(int id, {String? tag}) {
    _np.cancel(id, tag: tag);
  }

  /// 清除所有通知
  void cleanNotification() {
    _np.cancelAll();
  }

  void sendNormal(String title, String body,
      {int? notificationId, String? params}) {
    /// Android notification channel配置與Notification屬性
    var androidDetails = const AndroidNotificationDetails(
      /// 給系統的識別ID
      'normalChannel',

      /// 給使用者的Channel名稱
      '一般通知',

      /// 給使用者的Channel描述
      channelDescription: '一般層級的通知',

      /// 重要性（排序）
      importance: Importance.defaultImportance,

      /// 優先權（處理順序）
      priority: Priority.defaultPriority,

      /// Channel的Icon
      // icon: ''

      /// 進度條（需同時設定）
      // progress: 19,
      // maxProgress: 100,
      // showProgress: true
    );

    /// iOS配置
    var iosDetails = const DarwinNotificationDetails(
      presentAlert: false,
      presentBadge: true,
      presentSound: false,
    );
    var details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    /// 顯示通知
    _np.show(notificationId ?? DateTime.now().millisecondsSinceEpoch >> 10,
        title, body, details,
        payload: params);
  }
}
