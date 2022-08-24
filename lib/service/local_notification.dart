//채널 중요도 할당
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

LocalNotification localNotification = LocalNotification();

class LocalNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> sampleNotification() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', //채널 아이디
      'High Importance Notifications',
      importance: Importance.max, //중요성 최대
    );
    //기기에 채널 생성
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}