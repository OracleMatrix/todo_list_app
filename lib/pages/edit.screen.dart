import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_list/database/data.dart';
import 'package:todo_list/main.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskEntity task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  int notificationId = Random().nextInt(1000000);
  late DateTime selectedDate = DateTime.now();
  late TimeOfDay selectedTime = TimeOfDay.now();
  late final TextEditingController controller =
      TextEditingController(text: widget.task.name);
  late final TextEditingController desController =
      TextEditingController(text: widget.task.description);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: _appBar(themeData),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _floatingActionButton(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _flexForPriorityBoxes(),
            const SizedBox(height: 25),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                labelText: "Title",
                hintStyle: Theme.of(context).textTheme.bodyMedium!.apply(
                      fontSizeFactor: 1.2,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: desController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                labelText: "Description",
                hintStyle: Theme.of(context).textTheme.bodyMedium!.apply(
                      fontSizeFactor: 1.2,
                    ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  color: Colors.deepPurpleAccent,
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: const Text(
                    "Choose a date",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                MaterialButton(
                  color: Colors.deepPurpleAccent,
                  onPressed: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                  child: const Text(
                    "Choose a Time",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Flex _flexForPriorityBoxes() {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Flexible(
          flex: 1,
          child: PriorityCheckBox(
            label: "High",
            color: highPriority,
            isSelected: widget.task.priority == Priority.high,
            onTap: () {
              setState(() {
                widget.task.priority = Priority.high;
              });
            },
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Flexible(
          flex: 1,
          child: PriorityCheckBox(
            label: "Normal",
            color: normalPriority,
            isSelected: widget.task.priority == Priority.normal,
            onTap: () {
              setState(() {
                widget.task.priority = Priority.normal;
              });
            },
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Flexible(
          flex: 1,
          child: PriorityCheckBox(
            label: "low",
            color: lowPriority,
            isSelected: widget.task.priority == Priority.low,
            onTap: () {
              setState(() {
                widget.task.priority = Priority.low;
              });
            },
          ),
        ),
      ],
    );
  }

  FloatingActionButton _floatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        if (controller.text.isNotEmpty && desController.text.isNotEmpty) {
          widget.task.name = controller.text;
          widget.task.description = desController.text;
          widget.task.priority = widget.task.priority;
          if (widget.task.notificationId != null) {
            AwesomeNotifications().cancel(widget.task.notificationId!);
          }
          AwesomeNotifications()
              .createNotification(
            content: NotificationContent(
              id: notificationId,
              channelKey: 'scheduled_channel',
              title: widget.task.name,
              body: widget.task.description,
              wakeUpScreen: true,
              notificationLayout: NotificationLayout.BigText,
              color: Colors.deepPurpleAccent,
              backgroundColor: Colors.deepPurpleAccent,
              actionType: ActionType.KeepOnTop,
            ),
            schedule: NotificationCalendar(
              allowWhileIdle: true,
              day: selectedDate.day,
              month: selectedDate.month,
              year: selectedDate.year,
              hour: selectedTime.hour,
              minute: selectedTime.minute,
              second: 0,
              millisecond: 0,
            ),
          )
              .then(
            (value) {
              if (value) {
                widget.task.notificationTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );
                widget.task.notificationId = notificationId;
                if (widget.task.isInBox) {
                  widget.task.save();
                } else {
                  final Box<TaskEntity> box = Hive.box(taskBoxName);
                  box.add(widget.task);
                }
              } else {
                widget.task.notificationTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );
                widget.task.notificationId = notificationId;
                if (widget.task.isInBox) {
                  widget.task.save();
                } else {
                  final Box<TaskEntity> box = Hive.box(taskBoxName);
                  box.add(widget.task);
                }
              }
            },
          );

          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text("Title and Description cannot be empty!"),
            ),
          );
        }
      },
      label: Row(
        children: [
          widget.task.isInBox
              ? const Text(
                  "Save Changes",
                )
              : const Text(
                  "Save",
                ),
          const SizedBox(
            width: 4,
          ),
          const Icon(
            CupertinoIcons.check_mark_circled,
          )
        ],
      ),
    );
  }

  AppBar _appBar(ThemeData themeData) {
    return AppBar(
      backgroundColor: themeData.colorScheme.surface,
      foregroundColor: themeData.colorScheme.onSurface,
      elevation: 0,
      title: widget.task.isInBox
          ? const Text(
              "Edit Task",
            )
          : const Text("Add a Task"),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;
  const PriorityCheckBox({
    super.key,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 2,
            color: secondaryTextColor.withOpacity(0.2),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(label),
            ),
            Positioned(
              right: 8,
              bottom: 0,
              top: 0,
              child: Center(
                child: PriorityCheckBoxShape(value: isSelected, color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBoxShape extends StatelessWidget {
  final bool value;
  final Color color;
  const PriorityCheckBoxShape(
      {super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              color: themeData.colorScheme.onPrimary,
              size: 12,
            )
          : null,
    );
  }
}
