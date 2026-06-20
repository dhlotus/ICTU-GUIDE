import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Khởi tạo timezone
    tz.initializeTimeZones();

    // Cấu hình cho Android
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  /// Hiển thị thông báo ngay lập tức
  static Future<void> hienThiThongBao({
    required int id,
    required String tieuDe,
    required String noiDung,
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'lich_hoc_channel',
      'Lịch học',
      channelDescription: 'Thông báo nhắc nhở lịch học',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      id,
      tieuDe,
      noiDung,
      details,
    );
  }

  /// Lên lịch thông báo
  static Future<void> lenLichThongBao({
    required int id,
    required String tieuDe,
    required String noiDung,
    required DateTime thoiGian,
    int phutTruoc = 15,
  }) async {
    final thoiGianGui = thoiGian.subtract(Duration(minutes: phutTruoc));

    // Kiểm tra nếu thời gian đã qua
    if (thoiGianGui.isBefore(DateTime.now())) {
      return;
    }

    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'lich_hoc_channel',
      'Lịch học',
      channelDescription: 'Thông báo nhắc nhở lịch học',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      styleInformation: BigTextStyleInformation(''),
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    // Lên lịch với timezone local
    await _notifications.zonedSchedule(
      id,
      tieuDe,
      noiDung,
      tz.TZDateTime.from(thoiGianGui, tz.local),
      details,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> huyThongBao(int id) async {
    await _notifications.cancel(id);
  }

  static Future<void> huyTatCaThongBao() async {
    await _notifications.cancelAll();
  }
}