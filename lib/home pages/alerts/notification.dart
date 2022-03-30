import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> createNotification(id, context, medicalName, int hour, int minet,
    bool repet, String image) async {
      print("creared id is $id");
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: id,
        channelKey: 'scheduled_channel',
        title: 'موعد الدواء',
        body: '${Emojis.time_alarm_clock} عليك اخذ دواء ال$medicalName',
        bigPicture: '$image',
        notificationLayout: NotificationLayout.BigPicture),
    schedule: NotificationCalendar(
       hour: hour,
        minute: minet,
        second: 10, millisecond: 0, repeats: repet),
  );
}

Future<void> cancelNotification(int id) async {
  await AwesomeNotifications()
      .cancelSchedule(id)
      .then((value) => print("lecuterID= $id -----------------"));
}
