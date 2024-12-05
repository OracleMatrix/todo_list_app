import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/database/data.dart';
import 'package:todo_list/pages/edit.screen.dart';

FloatingActionButton addNewTaskButton(BuildContext context) {
  return FloatingActionButton.extended(
    onPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditTaskScreen(task: TaskEntity()),
        ),
      );
    },
    label: const Row(
      children: [
        Text(
          "Add New Task",
        ),
        SizedBox(
          width: 4,
        ),
        Icon(CupertinoIcons.add_circled)
      ],
    ),
  );
}
