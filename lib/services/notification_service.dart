import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize({
    void Function(NotificationResponse)? onDidReceiveBackgroundNotificationResponse,
  }) async {
    tz.initializeTimeZones();

    // Request permissions for Android 13 and above
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // Initialize notification settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap in foreground
      },
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    );

    // Request exact alarms permission for Android
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  Future<void> showBookingConfirmation({
    required String serviceName,
    required String address,
    required DateTime serviceDateTime,
  }) async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.hashCode,
      'Booking Confirmed',
      'Your $serviceName is scheduled for ${_formatDateTime(serviceDateTime)}\nLocation: $address',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'booking_confirmations',
          'Booking Confirmations',
          channelDescription: 'Notifications for service bookings',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/$year at $hour:$minute';
  }
} 