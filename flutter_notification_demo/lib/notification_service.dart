import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {

  static final FlutterLocalNotificationsPlugin
      _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Stream para clique na notificação
  static final StreamController<String?>
      onNotificationClick =
      StreamController<String?>.broadcast();

  /// =====================================
  /// INICIALIZAÇÃO
  /// =====================================
  static Future<void> init() async {

    // Inicializa timezone
    tz.initializeTimeZones();

    // ANDROID
    const AndroidInitializationSettings
        androidInitializationSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // IOS
    const DarwinInitializationSettings
        iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings
        initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _notificationsPlugin.initialize(

      initializationSettings,

      onDidReceiveNotificationResponse:
          (NotificationResponse response) {

        final String? payload =
            response.payload;

        if (payload != null &&
            payload.isNotEmpty) {

          onNotificationClick.add(
            payload,
          );
        }
      },
    );
  }

  /// =====================================
  /// PERMISSÕES
  /// =====================================
  static Future<void>
      requestPermissions() async {

    // Android
    final androidImplementation =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {

      // Android 13+
      await androidImplementation
          .requestNotificationsPermission();

      // Alarmes exatos
      await androidImplementation
          .requestExactAlarmsPermission();
    }

    // IOS
    final iosImplementation =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>();

    if (iosImplementation != null) {

      await iosImplementation
          .requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  /// =====================================
  /// DETALHES DA NOTIFICAÇÃO
  /// =====================================
  static NotificationDetails
      _notificationDetails({

    List<AndroidNotificationAction>? actions,

  }) {

    return NotificationDetails(

      android: AndroidNotificationDetails(

        'canal_estudos_id',

        'Lembretes de Estudo',

        channelDescription:
            'Canal de notificações locais',

        importance: Importance.max,

        priority: Priority.high,

        playSound: true,

        ticker: 'ticker',

        actions: actions,
      ),

      iOS: const DarwinNotificationDetails(

        presentAlert: true,

        presentBadge: true,

        presentSound: true,
      ),
    );
  }

  /// =====================================
  /// NOTIFICAÇÃO IMEDIATA
  /// =====================================
  static Future<void>
      showInstantNotification({

    required int id,

    required String title,

    required String body,

  }) async {

    await _notificationsPlugin.show(

      id,

      title,

      body,

      _notificationDetails(),
    );
  }

/// =====================================
/// NOTIFICAÇÃO AGENDADA
/// =====================================
static Future<void>
    scheduleNotification({

  required int id,

  required String title,

  required String body,

  required int secondsDelay,

}) async {

  final scheduledDate =
      tz.TZDateTime.now(
    tz.local,
  ).add(
    Duration(
      seconds: secondsDelay,
    ),
  );

  print(
    'NOTIFICAÇÃO AGENDADA PARA: '
    '$scheduledDate',
  );

  await _notificationsPlugin.zonedSchedule(

    id,

    title,

    body,

    scheduledDate,

    NotificationDetails(

      android: AndroidNotificationDetails(

        'canal_estudos_id',

        'Lembretes de Estudo',

        channelDescription:
            'Canal de notificações locais',

        importance: Importance.max,

        priority: Priority.max,

        playSound: true,

        enableVibration: true,

        visibility:
            NotificationVisibility.public,

        fullScreenIntent: true,

        category: AndroidNotificationCategory.alarm,
      ),

      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    ),

    androidScheduleMode:
        AndroidScheduleMode.exactAllowWhileIdle,

    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation
            .absoluteTime,
  );

  print('NOTIFICAÇÃO CRIADA');
}

  /// =====================================
  /// NOTIFICAÇÃO RECORRENTE
  /// =====================================
  static Future<void>
      scheduleDailyNotification({

    required int id,

    required String title,

    required String body,

    required int hour,

    required int minute,

  }) async {

    final now =
        tz.TZDateTime.now(
      tz.local,
    );

    tz.TZDateTime scheduledDate =
        tz.TZDateTime(

      tz.local,

      now.year,

      now.month,

      now.day,

      hour,

      minute,
    );

    // Se já passou hoje
    if (scheduledDate.isBefore(now)) {

      scheduledDate =
          scheduledDate.add(
        const Duration(days: 1),
      );
    }

    await _notificationsPlugin.zonedSchedule(

      id,

      title,

      body,

      scheduledDate,

      _notificationDetails(),

      androidScheduleMode:
          AndroidScheduleMode
              .inexactAllowWhileIdle,

      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation
              .absoluteTime,

      // Repete diariamente
      matchDateTimeComponents:
          DateTimeComponents.time,
    );
  }

  /// =====================================
  /// NOTIFICAÇÃO COM AÇÃO
  /// =====================================
  static Future<void>
      showNotificationWithAction({

    required int id,

    required String title,

    required String body,

    required String payloadRoute,

  }) async {

    await _notificationsPlugin.show(

      id,

      title,

      body,

      _notificationDetails(

        actions: [

          const AndroidNotificationAction(

            'abrir_tela',

            'Abrir Tela',

            showsUserInterface: true,
          ),
        ],
      ),

      payload: payloadRoute,
    );
  }

  /// =====================================
  /// CANCELAR UMA
  /// =====================================
  static Future<void>
      cancelNotification(
    int id,
  ) async {

    await _notificationsPlugin
        .cancel(id);
  }

  /// =====================================
  /// CANCELAR TODAS
  /// =====================================
  static Future<void>
      cancelAllNotifications() async {

    await _notificationsPlugin
        .cancelAll();
  }
}