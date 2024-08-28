import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:thesis_project/medications/domain/prescription.dart';

class CreateNotification {
  void createNotification(
      {required BuildContext context,
      required int id,
      required int hour,
      required int minute,
      required Prescription prescription,
      required String selectedDateForm,
      required bool repeats}) async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: id,
          channelKey: 'channel',
          actionType: ActionType.Default,
          title: 'Hora de tomar ${prescription.name}',
          body: 'Ingira ${prescription.dosage} dose(s) de ${prescription.name}',
          category: NotificationCategory.Alarm,
          criticalAlert: true,
          payload: {
            'medicationId': prescription.medicationId,
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
