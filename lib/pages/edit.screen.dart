// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/Providers/edit_screen_provider.dart';
import 'package:todo_list/Widgets/EditScreenWidgets/appbar.dart';
import 'package:todo_list/Widgets/EditScreenWidgets/priority_boxes.dart';
import 'package:todo_list/Widgets/EditScreenWidgets/reminder_options.dart';
import 'package:todo_list/Widgets/EditScreenWidgets/save_button.dart';
import 'package:todo_list/database/data.dart';

class EditTaskScreen extends StatelessWidget {
  final TaskEntity task;

  EditTaskScreen({super.key, required this.task});

  late final TextEditingController controller =
      TextEditingController(text: task.name);

  late final TextEditingController desController =
      TextEditingController(text: task.description);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: appBar(themeData, task),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          saveAndChangeButton(context, controller, desController, task),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            flexForPriorityBoxes(task),
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
                hintStyle: themeData.textTheme.bodyMedium!.apply(
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
                  onPressed: () =>
                      Provider.of<EditScreenProvider>(context, listen: false)
                          .pickDate(context),
                  child: const Text(
                    "Choose a date",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                MaterialButton(
                  color: Colors.deepPurpleAccent,
                  onPressed: () async =>
                      Provider.of<EditScreenProvider>(context, listen: false)
                          .pickTime(context),
                  child: const Text(
                    "Choose a Time",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<EditScreenProvider>(
              builder: (context, provider, child) => DropDownMenuForReminder(
                provider: provider,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
