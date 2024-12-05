import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/Providers/edit_screen_provider.dart';
import 'package:todo_list/main.dart';

import '../../database/data.dart';

Widget flexForPriorityBoxes(TaskEntity task) {
  return Consumer<EditScreenProvider>(
    builder: (context, value, child) => Flex(
      direction: Axis.horizontal,
      children: [
        Flexible(
          flex: 1,
          child: PriorityCheckBox(
            label: "High",
            color: highPriority,
            isSelected: task.priority == Priority.high,
            onTap: () {
              value.priorityBoxHigh(task);
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
            isSelected: task.priority == Priority.normal,
            onTap: () {
              value.priorityBoxNormal(task);
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
            isSelected: task.priority == Priority.low,
            onTap: () {
              value.priorityBoxLow(task);
            },
          ),
        ),
      ],
    ),
  );
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
