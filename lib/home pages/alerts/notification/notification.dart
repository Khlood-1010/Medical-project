import 'package:awesome_notifications/awesome_notifications.dart';


/*

1=> monday
2=> thuday 
3=> wend 
4=> theth 
5=>frida 
6=> saterday
7=> sun

*/



Future<void> creatPomodoroNotification(String body,id) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: id,
          channelKey: 'basic_channel',
          title: 'pomodoro',
          body: '${Emojis.paper_blue_book} $body',
          notificationLayout: NotificationLayout.Messaging));
}

Future<void> creatAcdimcTableNotification(
  id,
  context,
  lecturName,
  basNam,
  int hour,
  int minet,
  var weekDay,
) async {
  // bool isRepat=true;
  
 

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: id,
        channelKey: 'scheduled_channel',
        title: 'الجدول الاكاديمي',
        body:
            '${Emojis.time_alarm_clock} بدات محاضرة ال$lecturName في قاعة $basNam ',
        notificationLayout: NotificationLayout.Messaging),
    schedule: NotificationCalendar(
        weekday: weekDay,
        hour: hour,
        minute: minet,
        second: 0,
        millisecond: 0,
        repeats: true),
  );
 
}

Future<void> creatCalenderTableNotification(
    id,testName, DateTime time, int hour, int minet, bool isRepat) async {
 

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: id,
        channelKey: 'scheduled_channel',
        title: 'الجدول التقويمي',
        body: '${Emojis.time_alarm_clock} يجب عليك اداء مهمة$testName',
        notificationLayout: NotificationLayout.Inbox),
       
    schedule: NotificationCalendar(
        weekday: time.weekday, // 1=> monday
        day: time.day,
        month: time.month,
        year: time.year,
        hour: hour,
        minute: minet,
        second: 0,
        millisecond: 0,
        repeats: isRepat),
  );
}

Future<void> cancelNotification(id) async {
 
  await AwesomeNotifications().cancelSchedule(id);
   print( "lecuterID= $id -----------------");

}
