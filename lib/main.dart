import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/NotificationsService/notification_api.dart';
import 'package:todo_list/Providers/edit_screen_provider.dart';
import 'package:todo_list/Providers/home_screen_provider.dart';
import 'package:todo_list/database/data.dart' as db;
import 'package:todo_list/pages/home_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

const taskBoxName = "tasks";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationsAPI.init();
  tz.initializeTimeZones();
  Permission.notification.isDenied.then(
    (value) {
      if (value) {
        Permission.notification.request();
      }
    },
  );
  await Hive.initFlutter();
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(db.TaskEntityAdapter());
  Hive.registerAdapter(db.PriorityAdapter());
  await Hive.openBox<db.TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: primaryVariant),
  );
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => EditScreenProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeScreenProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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

    return AdaptiveTheme(
      initial: AdaptiveThemeMode.system,
      light: ThemeData(
        colorScheme: _colorScheme(primaryTextColor),
        textTheme: _textTheme(),
        inputDecorationTheme: _inputDecorationTheme(),
        useMaterial3: false,
      ),
      dark: ThemeData(
        colorScheme: _darkColorScheme(primaryTextColor),
        textTheme: _textTheme(),
        inputDecorationTheme: _inputDarkDecorationTheme(),
        useMaterial3: false,
      ),
      builder: (light, dark) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ToDo App',
        theme: light,
        darkTheme: dark,
        home: const HomeScreen(),
      ),
    );
  }

  ColorScheme _darkColorScheme(Color primaryTextColor) {
    return const ColorScheme.dark(
      primary: primaryColor,
      onPrimaryFixedVariant: primaryVariant,
      surface: Color(0xff303030),
      inversePrimary: Color(0xff2A2A2A),
      onSurface: Colors.white,
      inverseSurface: Colors.white,
      secondary: primaryColor,
      onSecondary: Colors.black,
    );
  }

  ColorScheme _colorScheme(Color primaryTextColor) {
    return ColorScheme.light(
      primary: primaryColor,
      onPrimaryFixedVariant: primaryVariant,
      surface: const Color(0xffF3F5F8),
      inverseSurface: Colors.black,
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

  InputDecorationTheme _inputDarkDecorationTheme() {
    return const InputDecorationTheme(
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(8),
      labelStyle: TextStyle(
        color: Colors.grey,
      ),
      iconColor: Colors.grey,
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
