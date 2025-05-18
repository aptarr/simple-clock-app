import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';


class NotificationService {
  static Future<void> initializeNotification() async {
    // Initialize Awesome Notifications
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
          criticalAlerts: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic notifications group',
        )
      ],
      debug: true,
    );

    // Request notification permissions
    await AwesomeNotifications().isNotificationAllowed().then(
          (isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    // Set notification listeners
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onActionReceivedMethod,
      onNotificationCreatedMethod: _onNotificationCreateMethod,
      onNotificationDisplayedMethod: _onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: _onDismissActionReceivedMethod,
    );
  }

// Listeners

  static Future<void> _onNotificationCreateMethod(
      ReceivedNotification receivedNotification,
      ) async {
    debugPrint('Notification created: ${receivedNotification.title}');
  }

  static Future<void> _onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification,
      ) async {
    debugPrint('Notification displayed: ${receivedNotification.title}');
  }

  static Future<void> _onDismissActionReceivedMethod(
      ReceivedNotification receivedNotification,
      ) async {
    debugPrint('Notification dismissed: ${receivedNotification.title}');
  }

  static Future<void> _onActionReceivedMethod(
      ReceivedAction receivedAction,
      ) async {
    debugPrint('Notification action received');
    debugPrint('Notification action received: ${receivedAction.buttonKeyPressed}');

    if (receivedAction.buttonKeyPressed == 'SNOOZE') {
      final newTime = DateTime.now().add(Duration(minutes: 1));

      debugPrint('Snooze scheduled for: $newTime');

      bool success = await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
          channelKey: 'basic_channel',
          title: 'Alarm Snoozed',
          body: 'This alarm was snoozed for 1 minute.',
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar(
          year: newTime.year,
          month: newTime.month,
          day: newTime.day,
          hour: newTime.hour,
          minute: newTime.minute,
          second: newTime.second,
          millisecond: 0,
          repeats: false,
          preciseAlarm: true,
          timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        ),
        actionButtons: [
          NotificationActionButton(key: 'SNOOZE', label: 'Snooze'),
          NotificationActionButton(key: 'DISMISS', label: 'Dismiss', isDangerousOption: true),
        ],
      ).catchError((error) {
        debugPrint('Failed to schedule snoozed notification: $error');
      });

      debugPrint('Snoozed notification scheduled: $success');
    } else if (receivedAction.buttonKeyPressed == 'DISMISS') {
      await AwesomeNotifications().cancel(receivedAction.id!);
    }
  }


  static Future<void> createNotification({
    required final int id,
    required final String title,
    required final String body,
    DateTime? scheduleTime,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final Duration? interval,
  }) async {
    assert(!scheduled || (scheduled && interval != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'SNOOZE',
          label: 'Snooze',
        ),
        NotificationActionButton(
          key: 'DISMISS',
          label: 'Dismiss',
          isDangerousOption: true,
        ),
      ],
      schedule: scheduled
          ? NotificationInterval(
        interval: interval,
        timeZone:
        await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        preciseAlarm: true,
      )
          : null,
    );
  }
}