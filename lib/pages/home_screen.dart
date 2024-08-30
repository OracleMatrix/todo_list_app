import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/components/task_items.dart';
import 'package:todo_list/database/data.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/pages/edit.screen.dart';
import 'package:todo_list/pages/empty_state_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();

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
  void initState() {
    loadData();
    super.initState();
  }

  final ValueNotifier<String> searchKeyWordNotifire = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TaskEntity>(taskBoxName);
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _floatingActionButton(context),
        body: SafeArea(
          child: Column(
            children: [
              _customAppBar(themeData),
              _showTasksBoxes(box, themeData),
            ],
          ),
        ));
  }

  Expanded _showTasksBoxes(Box<TaskEntity> box, ThemeData themeData) {
    return Expanded(
      child: ValueListenableBuilder<String>(
        valueListenable: searchKeyWordNotifire,
        builder: (context, value, child) {
          return ValueListenableBuilder<Box<TaskEntity>>(
            valueListenable: box.listenable(),
            builder: (context, box, child) {
              final List<TaskEntity> items;
              if (controller.text.isEmpty) {
                items = box.values.toList();
              } else {
                items = box.values
                    .where(
                      (element) => element.name.contains(controller.text),
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
                      // ignore: avoid_unnecessary_containers
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
      color: const Color(0xffEAEFF5),
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
      color: const Color(0xffEAEFF5),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: const Text(
                "Are you sure you want to select all of the tasks?!",
              ),
              title: Text(
                selectAll ? "Unselect all" : "Select all",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectAll = !selectAll;
                      saveData();
                      if (selectAll) {
                        for (var task in box.values) {
                          task.isCompleted = true;
                          task.save(); // Add this line to save the task
                        }
                      } else {
                        for (var task in box.values) {
                          task.isCompleted = false;
                          task.save(); // Add this line to save the task
                        }
                      }
                    });
                    Navigator.pop(context);
                  },
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
          Text(
            selectAll ? "Unselect all" : "Select all",
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

  Container _customAppBar(ThemeData themeData) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeData.colorScheme.primary,
            themeData.colorScheme.onPrimaryFixedVariant,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "To Do List",
                  style: themeData.textTheme.titleLarge!.apply(
                    color: themeData.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              height: 38,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19),
                color: themeData.colorScheme.onPrimary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  searchKeyWordNotifire.value = controller.text;
                },
                controller: controller,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: themeData.inputDecorationTheme.iconColor,
                  ),
                  hintText: "Search tasks...",
                  hintStyle: themeData.inputDecorationTheme.labelStyle,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  FloatingActionButton _floatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditTaskScreen(
              task: TaskEntity(),
            ),
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
}
