import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:thesis_project/notifications/medication_card.dart';

class NotificationController {
  static late BuildContext appContext;

  static void initialize(BuildContext context) {
    appContext = context;
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    print('NN notification created');
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    print('NN notification displayed');

    int notificationId = receivedNotification.id!;

    // You can pass more data if needed
    Map<String, dynamic> payload = receivedNotification.payload ?? {};

    showDialog(
      context: appContext,
      builder: (BuildContext context) {
        return AlertDialog(
          content: MedicationCard(
            onResponse: (bool taken) {
              Navigator.of(context).pop();
            },
            selectedDate: payload['selectedDate'],
            timesIndex: notificationId,
            medicationId: payload['medicationId'],
          ),
        );
      },
    );
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    print('NN notification dismissed');
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    print('NN notification action');
  }
}
