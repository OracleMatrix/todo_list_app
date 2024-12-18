# Todo List App
A simple and pretty Todo List app built with Flutter.

### Features
* Create and manage your todo tasks
* Prioritize tasks with high, normal, and low priority levels
* Hive and SharedPrefrences database to store tasks and states
* Scheduled Notification
* Scheduled Alarms
* Mark tasks as completed
* Search for tasks by name
* Delete individual tasks or all tasks at once
* Select all or Unselect all tasks at once
* Swipe right to set as done or set as uncomplete task
* Swipe left to delete the task
* Hold on tasks to delete
* Edit existing tasks
* Empty state
* Dark mode theme

**Note:** Alarm and Notifications added
---

## Screenshots
| Empty State | Home Screen | Dark Mode |
|---|---|---|
| ![Empty State](Screenshot_1723662047.png) | ![Home Screen with tasks](Screenshot_1725635061.png) | ![Dark mode](darkmode.png) |
| Search | Dismissible (Delete) | Dismissible (Done/Undone) |
| ![Search between tasks](Screenshot_1725635078.png) | ![Dismissible option to delete task](Screenshot_1725635124.png) | ![Dismissible option to mark as done or unmark](Screenshot_1725635163.png) |
| Edit/Add Task | Choose Schedule | Choose Date |
| ![Edit or add a taskscreen](Screenshot_1725734418.png) | ![Choose schedule option](Screenshot_1725734422.png) | ![Choose date](Screenshot_1725635211.png) | 
| Choose Time |
| ![Choose time](Screenshot_1725635213.png) |





### Technical Details
* Built with `Flutter`
* Uses `Hive` for local storage
* Uses `flutter local notifications` for sendid local notifications
* Uses `Provider` for state management
* Implements a simple and efficient data model using HiveObject and * HiveType
* Utilizes Flutter's Material Design for a native Android and iOS look and feel

### Getting Started
1. Clone the repository: git clone https://github.com/OracleMatrix/todo_list_app.git
2. Open the project in your preferred IDE (e.g. Android Studio, Visual Studio Code)
3. Run the app on an emulator or physical device: flutter run

### Contributing
Contributions are welcome! If you'd like to contribute to the app, please fork the repository and submit a pull request.
