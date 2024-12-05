import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/NotificationsService/notification_api.dart';
import 'package:todo_list/database/data.dart';
import 'package:todo_list/main.dart';

class EditScreenProvider extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String reminderType = 'Alarm';

  DateTime? getScheduledDateTime() {
    if (selectedDate != null && selectedTime != null) {
      return DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    }
    return null;
  }

  Future pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      selectedDate = pickedDate;
      notifyListeners();
    }
  }

  Future pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null) {
      selectedTime = pickedTime;
      notifyListeners();
    }
  }

  void reminderMenu({required var value}) {
    reminderType = value;
    notifyListeners();
  }

  void priorityBoxHigh(TaskEntity task) {
    task.priority = Priority.high;
    notifyListeners();
  }

  void priorityBoxNormal(TaskEntity task) {
    task.priority = Priority.normal;
    notifyListeners();
  }

  void priorityBoxLow(TaskEntity task) {
    task.priority = Priority.low;
    notifyListeners();
  }

  void saveButton(BuildContext context, TextEditingController controller,
      TextEditingController desController, TaskEntity task) {
    try {
      if (controller.text.isNotEmpty && desController.text.isNotEmpty) {
        int notificationId = Random().nextInt(1000000);
        if (reminderType == "Alarm") {
          task.name = controller.text;
          task.description = desController.text;
          task.priority = task.priority;
          task.alarmTime = selectedDate;
          task.time = selectedTime;
          FlutterAlarmClock.createAlarm(
            hour: selectedTime.hour,
            minutes: selectedTime.minute,
            title: task.description,
          );
          if (task.isInBox) {
            task.save();
          } else {
            final Box<TaskEntity> box = Hive.box(taskBoxName);
            box.add(task);
          }
        } else if (reminderType == "Notification") {
          task.name = controller.text;
          task.description = desController.text;
          task.priority = task.priority;
          task.notificationTime = selectedDate;
          task.notificationId = notificationId;
          if (task.notificationId != null) {
            NotificationsAPI.notification.cancel(task.notificationId!);
          }

          NotificationsAPI.showScheduledNotification(
            scheduledDate: getScheduledDateTime()!,
            title: task.name,
            body: task.description,
            id: notificationId,
          ).then(
            (value) {
              task.notificationTime = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              );
              task.notificationId = notificationId;
              if (task.isInBox) {
                task.save();
              } else {
                final Box<TaskEntity> box = Hive.box(taskBoxName);
                box.add(task);
              }
            },
          );
        } else if (reminderType == "None") {
          task.name = controller.text;
          task.description = desController.text;
          task.priority = task.priority;
          if (task.isInBox) {
            task.save();
          } else {
            final Box<TaskEntity> box = Hive.box(taskBoxName);
            box.add(task);
          }
        }

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Title and Description cannot be empty!"),
          ),
        );
      }
    } catch (e) {
      throw Exception("Error on saving changes : $e");
    } finally {
      notifyListeners();
    }
  }
}
