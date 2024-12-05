import 'package:flutter/material.dart';
import 'package:todo_list/database/data.dart';

AppBar appBar(ThemeData themeData, TaskEntity task) {
  return AppBar(
    backgroundColor: themeData.colorScheme.surface,
    foregroundColor: themeData.colorScheme.onSurface,
    elevation: 0,
    title: task.isInBox
        ? const Text(
            "Edit Task",
          )
        : const Text("Add a Task"),
  );
}
