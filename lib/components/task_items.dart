import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        child: containerToShowTheTask(themeData, priorityColor),
      ),
    );
  }

  Container containerToShowTheTask(ThemeData themeData, priorityColor) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(left: 16),
      height: TaskItem.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TaskItem.borderRadius),
        color: themeData.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.15),
          ),
        ],
      ),
      child: Row(
        children: [
          MyCheckBox(
            value: widget.task.isCompleted,
            onTap: () {
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
            },
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(
              widget.task.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                decoration:
                    widget.task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          Container(
            width: 20,
            height: TaskItem.height,
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(TaskItem.borderRadius),
                bottomRight: Radius.circular(TaskItem.borderRadius),
              ),
            ),
          ),
        ],
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
}
