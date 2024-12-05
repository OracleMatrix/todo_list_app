import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/NotificationsService/notification_api.dart';
import 'package:todo_list/database/data.dart';
import 'package:todo_list/main.dart';

class HomeScreenProvider extends ChangeNotifier {
  final TaskEntity task = TaskEntity();
  final TextEditingController controller = TextEditingController();
  bool selectAll = false;
  final ValueNotifier<String> searchKeyWordNotifier = ValueNotifier("");
  final box = Hive.box<TaskEntity>(taskBoxName);

  saveData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool("selectAllButton", selectAll);
    notifyListeners();
  }

  loadData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    selectAll = preferences.getBool("selectAllButton") ?? false;
    notifyListeners();
  }

  void selectAllButton(BuildContext context, TaskEntity task) {
    try {
      selectAll = !selectAll;
      saveData();
      if (selectAll) {
        for (var task in box.values) {
          task.isCompleted = true;
          if (task.notificationId != null) {
            NotificationsAPI.notification.cancel(task.notificationId!);
          }
          task.save();
        }
      } else {
        for (var task in box.values) {
          task.isCompleted = false;
          task.save();
        }
      }
      Navigator.pop(context);
    } catch (e) {
      throw Exception("Error on selectAll Button : $e");
    } finally {
      notifyListeners();
    }
  }

  void markAsDone(BuildContext context, TaskEntity task) {
    try {
      if (task.notificationId != null) {
        NotificationsAPI.notification.cancel(task.notificationId!);
      }
      saveData();
      task.isCompleted = !task.isCompleted;
      task.save();
      if (selectAll == false && task.isCompleted == true) {
        selectAll = true;
      } else if (task.isCompleted == false) {
        selectAll = false;
      }
      Navigator.of(context).pop();
    } catch (e) {
      throw Exception("Error on mark as done : $e");
    } finally {
      notifyListeners();
    }
  }

  void listTileOptions(BuildContext context, TaskEntity task) {
    try {
      if (task.notificationId != null) {
        NotificationsAPI.notification.cancel(task.notificationId!);
      }
      saveData();
      task.isCompleted = !task.isCompleted;
      task.save();
      if (selectAll == false && task.isCompleted == true) {
        selectAll = true;
      } else if (task.isCompleted == false) {
        selectAll = false;
      }
    } catch (e) {
      throw Exception("Error on ListTile Options : $e");
    } finally {
      notifyListeners();
    }
  }

  void onDismiss(DismissDirection direction, TaskEntity task) {
    try {
      if (direction == DismissDirection.endToStart) {
        task.delete();
      } else {
        task.isCompleted = !task.isCompleted;
        task.save();
      }
    } catch (e) {
      throw Exception("Error on dismiss : $e");
    } finally {
      notifyListeners();
    }
  }
}
