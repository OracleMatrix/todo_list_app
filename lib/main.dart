import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_list/data.dart';
import 'package:todo_list/edit.screen.dart';

const taskBoxName = "tasks";
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskEntityAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: primaryVariant),
  );
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(const MyApp());
}

const Color primaryColor = Color(0xff794CFF);
const Color primaryVariant = Color(0xff5C0AFF);
const Color secondaryTextColor = Color(0xffAFBED0);
const Color normalPriority = Color(0xffF09819);
const Color highPriority = Colors.red;
const Color lowPriority = Color(0xff3BE1F1);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff1D2830);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      theme: ThemeData(
        textTheme: _textTheme(),
        inputDecorationTheme: _inputDecorationTheme(),
        useMaterial3: false,
        colorScheme: _colorScheme(primaryTextColor),
      ),
      home: const HomeScreen(),
    );
  }

  ColorScheme _colorScheme(Color primaryTextColor) {
    return ColorScheme.light(
      primary: primaryColor,
      onPrimaryFixedVariant: primaryVariant,
      surface: const Color(0xffF3F5F8),
      onSurface: primaryTextColor,
      secondary: primaryColor,
      onSecondary: Colors.white,
    );
  }

  InputDecorationTheme _inputDecorationTheme() {
    return const InputDecorationTheme(
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(8),
      labelStyle: TextStyle(
        color: secondaryTextColor,
      ),
      iconColor: secondaryTextColor,
    );
  }

  TextTheme _textTheme() {
    return GoogleFonts.poppinsTextTheme(
      const TextTheme(
        labelLarge: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

bool selectAll = false;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();

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
                          MaterialButton(
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
                          ),
                          MaterialButton(
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
                          )
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
        await showDialog(
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
          return await showDialog(
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
                          widget.task.isCompleted = !widget.task.isCompleted;
                          widget.task.save();
                          if (selectAll == false &&
                              widget.task.isCompleted == true) {
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
        child: Container(
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
                    setState(() {
                      widget.task.isCompleted = !widget.task.isCompleted;
                      widget.task.save();
                      if (selectAll == false &&
                          widget.task.isCompleted == true) {
                        selectAll = true;
                      } else if (widget.task.isCompleted == false) {
                        selectAll = false;
                      }
                    });
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
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
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
        ),
      ),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final bool value;
  final Function() onTap;
  const MyCheckBox({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: !value
              ? Border.all(
                  width: 2,
                  color: secondaryTextColor,
                )
              : null,
          color: value ? primaryColor : null,
        ),
        child: value
            ? Icon(
                CupertinoIcons.check_mark,
                color: themeData.colorScheme.onPrimary,
                size: 16,
              )
            : null,
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/image/empty_state.svg",
          width: 120,
        ),
        const SizedBox(
          height: 12,
        ),
        const Text("Your task list is empty!")
      ],
    );
  }
}
