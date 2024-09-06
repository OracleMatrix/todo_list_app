import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_list/database/data.dart';
import 'package:todo_list/pages/home_screen.dart';

const taskBoxName = "tasks";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    'todo_icon',
    [
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled notifications',
        channelDescription: 'Notifications scheduled by the user',
        defaultColor: const Color(0xFF9F9F9F),
        ledColor: Colors.white,
        playSound: true,
        enableVibration: true,
        icon: 'todo_icon',
      ),
    ],
  );
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
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
