import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future scheduleNotification(
    DateTime t,
    String c,
    String startTime,
    String venue,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    int count) async {
  if (t.isAfter(DateTime.now())) {
    var scheduledNotificationDateTime = t.subtract(Duration(seconds: 350));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      'your other channel description',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(count, c + " - " + venue,
        startTime, scheduledNotificationDateTime, platformChannelSpecifics);
  }
}

Future onSelectNotification(String payload) async {
//    showDialog(
//      context: context,
//      builder: (_) {
//        return new AlertDialog(
//          title: Text("PayLoad"),
//          content: Text("Payload : $payload"),
//        );
//      },
//    );
}
