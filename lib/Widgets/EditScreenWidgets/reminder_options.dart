import 'package:flutter/material.dart';
import 'package:todo_list/Providers/edit_screen_provider.dart';

class DropDownMenuForReminder extends StatelessWidget {
  final EditScreenProvider provider;

  const DropDownMenuForReminder({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      dropdownColor: Colors.deepPurpleAccent,
      borderRadius: BorderRadius.circular(12),
      iconEnabledColor: Colors.deepPurpleAccent,
      iconSize: 30,
      value: provider.reminderType,
      onChanged: (value) => provider.reminderMenu(value: value),
      items: const [
        DropdownMenuItem(
          value: "Alarm",
          child: Text("Remind by Alarm"),
        ),
        DropdownMenuItem(
          value: "Notification",
          child: Text("Remind by Notification"),
        ),
        DropdownMenuItem(
          value: "None",
          child: Text("Don't remind me!"),
        ),
      ],
    );
  }
}
