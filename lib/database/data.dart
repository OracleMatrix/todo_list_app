import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
part 'data.g.dart';

@HiveType(typeId: 0)
class TaskEntity extends HiveObject {
  @HiveField(0)
  String name = '';
  @HiveField(1)
  String description = '';
  @HiveField(2)
  bool isCompleted = false;
  @HiveField(3)
  Priority priority = Priority.low;
  @HiveField(4)
  int? notificationId;
  @HiveField(5)
  DateTime? notificationTime;
  @HiveField(6)
  DateTime? alarmTime;
  @HiveField(7)
  TimeOfDay? time;
  @HiveField(8)
  int? alarmId;
}

@HiveType(typeId: 1)
enum Priority {
  @HiveField(0)
  low,
  @HiveField(1)
  normal,
  @HiveField(2)
  high
}
