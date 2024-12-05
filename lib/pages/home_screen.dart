import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/Providers/home_screen_provider.dart';
import 'package:todo_list/Widgets/HomeWidgets/add_new_task_button.dart';
import 'package:todo_list/Widgets/HomeWidgets/appbar.dart';
import 'package:todo_list/Widgets/HomeWidgets/show_task_boxes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider.of<HomeScreenProvider>(context, listen: false).loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: addNewTaskButton(context),
        body: SafeArea(
          child: Column(
            children: [
              appBarWithSearch(themeData, context),
              showTasksBoxes(
                Provider.of<HomeScreenProvider>(context, listen: false).box,
                themeData,
                context,
              ),
            ],
          ),
        ));
  }
}
