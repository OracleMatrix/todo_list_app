import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/NotificationsService/notification_api.dart';
import 'package:todo_list/components/check_box.dart';
import 'package:todo_list/database/data.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/pages/edit.screen.dart';

class TaskItem extends StatefulWidget {
  static const double height = 74;
  static const double borderRadius = 8;
  const TaskItem({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  saveData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool("selectAllButton", selectAll);
  }

  loadData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      selectAll = preferences.getBool("selectAllButton") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    // ignore: prefer_typing_uninitialized_variables
    final priorityColor;

    switch (widget.task.priority) {
      case Priority.low:
        priorityColor = lowPriority;
        break;
      case Priority.normal:
        priorityColor = normalPriority;
        break;
      case Priority.high:
        priorityColor = highPriority;
        break;
    }
    return InkWell(
      onLongPress: () async {
        await showDialogForDeleteTaskOnInkWell(context);
      },
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditTaskScreen(task: widget.task),
          ),
        );
      },
      child: Dismissible(
        confirmDismiss: (direction) async {
          return await showDialogForConfirmDismiss(context, direction);
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            widget.task.delete();
          } else {
            setState(() {
              widget.task.isCompleted = !widget.task.isCompleted;
              widget.task.save();
            });
          }
        },
        key: Key(widget.task.name),
        secondaryBackground: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.delete,
              color: Colors.red,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Delete",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ],
        ),
        background: Row(
          children: [
            Icon(
              widget.task.isCompleted ? Icons.cancel_outlined : Icons.check,
              color: Colors.green,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              widget.task.isCompleted ? "Set as not complete" : "Set as done",
              style: const TextStyle(color: Colors.green),
            ),
          ],
        ),
        child: myListTile(themeData, priorityColor),
      ),
    );
  }

  Future<bool?> showDialogForConfirmDismiss(
      BuildContext context, DismissDirection direction) {
    return showDialog(
      context: context,
      builder: (context) {
        if (direction == DismissDirection.endToStart) {
          return AlertDialog(
            content: const Text(
              "Are you sure you want to delete the task?!",
            ),
            title: const Text("Delete task"),
            actions: [
              TextButton(
                onPressed: () {
                  if (widget.task.notificationId != null) {
                    NotificationsAPI.notification.cancel(widget.task.notificationId!);
                  }
                  Navigator.of(context).pop(true);
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  "No",
                ),
              )
            ],
          );
        } else {
          return AlertDialog(
            content: Text(
              widget.task.isCompleted
                  ? "Are you sure you want to mark this task as not completed?"
                  : "Are you sure you want to mark this task as completed?",
            ),
            title: Text(widget.task.isCompleted
                ? "Set as not completed"
                : "Set as Done"),
            actions: [
              TextButton(
                onPressed: () {
                  if (widget.task.notificationId != null) {
                    NotificationsAPI.notification.cancel(widget.task.notificationId!);
                  }
                  setState(() {
                    saveData();
                    widget.task.isCompleted = !widget.task.isCompleted;
                    widget.task.save();
                    if (selectAll == false && widget.task.isCompleted == true) {
                      selectAll = true;
                    } else if (widget.task.isCompleted == false) {
                      selectAll = false;
                    }
                  });
                  Navigator.of(context).pop();
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  "No",
                ),
              )
            ],
          );
        }
      },
    );
  }

  Future<dynamic> showDialogForDeleteTaskOnInkWell(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
            "Are you sure you want to delete the task?!",
          ),
          title: const Text("Delete task"),
          actions: [
            TextButton(
              onPressed: () {
                if (widget.task.notificationId != null) {
                  NotificationsAPI.notification.cancel(widget.task.notificationId!);
                }
                widget.task.delete();
                Navigator.pop(context);
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "No",
              ),
            )
          ],
        );
      },
    );
  }

  Widget myListTile(ThemeData themeData, priorityColor) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      shadowColor: priorityColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: MyCheckBox(
          value: widget.task.isCompleted,
          onTap: () {
            if (widget.task.notificationId != null) {
              NotificationsAPI.notification.cancel(widget.task.notificationId!);
            }
            setState(
              () {
                saveData();
                widget.task.isCompleted = !widget.task.isCompleted;
                widget.task.save();
                if (selectAll == false && widget.task.isCompleted == true) {
                  selectAll = true;
                } else if (widget.task.isCompleted == false) {
                  selectAll = false;
                }
              },
            );
          },
        ),
        title: Text(
          widget.task.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration:
                widget.task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Icon(
          Icons.flag,
          size: 25,
          color: priorityColor,
        ),
        subtitle:
            widget.task.notificationTime != null || widget.task.time != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.task.description,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inverseSurface,
                          decoration: widget.task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      Text(
                        "Scheduled at : ${widget.task.alarmTime != null ? widget.task.alarmTime!.month : widget.task.notificationTime!.month}-${widget.task.alarmTime != null ? widget.task.alarmTime!.day : widget.task.notificationTime!.day} | ${widget.task.time != null ? widget.task.time!.hour : widget.task.notificationTime!.hour}:${widget.task.time != null ? widget.task.time!.minute : widget.task.notificationTime!.minute}",
                      ),
                    ],
                  )
                : Text(
                    widget.task.description,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
      ),
    );
  }
}
