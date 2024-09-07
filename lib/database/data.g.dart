// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskEntityAdapter extends TypeAdapter<TaskEntity> {
  @override
  final int typeId = 0;

  @override
  TaskEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskEntity()
      ..name = fields[0] as String
      ..description = fields[1] as String
      ..isCompleted = fields[2] as bool
      ..priority = fields[3] as Priority
      ..notificationId = fields[4] as int?
      ..notificationTime = fields[5] as DateTime?
      ..alarmTime = fields[6] as DateTime?
      ..time = fields[7] as TimeOfDay?
      ..alarmId = fields[8] as int?;
  }

  @override
  void write(BinaryWriter writer, TaskEntity obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.isCompleted)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.notificationId)
      ..writeByte(5)
      ..write(obj.notificationTime)
      ..writeByte(6)
      ..write(obj.alarmTime)
      ..writeByte(7)
      ..write(obj.time)
      ..writeByte(8)
      ..write(obj.alarmId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PriorityAdapter extends TypeAdapter<Priority> {
  @override
  final int typeId = 1;

  @override
  Priority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Priority.low;
      case 1:
        return Priority.normal;
      case 2:
        return Priority.high;
      default:
        return Priority.low;
    }
  }

  @override
  void write(BinaryWriter writer, Priority obj) {
    switch (obj) {
      case Priority.low:
        writer.writeByte(0);
        break;
      case Priority.normal:
        writer.writeByte(1);
        break;
      case Priority.high:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimeOfDayAdapter extends TypeAdapter<TimeOfDay> {
  @override
  final int typeId = 2; // Choose a unique typeId

  @override
  TimeOfDay read(BinaryReader reader) {
    final hour = reader.readInt();
    final minute = reader.readInt();
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  void write(BinaryWriter writer, TimeOfDay obj) {
    writer.writeInt(obj.hour);
    writer.writeInt(obj.minute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeOfDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
