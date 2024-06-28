import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:thesis_project/medications/model/prescription.dart';

class CreateNotification {
  void createNotification(
      {required BuildContext context,
      required int id,
      required int hour,
      required int minute,
      required Prescription medication,
      required String selectedDateForm,
      required bool repeats}) async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: id,
          channelKey: 'channel',
          actionType: ActionType.Default,
          title: 'Hora de tomar ${medication.name}',
          body: 'Ingira ${medication.dosage} dose(s) de ${medication.name}',
          category: NotificationCategory.Alarm,
          criticalAlert: true,
          payload: {
            'medicationId': medication.id,
            'selectedDate': selectedDateForm
          }),
      schedule: NotificationCalendar(
          hour: hour,
          minute: minute,
          second: 0,
          repeats: repeats,
          timeZone: localTimeZone,
          preciseAlarm: true),
    );
    print('Notificação criada: $hour h $minute');
  }
}
