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
