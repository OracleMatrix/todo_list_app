import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/Providers/home_screen_provider.dart';
import 'package:todo_list/components/task_items.dart';
import 'package:todo_list/database/data.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/pages/empty_state_screen.dart';

Expanded showTasksBoxes(
    Box<TaskEntity> box, ThemeData themeData, BuildContext context) {
  return Expanded(
    child: ValueListenableBuilder<String>(
      valueListenable: Provider.of<HomeScreenProvider>(context, listen: false)
          .searchKeyWordNotifier,
      builder: (context, value, child) {
        return ValueListenableBuilder<Box<TaskEntity>>(
          valueListenable: box.listenable(),
          builder: (context, box, child) {
            final List<TaskEntity> items;
            if (Provider.of<HomeScreenProvider>(context, listen: false)
                .controller
                .text
                .isEmpty) {
              items = box.values.toList();
            } else {
              items = box.values
                  .where(
                    (element) => element.name.contains(
                        Provider.of<HomeScreenProvider>(context, listen: false)
                            .controller
                            .text),
                  )
                  .toList();
            }
            if (items.isNotEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: items.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tasks",
                              style: themeData.textTheme.titleLarge!
                                  .apply(fontSizeFactor: 0.9),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              height: 3,
                              width: 70,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(1.5),
                              ),
                            )
                          ],
                        ),
                        selectAllButton(context, box),
                        deleteAllButton(context, box)
                      ],
                    );
                  } else {
                    final TaskEntity task = items[index - 1];
                    return TaskItem(task: task);
                  }
                },
              );
            } else {
              return const EmptyState();
            }
          },
        );
      },
    ),
  );
}

MaterialButton deleteAllButton(BuildContext context, Box<TaskEntity> box) {
  return MaterialButton(
    elevation: 0,
    textColor: secondaryTextColor,
    color: Theme.of(context).colorScheme.inversePrimary,
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text(
              "Are you sure you want to delete all of the tasks?!",
            ),
            title: const Text("Delete All"),
            actions: [
              TextButton(
                onPressed: () {
                  box.clear();
                  Navigator.pop(context);
                },
                child: const Text("Delete All"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        },
      );
    },
    child: const Row(
      children: [
        Text(
          "Delete All",
        ),
        SizedBox(
          width: 4,
        ),
        Icon(
          CupertinoIcons.delete_solid,
          size: 18,
        )
      ],
    ),
  );
}

MaterialButton selectAllButton(BuildContext context, Box<TaskEntity> box) {
  return MaterialButton(
    elevation: 0,
    textColor: secondaryTextColor,
    color: Theme.of(context).colorScheme.inversePrimary,
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text(
              "Are you sure you want to select all of the tasks?!",
            ),
            title: Consumer<HomeScreenProvider>(
              builder: (context, value, child) => Text(
                value.selectAll ? "Unselect all" : "Select all",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Provider.of<HomeScreenProvider>(context, listen: false)
                        .selectAllButton(context, TaskEntity()),
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        },
      );
    },
    child: Row(
      children: [
        Consumer<HomeScreenProvider>(
          builder: (context, value, child) => Text(
            value.selectAll ? "Unselect all" : "Select all",
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        const Icon(
          CupertinoIcons.check_mark,
          size: 18,
        )
      ],
    ),
  );
}
