import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/Providers/edit_screen_provider.dart';
import 'package:todo_list/database/data.dart';

FloatingActionButton saveAndChangeButton(
    BuildContext context,
    TextEditingController controller,
    TextEditingController desController,
    TaskEntity task) {
  return FloatingActionButton.extended(
    onPressed: () => Provider.of<EditScreenProvider>(context, listen: false)
        .saveButton(context, controller, desController, task),
    label: Row(
      children: [
        task.isInBox
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
