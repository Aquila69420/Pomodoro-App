
// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, use_key_in_widget_constructors, import_of_legacy_library_into_null_safe

// Imports
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iosstyleswitch/iosstyleswitch.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]); // Displays System UI
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes Debug Banner
      title: 'Pomodoro App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final _tabController =
      TabController(length: 3, vsync: this, initialIndex: 0);

  // Animation Controllers for each timer
  late AnimationController controllerPomodoro;
  late AnimationController controllerShortBreak;
  late AnimationController controllerLongBreak;

  // Booleans for each timer
  bool isPlayingPomodoro = false;
  bool isPlayingShortBreak = false;
  bool isPlayingLongBreak = false;

  // Boolean for auto transition to next timer
  bool autoTransition = true;
  
  // HashMaps for timer slider values
  Map incrementsPomodoro = {
    0.5: "0:30", 1.0: "1:00", 1.5: "1:30", 2.0: "2:00", 2.5: "2:30", 3.0: "3:00", 3.5: "3:30", 4.0: "4:00", 4.5: "4:30", 5.0: "5:00",
    5.5: "5:30", 6.0: "6:00", 6.5: "6:30", 7.0: "7:00", 7.5: "7:30", 8.0: "8:00", 8.5: "8:30", 9.0: "9:00", 9.5: "9:30", 10.0: "10:00",
    10.5: "10:30", 11.0: "11:00", 11.5: "11:30", 12.0: "12:00", 12.5: "12:30", 13.0: "13:00", 13.5: "13:30", 14.0: "14:00", 14.5: "14:30", 15.0: "15:00",
    15.5: "15:30", 16.0: "16:00", 16.5: "16:30", 17.0: "17:00", 17.5: "17:30", 18.0: "18:00", 18.5: "18:30", 19.0: "19:00", 19.5: "19:30", 20.0: "20:00",
    20.5: "20:30", 21.0: "21:00", 21.5: "21:30", 22.0: "22:00", 22.5: "22:30", 23.0: "23:00", 23.5: "23:30", 24.0: "24:00", 24.5: "24:30", 25.0: "25:00",
    25.5: "25:30", 26.0: "26:00", 26.5: "26:30", 27.0: "27:00", 27.5: "27:30", 28.0: "28:00", 28.5: "28:30", 29.0: "29:00", 29.5: "29:30", 30.0: "30:00",
    30.5: "30:30", 31.0: "31:00", 31.5: "31:30", 32.0: "32:00", 32.5: "32:30", 33.0: "33:00", 33.5: "33:30", 34.0: "34:00", 34.5: "34:30", 35.0: "35:00",
    35.5: "35:30", 36.0: "36:00", 36.5: "36:30", 37.0: "37:00", 37.5: "37:30", 38.0: "38:00", 38.5: "38:30", 39.0: "39:00", 39.5: "39:30", 40.0: "40:00",
    40.5: "40:30", 41.0: "41:00", 41.5: "41:30", 42.0: "42:00", 42.5: "42:30", 43.0: "43:00", 43.5: "43:30", 44.0: "44:00", 44.5: "44:30", 45.0: "45:00",
    45.5: "45:30", 46.0: "46:00", 46.5: "46:30", 47.0: "47:00", 47.5: "47:30", 48.0: "48:00", 48.5: "48:30", 49.0: "49:00", 49.5: "49:30", 50.0: "50:00",
    50.5: "50:30", 51.0: "51:00", 51.5: "51:30", 52.0: "52:00", 52.5: "52:30", 53.0: "53:00", 53.5: "53:30", 54.0: "54:00", 54.5: "54:30", 55.0: "55:00",
    55.5: "55:30", 56.0: "56:00", 56.5: "56:30", 57.0: "57:00", 57.5: "57:30", 58.0: "58:00", 58.5: "58:30", 59.0: "59:00", 59.5: "59:30", 60.0: "60:00",
  };

  Map incrementsShortBreak = {
    0.5: "0:30", 1.0: "1:00", 1.5: "1:30", 2.0: "2:00", 2.5: "2:30", 3.0: "3:00", 3.5: "3:30", 4.0: "4:00", 4.5: "4:30", 5.0: "5:00",
    5.5: "5:30", 6.0: "6:00", 6.5: "6:30", 7.0: "7:00", 7.5: "7:30", 8.0: "8:00", 8.5: "8:30", 9.0: "9:00", 9.5: "9:30", 10.0: "10:00",
    10.5: "10:30", 11.0: "11:00", 11.5: "11:30", 12.0: "12:00", 12.5: "12:30", 13.0: "13:00", 13.5: "13:30", 14.0: "14:00", 14.5: "14:30", 15.0: "15:00",
    15.5: "15:30", 16.0: "16:00", 16.5: "16:30", 17.0: "17:00", 17.5: "17:30", 18.0: "18:00", 18.5: "18:30", 19.0: "19:00", 19.5: "19:30", 20.0: "20:00",
    20.5: "20:30", 21.0: "21:00", 21.5: "21:30", 22.0: "22:00", 22.5: "22:30", 23.0: "23:00", 23.5: "23:30", 24.0: "24:00", 24.5: "24:30", 25.0: "25:00",
    25.5: "25:30", 26.0: "26:00", 26.5: "26:30", 27.0: "27:00", 27.5: "27:30", 28.0: "28:00", 28.5: "28:30", 29.0: "29:00", 29.5: "29:30", 30.0: "30:00",
    30.5: "30:30", 31.0: "31:00", 31.5: "31:30", 32.0: "32:00", 32.5: "32:30", 33.0: "33:00", 33.5: "33:30", 34.0: "34:00", 34.5: "34:30", 35.0: "35:00",
    35.5: "35:30", 36.0: "36:00", 36.5: "36:30", 37.0: "37:00", 37.5: "37:30", 38.0: "38:00", 38.5: "38:30", 39.0: "39:00", 39.5: "39:30", 40.0: "40:00",
    40.5: "40:30", 41.0: "41:00", 41.5: "41:30", 42.0: "42:00", 42.5: "42:30", 43.0: "43:00", 43.5: "43:30", 44.0: "44:00", 44.5: "44:30", 45.0: "45:00",
    45.5: "45:30", 46.0: "46:00", 46.5: "46:30", 47.0: "47:00", 47.5: "47:30", 48.0: "48:00", 48.5: "48:30", 49.0: "49:00", 49.5: "49:30", 50.0: "50:00",
    50.5: "50:30", 51.0: "51:00", 51.5: "51:30", 52.0: "52:00", 52.5: "52:30", 53.0: "53:00", 53.5: "53:30", 54.0: "54:00", 54.5: "54:30", 55.0: "55:00",
    55.5: "55:30", 56.0: "56:00", 56.5: "56:30", 57.0: "57:00", 57.5: "57:30", 58.0: "58:00", 58.5: "58:30", 59.0: "59:00", 59.5: "59:30", 60.0: "60:00",
  };
  
  Map incrementsLongBreak = {
    0.5: "0:30", 1.0: "1:00", 1.5: "1:30", 2.0: "2:00", 2.5: "2:30", 3.0: "3:00", 3.5: "3:30", 4.0: "4:00", 4.5: "4:30", 5.0: "5:00",
    5.5: "5:30", 6.0: "6:00", 6.5: "6:30", 7.0: "7:00", 7.5: "7:30", 8.0: "8:00", 8.5: "8:30", 9.0: "9:00", 9.5: "9:30", 10.0: "10:00",
    10.5: "10:30", 11.0: "11:00", 11.5: "11:30", 12.0: "12:00", 12.5: "12:30", 13.0: "13:00", 13.5: "13:30", 14.0: "14:00", 14.5: "14:30", 15.0: "15:00",
    15.5: "15:30", 16.0: "16:00", 16.5: "16:30", 17.0: "17:00", 17.5: "17:30", 18.0: "18:00", 18.5: "18:30", 19.0: "19:00", 19.5: "19:30", 20.0: "20:00",
    20.5: "20:30", 21.0: "21:00", 21.5: "21:30", 22.0: "22:00", 22.5: "22:30", 23.0: "23:00", 23.5: "23:30", 24.0: "24:00", 24.5: "24:30", 25.0: "25:00",
    25.5: "25:30", 26.0: "26:00", 26.5: "26:30", 27.0: "27:00", 27.5: "27:30", 28.0: "28:00", 28.5: "28:30", 29.0: "29:00", 29.5: "29:30", 30.0: "30:00",
    30.5: "30:30", 31.0: "31:00", 31.5: "31:30", 32.0: "32:00", 32.5: "32:30", 33.0: "33:00", 33.5: "33:30", 34.0: "34:00", 34.5: "34:30", 35.0: "35:00",
    35.5: "35:30", 36.0: "36:00", 36.5: "36:30", 37.0: "37:00", 37.5: "37:30", 38.0: "38:00", 38.5: "38:30", 39.0: "39:00", 39.5: "39:30", 40.0: "40:00",
    40.5: "40:30", 41.0: "41:00", 41.5: "41:30", 42.0: "42:00", 42.5: "42:30", 43.0: "43:00", 43.5: "43:30", 44.0: "44:00", 44.5: "44:30", 45.0: "45:00",
    45.5: "45:30", 46.0: "46:00", 46.5: "46:30", 47.0: "47:00", 47.5: "47:30", 48.0: "48:00", 48.5: "48:30", 49.0: "49:00", 49.5: "49:30", 50.0: "50:00",
    50.5: "50:30", 51.0: "51:00", 51.5: "51:30", 52.0: "52:00", 52.5: "52:30", 53.0: "53:00", 53.5: "53:30", 54.0: "54:00", 54.5: "54:30", 55.0: "55:00",
    55.5: "55:30", 56.0: "56:00", 56.5: "56:30", 57.0: "57:00", 57.5: "57:30", 58.0: "58:00", 58.5: "58:30", 59.0: "59:00", 59.5: "59:30", 60.0: "60:00",
  };

  // Lists for timer sliders
  final List<double> valuesPomodoro = [
    0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7, 7.5, 8, 8.5, 10.0,
    10.5, 11.0, 11.5, 12.0, 12.5, 13.0, 13.5, 15.0, 15.5, 16.0, 16.5, 17.0, 17.5, 18.0, 18.5, 20.0,
    20.5, 21.0, 21.5, 22.0, 22.5, 23.0, 23.5, 25.0, 25.5, 26.0, 26.5, 27.0, 27.5, 28.0, 28.5, 30.0,
    30.5, 31.0, 31.5, 32.0, 32.5, 33.0, 33.5, 35.0, 35.5, 36.0, 36.5, 37.0, 37.5, 38.0, 38.5, 40.0,
    40.5, 41.0, 41.5, 42.0, 42.5, 43.0, 43.5, 45.0, 45.5, 46.0, 46.5, 47.0, 47.5, 48.0, 48.5, 50.0,
    50.5, 51.0, 51.5, 52.0, 52.5, 53.0, 53.5, 55.0, 55.5, 56.0, 56.5, 57.0, 57.5, 58.0, 58.5, 60.0,
    ];
  
  final List<double> valuesShortBreak = [
    0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7, 7.5, 8, 8.5, 10.0,
    10.5, 11.0, 11.5, 12.0, 12.5, 13.0, 13.5, 15.0, 15.5, 16.0, 16.5, 17.0, 17.5, 18.0, 18.5, 20.0,
    20.5, 21.0, 21.5, 22.0, 22.5, 23.0, 23.5, 25.0, 25.5, 26.0, 26.5, 27.0, 27.5, 28.0, 28.5, 30.0,
    30.5, 31.0, 31.5, 32.0, 32.5, 33.0, 33.5, 35.0, 35.5, 36.0, 36.5, 37.0, 37.5, 38.0, 38.5, 40.0,
    40.5, 41.0, 41.5, 42.0, 42.5, 43.0, 43.5, 45.0, 45.5, 46.0, 46.5, 47.0, 47.5, 48.0, 48.5, 50.0,
    50.5, 51.0, 51.5, 52.0, 52.5, 53.0, 53.5, 55.0, 55.5, 56.0, 56.5, 57.0, 57.5, 58.0, 58.5, 60.0,
    ];

  final List<double> valuesLongBreak = [
    0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7, 7.5, 8, 8.5, 10.0,
    10.5, 11.0, 11.5, 12.0, 12.5, 13.0, 13.5, 15.0, 15.5, 16.0, 16.5, 17.0, 17.5, 18.0, 18.5, 20.0,
    20.5, 21.0, 21.5, 22.0, 22.5, 23.0, 23.5, 25.0, 25.5, 26.0, 26.5, 27.0, 27.5, 28.0, 28.5, 30.0,
    30.5, 31.0, 31.5, 32.0, 32.5, 33.0, 33.5, 35.0, 35.5, 36.0, 36.5, 37.0, 37.5, 38.0, 38.5, 40.0,
    40.5, 41.0, 41.5, 42.0, 42.5, 43.0, 43.5, 45.0, 45.5, 46.0, 46.5, 47.0, 47.5, 48.0, 48.5, 50.0,
    50.5, 51.0, 51.5, 52.0, 52.5, 53.0, 53.5, 55.0, 55.5, 56.0, 56.5, 57.0, 57.5, 58.0, 58.5, 60.0,
    ];

  // Lists for timer labels
  int selectedIndexPomodoro = 25;
  int selectedIndexShortBreak = 5;
  int selectedIndexLongBreak = 15;
  
  // Displays for timer labels
  String displayValuePomodoro = "25:00";
  String displayValueShortBreak = "5:00";
  String displayValueLongBreak = "15:00";


  // Displays the time remaining for Pomodoro Timer
  String get countTextPomodoro {
    Duration count = controllerPomodoro.duration! * controllerPomodoro.value;
    if (count.inMinutes == 0) {
      return controllerPomodoro.isDismissed
        ? '${(controllerPomodoro.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controllerPomodoro.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${((controllerPomodoro.duration!.inMinutes) % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
    } else {
      return controllerPomodoro.isDismissed
        ? '${(controllerPomodoro.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controllerPomodoro.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${((controllerPomodoro.duration!.inMinutes - 1) % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
    } 
  }

  // Displays the time remaining for Short Break Timer
  String get countTextShortBreak {
    Duration count =
        controllerShortBreak.duration! * controllerShortBreak.value;
    if (count.inMinutes == 0) {
      return controllerShortBreak.isDismissed
        ? '${(controllerShortBreak.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controllerShortBreak.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${((controllerShortBreak.duration!.inMinutes) % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
    } else {
      return controllerShortBreak.isDismissed
        ? '${(controllerShortBreak.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controllerShortBreak.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${((controllerShortBreak.duration!.inMinutes - 1) % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
    }
  }

  // Displays the time remaining for Long Break Timer
  String get countTextLongBreak {
    Duration count = controllerLongBreak.duration! * controllerLongBreak.value;
    if (count.inMinutes == 0) {
      return controllerLongBreak.isDismissed
        ? '${(controllerLongBreak.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controllerLongBreak.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${((controllerLongBreak.duration!.inMinutes) % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
    } else {
      return controllerLongBreak.isDismissed
        ? '${(controllerLongBreak.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controllerLongBreak.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${((controllerLongBreak.duration!.inMinutes - 1) % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
    }
  }

  // Progress Indicators for each timer
  double progressPomodoro = 1.0;
  double progressShortBreak = 1.0;
  double progressLongBreak = 1.0;

  // Timer frequency counter
  int pomodoroCount = 0;

  @override
  void initState() {
    super.initState();

    controllerPomodoro = AnimationController(
      vsync: this,
      duration: Duration(minutes: 25), // Default Pomodoro Timer Duration
    );

    controllerPomodoro.addListener(() {
      if (controllerPomodoro.isAnimating) {
        // If the timer is running
        setState(() {
          progressPomodoro =
              controllerPomodoro.value; // Updates Progress Indicator
        });
      } else {
        // If the timer is not running
        setState(() {
          progressPomodoro = 1.0; // Resets Progress Indicator
          isPlayingPomodoro = false;
        });
      }
    });

    controllerShortBreak = AnimationController(
      vsync: this,
      duration: Duration(minutes: 5), // Default Short Break Timer Duration
    );

    controllerShortBreak.addListener(() {
      if (controllerShortBreak.isAnimating) {
        // If the timer is running
        setState(() {
          progressShortBreak =
              controllerShortBreak.value; // Updates Progress Indicator
        });
      } else {
        setState(() {
          progressShortBreak = 1.0; // Resets Progress Indicator
          isPlayingShortBreak = false;
        });
      }
    });

    controllerLongBreak = AnimationController(
      vsync: this,
      duration: Duration(minutes: 15), // Default Long Break Timer Duration
    );

    controllerLongBreak.addListener(() {
      if (controllerLongBreak.isAnimating) {
        // If the timer is running
        setState(() {
          progressLongBreak =
              controllerLongBreak.value; // Updates Progress Indicator
        });
      } else {
        // If the timer is not running
        setState(() {
          progressLongBreak = 1.0; // Resets Progress Indicator
          isPlayingLongBreak = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controllerPomodoro.dispose();
    controllerShortBreak.dispose();
    controllerLongBreak.dispose();
    super.dispose();
  }
  
  void toBreak() {
    if (autoTransition) {
      controllerPomodoro.addListener(() {
        if (controllerPomodoro.isDismissed) {
          pomodoroCount++; // Increments the Pomodoro Counter
          // If the timer is finished
          if (pomodoroCount==4) {
            setState(() {
            _tabController.animateTo(2); // Switches to Long Break Tab
            pomodoroCount = 0; // Resets the Pomodoro Counter 
          });
          } else {
            setState(() {
            _tabController.animateTo(1); // Switches to Short Break Tab
          });
          }
        }
      });
    }
  }

  void toPomodoro() {
    if (autoTransition) {
      controllerShortBreak.addListener(() {
        if (controllerShortBreak.isDismissed) {
          setState(() {
            _tabController.animateTo(0); // Switches to Pomodoro Tab
          });
        }
      });
      controllerLongBreak.addListener(() {
        if (controllerLongBreak.isDismissed) {
          setState(() {
            _tabController.animateTo(0); // Switches to Pomodoro Tab
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 37, 84),
      body: Stack(
        children: <Widget>[
          Container(
            height: 200,
            child: AppBar(
              title: Text(widget.title),
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20))),
              backgroundColor: const Color.fromARGB(255, 255, 0, 153),
              flexibleSpace: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: const Text(''),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'lib/icons/tomato_icon.png',
                      color: Colors.white,
                      scale: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 130, left: 15, right: 15),
            child: Column(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.zero,
                  color: const Color.fromARGB(255, 44, 47, 93),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20 ,right: 90),
                      child: TabBar(
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        controller: _tabController,
                        indicatorColor: const Color.fromARGB(0, 255, 0, 153),
                        tabs: [
                          Tab(
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              child: Text(
                                "POMODORO",
                                style: TextStyle(
                                    fontFamily: "SF Pro Text",
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "SHORT BREAK",
                              style: TextStyle(
                                  fontFamily: "SF Pro Text",
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "LONG BREAK",
                              style: TextStyle(
                                  fontFamily: "SF Pro Text",
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    margin: const EdgeInsets.only(
                        top: 0, bottom: 300, left: 0, right: 0),
                    color: const Color.fromARGB(255, 44, 47, 93),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: TabBarView(
                      controller: _tabController,
                      //physics: NeverScrollableScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 180,
                                    height: 180,
                                    child: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationY(math.pi),
                                      child: CircularProgressIndicator(
                                        value: progressPomodoro,
                                        color: const Color.fromARGB(
                                            255, 241, 87, 255),
                                        backgroundColor: const Color.fromARGB(
                                            69, 158, 158, 158),
                                        strokeWidth: 5,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: AnimatedBuilder(
                                      animation: controllerPomodoro,
                                      builder: (context, child) => Text(
                                        countTextPomodoro,
                                        style: const TextStyle(
                                            fontFamily: 'Google Sans',
                                            fontSize: 33,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 30),
                              width: 200,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controllerPomodoro.reset();
                                        setState(() {
                                          isPlayingPomodoro = false;
                                        });
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: const Color.fromARGB(
                                            255, 73, 75, 122),
                                        child: Image.asset(
                                          'lib/icons/reset_icon.png',
                                          color: Colors.white,
                                          scale: 5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (controllerPomodoro.isAnimating) {
                                          controllerPomodoro.stop();
                                          setState(() {
                                            isPlayingPomodoro = false;
                                          });
                                        } else {
                                          controllerPomodoro.reverse(
                                              from: controllerPomodoro.value ==
                                                      0.0
                                                  ? 1.0
                                                  : controllerPomodoro.value);
                                          setState(() {
                                            isPlayingPomodoro = true;
                                          });
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 25,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: List<Color>.from([
                                                const Color.fromARGB(
                                                    255, 255, 0, 255),
                                                const Color.fromARGB(
                                                    255, 255, 43, 121),
                                              ]),
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              transform:
                                                  const GradientRotation(0.402),
                                            ),
                                          ),
                                          child: isPlayingPomodoro == true
                                              ? Image.asset(
                                                  "lib/icons/pause_icon.png")
                                              : Image.asset(
                                                  "lib/icons/play_icon.png",
                                                  scale: 1,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        if (controllerPomodoro.isDismissed) {
                                          showModalBottomSheet(
                                            backgroundColor: Color.fromARGB(255, 35, 37, 84),
                                            context: context,
                                            builder: (context) => Container(
                                              height: 325,
                                              child: Column(
                                                children: [
                                                  Text(''),
                                                  Row(children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 70),
                                                      child: Align(
                                                        alignment: Alignment.topCenter,
                                                        child: Text("Auto-transition timer",
                                                            style: TextStyle(
                                                                fontFamily: "Google Sans",
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white)),
                                                      ),
                                                    ),
                                                    SizedBox(width: 20),
                                                    IosSwitch(
                                                      isActive: autoTransition,
                                                      disableBackgroundColor: Color.fromARGB(255, 99, 120, 255),
                                                      activeBackgroundColor: Color.fromARGB(255, 48, 96, 255),
                                                      size: 30,
                                                      onChanged: (autoTransition) {
                                                        setState(() => this.autoTransition = autoTransition);
                                                      },
                                                    ),
                                                  ],),
                                                  Text(''),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 22.5),
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text("Pomodoro",
                                                          style: TextStyle(
                                                              fontFamily: "Google Sans",
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white)),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      StatefulBuilder(
                                                        builder: (context, state) {
                                                          return Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 280,
                                                                child: SliderTheme(
                                                                  data: SliderThemeData(
                                                                    activeTrackColor: Color.fromARGB(255, 49, 49, 91),
                                                                    inactiveTrackColor: Colors.transparent,
                                                                    activeTickMarkColor: Color.fromARGB(255, 49, 49, 91),
                                                                    inactiveTickMarkColor: Color.fromARGB(255, 49, 49, 91),
                                                                    overlayColor: Color.fromARGB(255, 49, 49, 91),
                                                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                                                                  ),
                                                                  child: Slider(
                                                                    activeColor: Color.fromARGB(255, 109, 138, 255),
                                                                    inactiveColor: Color.fromARGB(255, 49, 49, 91),
                                                                    value: selectedIndexPomodoro.toDouble(),
                                                                    label: incrementsPomodoro[double.parse(valuesPomodoro[selectedIndexPomodoro].toStringAsFixed(2))],
                                                                    min: 0,
                                                                    max: valuesPomodoro.length - 1,
                                                                    divisions: valuesPomodoro.length - 1,
                                                                    onChanged: (double value) {
                                                                      state((){
                                                                        selectedIndexPomodoro = value.toInt();
                                                                        displayValuePomodoro = incrementsPomodoro[double.parse(valuesPomodoro[selectedIndexPomodoro].toStringAsFixed(2))];
                                                                      });
                                                                    },
                                                                      ),
                                                                ),
                                                              ),
                                                              // ignore: unnecessary_string_interpolations
                                                          Text("${displayValuePomodoro.split(":")[0]}:${displayValuePomodoro.split(":")[1]}", style: const TextStyle(fontFamily: 'Google Sans', fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(232, 109, 138, 255))),
                                                            ],
                                                          );
                                                        }
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 22.5),
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text("Short Break",
                                                          style: TextStyle(
                                                              fontFamily: "Google Sans",
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white)),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        child: StatefulBuilder(
                                                          builder: (context, state) {
                                                            return Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 280,
                                                                child: SliderTheme(
                                                                  data: SliderThemeData(
                                                                    activeTrackColor: Color.fromARGB(255, 49, 49, 91),
                                                                    inactiveTrackColor: Colors.transparent,
                                                                    activeTickMarkColor: Color.fromARGB(255, 49, 49, 91),
                                                                    inactiveTickMarkColor: Color.fromARGB(255, 49, 49, 91),
                                                                    overlayColor: Color.fromARGB(255, 49, 49, 91),
                                                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                                                                  ),
                                                                  child: Slider(
                                                                    activeColor: Color.fromARGB(255, 109, 138, 255),
                                                                    inactiveColor: Color.fromARGB(255, 49, 49, 91),
                                                                    value: selectedIndexShortBreak.toDouble(),
                                                                    label: incrementsShortBreak[double.parse(valuesShortBreak[selectedIndexShortBreak].toStringAsFixed(2))],
                                                                    min: 0,
                                                                    max: valuesShortBreak.length - 1,
                                                                    divisions: valuesShortBreak.length - 1,
                                                                    onChanged: (double value) {
                                                                      
                                                                      state((){
                                                                        selectedIndexShortBreak = value.toInt();
                                                                        displayValueShortBreak = incrementsShortBreak[double.parse(valuesShortBreak[selectedIndexShortBreak].toStringAsFixed(2))];
                                                                      });
                                                                    },
                                                                      ),
                                                                ),
                                                              ),
                                                              // ignore: unnecessary_string_interpolations
                                                              Text("${displayValueShortBreak.split(":")[0]}:${displayValueShortBreak.split(":")[1]}", style: const TextStyle(fontFamily: 'Google Sans', fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(232, 109, 138, 255))),                                                            ],
                                                          );
                                                        }
                                                        ),
                                                      ),
                                                          //Text("${_currentSliderValue.toStringAsFixed(2)}", style: const TextStyle(fontFamily: 'Google Sans', fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(232, 109, 138, 255))),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 22.5),
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text("Long Break",
                                                          style: TextStyle(
                                                              fontFamily: "Google Sans",
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white)),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        child: SliderTheme(
                                                          data: SliderThemeData(
                                                            overlayColor: Colors.transparent,
                                                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                                                              ),
                                                          child: StatefulBuilder(
                                                            builder: (context, state) {
                                                              return Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 280,
                                                                child: SliderTheme(
                                                                  data: SliderThemeData(
                                                                    activeTrackColor: Color.fromARGB(255, 49, 49, 91),
                                                                    inactiveTrackColor: Colors.transparent,
                                                                    activeTickMarkColor: Color.fromARGB(255, 49, 49, 91),
                                                                    inactiveTickMarkColor: Color.fromARGB(255, 49, 49, 91),
                                                                    overlayColor: Color.fromARGB(255, 49, 49, 91),
                                                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                                                                  ),
                                                                  child: Slider(
                                                                    activeColor: Color.fromARGB(255, 109, 138, 255),
                                                                    inactiveColor: Color.fromARGB(255, 49, 49, 91),
                                                                    value: selectedIndexLongBreak.toDouble(),
                                                                    label: incrementsLongBreak[double.parse(valuesLongBreak[selectedIndexLongBreak].toStringAsFixed(2))],
                                                                    min: 0,
                                                                    max: valuesLongBreak.length - 1,
                                                                    divisions: valuesLongBreak.length - 1,
                                                                    onChanged: (double value) {
                                                                      
                                                                      state((){
                                                                        selectedIndexLongBreak = value.toInt();
                                                                        displayValueLongBreak = incrementsLongBreak[double.parse(valuesLongBreak[selectedIndexLongBreak].toStringAsFixed(2))];
                                                                      });
                                                                    },
                                                                      ),
                                                                ),
                                                              ),
                                                          Text("${displayValueLongBreak.split(":")[0]}:${displayValueLongBreak.split(":")[1]}", style: const TextStyle(fontFamily: 'Google Sans', fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(232, 109, 138, 255))),
                                                            ],
                                                          );
                                                        }
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 100),
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 70,
                                                              child: OutlinedButton(  
                                                                style: OutlinedButton.styleFrom(side: BorderSide(width: 1.0, color: Color.fromARGB(255, 99, 120, 255), style: BorderStyle.solid,),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),),
                                                                child: Text("Cancel", style: TextStyle(fontFamily: "Google Sans", fontSize: 11, fontWeight: FontWeight.bold, color: Color.fromARGB(250, 109, 138, 255)),),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                }
                                                                ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            SizedBox(
                                                              width: 70,
                                                              child: RawMaterialButton(
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                                fillColor: Color.fromARGB(255, 109, 138, 255),
                                                                child: Text("Save", style: TextStyle(fontFamily: "Google Sans", fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                  setState(() {
                                                                    controllerPomodoro.duration = Duration(minutes: int.parse(incrementsPomodoro[valuesPomodoro[selectedIndexPomodoro]].split(':')[0]), seconds: int.parse(incrementsPomodoro[valuesPomodoro[selectedIndexPomodoro]].split(':')[1]));
                                                                    controllerShortBreak.duration = Duration(minutes: int.parse(incrementsShortBreak[valuesShortBreak[selectedIndexShortBreak]].split(':')[0]), seconds: int.parse(incrementsShortBreak[valuesShortBreak[selectedIndexShortBreak]].split(':')[1]));
                                                                    controllerLongBreak.duration = Duration(minutes: int.parse(incrementsLongBreak[valuesLongBreak[selectedIndexLongBreak]].split(':')[0]), seconds: int.parse(incrementsLongBreak[valuesLongBreak[selectedIndexLongBreak]].split(':')[1]));
                                                                    if (autoTransition) {
                                                                      toPomodoro();
                                                                      toBreak();

                                                                    }
                                                                  },);
                                                                }
                                                                ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      // onPressed: () {},
                                      shape: const CircleBorder(),
                                      fillColor: const Color.fromARGB(
                                          255, 73, 75, 122),
                                      child: Image.asset(
                                        'lib/icons/edit_icon.png',
                                        color: Colors.white,
                                        scale: 4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 180,
                                    height: 180,
                                    child: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationY(math.pi),
                                      child: CircularProgressIndicator(
                                        value: progressShortBreak,
                                        color: const Color.fromARGB(
                                            255, 241, 87, 255),
                                        backgroundColor: const Color.fromARGB(
                                            69, 158, 158, 158),
                                        strokeWidth: 5,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: AnimatedBuilder(
                                      animation: controllerShortBreak,
                                      builder: (context, child) => Text(
                                        countTextShortBreak,
                                        style: const TextStyle(
                                            fontFamily: 'Google Sans',
                                            fontSize: 33,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 30),
                              width: 200,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controllerShortBreak.reset();
                                        setState(() {
                                          isPlayingShortBreak = false;
                                        });
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: const Color.fromARGB(
                                            255, 73, 75, 122),
                                        child: Image.asset(
                                          'lib/icons/reset_icon.png',
                                          color: Colors.white,
                                          scale: 5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (controllerShortBreak.isAnimating) {
                                          controllerShortBreak.stop();
                                          setState(() {
                                            isPlayingShortBreak = false;
                                          });
                                        } else {
                                          controllerShortBreak.reverse(
                                              from: controllerShortBreak
                                                          .value ==
                                                      0.0
                                                  ? 1.0
                                                  : controllerShortBreak.value);
                                          setState(() {
                                            isPlayingShortBreak = true;
                                          });
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 25,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: List<Color>.from([
                                                const Color.fromARGB(
                                                    255, 255, 0, 255),
                                                const Color.fromARGB(
                                                    255, 255, 43, 121),
                                              ]),
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              transform:
                                                  const GradientRotation(0.402),
                                            ),
                                          ),
                                          child: isPlayingShortBreak == true
                                              ? Image.asset(
                                                  "lib/icons/pause_icon.png")
                                              : Image.asset(
                                                  "lib/icons/play_icon.png",
                                                  scale: 1,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        if (controllerShortBreak.isDismissed) {
                                          showModalBottomSheet(
                                            backgroundColor: Color.fromARGB(255, 35, 37, 84),
                                            context: context,
                                            builder: (context) => Container(
                                              height: 325,
                                              child: Column(
                                                children: [
                                                  Text(''),
                                                  Row(children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 70),
                                                      child: Align(
                                                        alignment: Alignment.topCenter,
                                                        child: Text("Auto-transition timer",
                                                            style: TextStyle(
                                                                fontFamily: "Google Sans",
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white)),
                                                      ),
                                                    ),
                                                    SizedBox(width: 20),
                                                    IosSwitch(
                                                      isActive: autoTransition,
                                                      disableBackgroundColor: Color.fromARGB(255, 99, 120, 255),
                                                      activeBackgroundColor: Color.fromARGB(255, 48, 96, 255),
                                                      size: 30,
                                                      onChanged: (autoTransition) {
                                                        setState(() => this.autoTransition = autoTransition);
                                                      },
                                                    ),
                                                  ],),
                                                  Text(''),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 22.5),
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text("Pomodoro",
                                                          style: TextStyle(
                                                              fontFamily: "Google Sans",
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white)),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      StatefulBuilder(
                                                        builder: (context, state) {
                                                          return Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 280,
                                                                child: SliderTheme(
                                                                  data: SliderThemeData(
                                                                    activeTrackColor: Color.fromARGB(255, 49, 49, 91),
                                                                    inactiveTrackColor: Colors.transparent,
                                                                    activeTickMarkColor: Color.fromARGB(255, 49, 49, 91),
                                                                    inactiveTickMarkColor: Color.fromARGB(255, 49, 49, 91),
                                                                    overlayColor: Color.fromARGB(255, 49, 49, 91),
                                                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                                                                  ),
                                                                  child: Slider(
                                                                    activeColor: Color.fromARGB(255, 109, 138, 255),
                                                                    inactiveColor: Color.fromARGB(255, 49, 49, 91),
                                                                    value: selectedIndexPomodoro.toDouble(),
                                                                    label: incrementsPomodoro[double.parse(valuesPomodoro[selectedIndexPomodoro].toStringAsFixed(2))],
                                                                    min: 0,
                                                                    max: valuesPomodoro.length - 1,
                                                                    divisions: valuesPomodoro.length - 1,
                                                                    onChanged: (double value) {
                                                                      state((){
                                                                        selectedIndexPomodoro = value.toInt();
                                                                        displayValuePomodoro = incrementsPomodoro[double.parse(valuesPomodoro[selectedIndexPomodoro].toStringAsFixed(2))];
                                                                      });
                                                                    },
                                                                      ),
                                                                ),
                                                              ),
                                                              // ignore: unnecessary_string_interpolations
                                                          Text("${displayValuePomodoro.split(":")[0]}:${displayValuePomodoro.split(":")[1]}", style: const TextStyle(fontFamily: 'Google Sans', fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(232, 109, 138, 255))),
                                                            ],
                                                          );
                                                        }
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 22.5),
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text("Short Break",
                                                          style: TextStyle(
                                                              fontFamily: "Google Sans",
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white)),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        child: StatefulBuilder(
                                                          builder: (context, state) {
                                                            return Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 280,
                                                                child: SliderTheme(
                                                                  data: SliderThemeData(
                                                                    activeTrackColor: Color.fromARGB(255, 49, 49, 91),
                                                                    inactiveTrackColor: Colors.transparent,
                                                                    activeTickMarkColor: Color.fromARGB(255, 49, 49, 91),
                                                                    inactiveTickMarkColor: Color.fromARGB(255, 49, 49, 91),
                                                                    overlayColor: Color.fromARGB(255, 49, 49, 91),
                                                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                                                                  ),
                                                                  child: Slider(
                                                                    activeColor: Color.fromARGB(255, 109, 138, 255),
                                                                    inactiveColor: Color.fromARGB(255, 49, 49, 91),
                                                                    value: selectedIndexShortBreak.toDouble(),
                                                                    label: incrementsShortBreak[double.parse(valuesShortBreak[selectedIndexShortBreak].toStringAsFixed(2))],
                                                                    min: 0,
                                                                    max: valuesShortBreak.length - 1,
                                                                    divisions: valuesShortBreak.length - 1,
                                                                    onChanged: (double value) {
                                                                      
                                                                      state((){
                                                                        selectedIndexShortBreak = value.toInt();
                                                                        displayValueShortBreak = incrementsShortBreak[double.parse(valuesShortBreak[selectedIndexShortBreak].toStringAsFixed(2))];
                                                                      });
                                                                    },
                                                                      ),
                                                                ),
                                                              ),
                                                              // ignore: unnecessary_string_interpolations
                                                              Text("${displayValueShortBreak.split(":")[0]}:${displayValueShortBreak.split(":")[1]}", style: const TextStyle(fontFamily: 'Google Sans', fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(232, 109, 138, 255))),                                                            ],
                                                          );
                                                        }
                                                        ),
                                                      ),
                                                          //Text("${_currentSliderValue.toStringAsFixed(2)}", style: const TextStyle(fontFamily: 'Google Sans', fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(232, 109, 138, 255))),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 22.5),
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text("Long Break",
                                                          style: TextStyle(
                                                              fontFamily: "Google Sans",
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white)),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        child: SliderTheme(
                                                          data: SliderThemeData(
                                                            overlayColor: Colors.transparent,
                                                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                                                              ),
                                                          child: StatefulBuilder(
                                                            builder: (context, state) {
                                                              return Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 280,
                                                                child: SliderTheme(
                                                                  data: SliderThemeData(
                                                                    activeTrackColor: Color.fromARGB(255, 49, 49, 91),
                                                                    inactiveTrackColor: Colors.transparent,
                                                                    activeTickMarkColor: Color.fromARGB(255, 49, 49, 91),
                                                                    inactiveTickMarkColor: Color.fromARGB(255, 49, 49, 91),
                                                                    overlayColor: Color.fromARGB(255, 49, 49, 91),
                                                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                                                                  ),
                                                                  child: Slider(
                                                                    activeColor: Color.fromARGB(255, 109, 138, 255),
                                                                    inactiveColor: Color.fromARGB(255, 49, 49, 91),
                                                                    value: selectedIndexLongBreak.toDouble(),
                                                                    label: incrementsLongBreak[double.parse(valuesLongBreak[selectedIndexLongBreak].toStringAsFixed(2))],
                                                                    min: 0,
                                                                    max: valuesLongBreak.length - 1,
                                                                    divisions: valuesLongBreak.length - 1,
                                                                    onChanged: (double value) {
                                                                      
                                                                      state((){
                                                                        selectedIndexLongBreak = value.toInt();
                                                                        displayValueLongBreak = incrementsLongBreak[double.parse(valuesLongBreak[selectedIndexLongBreak].toStringAsFixed(2))];
                                                                      });
                                                                    },
                                                                      ),
                                                                ),
                                                              ),
                                                          Text("${displayValueLongBreak.split(":")[0]}:${displayValueLongBreak.split(":")[1]}", style: const TextStyle(fontFamily: 'Google Sans', fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(232, 109, 138, 255))),
                                                            ],
                                                          );
                                                        }
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 100),
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 70,
                                                              child: OutlinedButton(  
                                                                style: OutlinedButton.styleFrom(side: BorderSide(width: 1.0, color: Color.fromARGB(255, 99, 120, 255), style: BorderStyle.solid,),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),),
                                                                child: Text("Cancel", style: TextStyle(fontFamily: "Google Sans", fontSize: 11, fontWeight: FontWeight.bold, color: Color.fromARGB(250, 109, 138, 255)),),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                }
                                                                ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            SizedBox(
                                                              width: 70,
                                                              child: RawMaterialButton(
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                                fillColor: Color.fromARGB(255, 109, 138, 255),
                                                                child: Text("Save", style: TextStyle(fontFamily: "Google Sans", fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                  setState(() {
                                                                    controllerPomodoro.duration = Duration(minutes: int.parse(incrementsPomodoro[valuesPomodoro[selectedIndexPomodoro]].split(':')[0]), seconds: int.parse(incrementsPomodoro[valuesPomodoro[selectedIndexPomodoro]].split(':')[1]));
                                                                    controllerShortBreak.duration = Duration(minutes: int.parse(incrementsShortBreak[valuesShortBreak[selectedIndexShortBreak]].split(':')[0]), seconds: int.parse(incrementsShortBreak[valuesShortBreak[selectedIndexShortBreak]].split(':')[1]));
                                                                    controllerLongBreak.duration = Duration(minutes: int.parse(incrementsLongBreak[valuesLongBreak[selectedIndexLongBreak]].split(':')[0]), seconds: int.parse(incrementsLongBreak[valuesLongBreak[selectedIndexLongBreak]].split(':')[1]));
                                                                    if (autoTransition) {
                                                                      toPomodoro();
                                                                      toBreak();

                                                                    }
                                                                  },);
                                                                }
                                                                ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      shape: const CircleBorder(),
                                      fillColor: const Color.fromARGB(
                                          255, 73, 75, 122),
                                      child: Image.asset(
                                        'lib/icons/edit_icon.png',
                                        color: Colors.white,
                                        scale: 4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 180,
                                    height: 180,
                                    child: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationY(math.pi),
                                      child: CircularProgressIndicator(
                                        value: progressLongBreak,
                                        color: const Color.fromARGB(
                                            255, 241, 87, 255),
                                        backgroundColor: const Color.fromARGB(
                                            69, 158, 158, 158),
                                        strokeWidth: 5,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: AnimatedBuilder(
                                      animation: controllerLongBreak,
                                      builder: (context, child) => Text(
                                        countTextLongBreak,
                                        style: const TextStyle(
                                            fontFamily: 'Google Sans',
                                            fontSize: 33,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 30),
                              width: 200,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controllerLongBreak.reset();
                                        setState(() {
                                          isPlayingLongBreak = false;
                                        });
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: const Color.fromARGB(
                                            255, 73, 75, 122),
                                        child: Image.asset(
                                          'lib/icons/reset_icon.png',
                                          color: Colors.white,
                                          scale: 5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (controllerLongBreak.isAnimating) {
                                          controllerLongBreak.stop();
                                          setState(() {
                                            isPlayingLongBreak = false;
                                          });
                                        } else {
                                          controllerLongBreak.reverse(
                                              from: controllerLongBreak.value ==
                                                      0.0
                                                  ? 1.0
                                                  : controllerLongBreak.value);
                                          setState(() {
                                            isPlayingLongBreak = true;
                                          });
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 25,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: List<Color>.from([
                                                const Color.fromARGB(
                                                    255, 255, 0, 255),
                                                const Color.fromARGB(
                                                    255, 255, 43, 121),
                                              ]),
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              transform:
                                                  const GradientRotation(0.402),
                                            ),
                                          ),
                                          child: isPlayingLongBreak == true
                                              ? Image.asset(
                                                  "lib/icons/pause_icon.png")
                                              : Image.asset(
                                                  "lib/icons/play_icon.png",
                                                  scale: 1,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        if (controllerLongBreak.isDismissed) {
                                          showModalBottomSheet(
                                            backgroundColor: Color.fromARGB(255, 35, 37, 84),
                                            context: context,
                                            builder: (context) => Container(
                                              height: 325,
                                              child: Column(
                                                children: [
                                                  Text(''),
                                                  Row(children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 70),
                                                      child: Align(
                                                        alignment: Alignment.topCenter,
                                                        child: Text("Auto-transition timer",
                                                            style: TextStyle(
                                                                fontFamily: "Google Sans",
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white)),
                                                      ),
                                                    ),
                                                    SizedBox(width: 20),
                                                    IosSwitch(
                                                      isActive: autoTransition,
                                                      disableBackgroundColor: Color.fromARGB(255, 99, 120, 255),
                                                      activeBackgroundColor: Color.fromARGB(255, 48, 96, 255),
                                                      size: 30,
                                                      onChanged: (autoTransition) {
                                                        setState(() => this.autoTransition = autoTransition);
                                                      },
                                                    ),
                                                  ],),
                                                  Text(''),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 22.5),
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text("Pomodoro",
                                                          style: TextStyle(
                                                              fontFamily: "Google Sans",
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white)),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      StatefulBuilder(
                                                        builder: (context, state) {
                                                          return Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 280,
                                                                child: SliderTheme(
                                                                  data: SliderThemeData(
                                                                    activeTrackColor: Color.fromARGB(255, 49, 49, 91),
                                                                    inactiveTrackColor: Colors.transparent,
                                                                    activeTickMarkColor: Color.fromARGB(255, 49, 49, 91),
                                                                    inactiveTickMarkColor: Color.fromARGB(255, 49, 49, 91),
                                                                    overlayColor: Color.fromARGB(255, 49, 49, 91),
                                                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                                                                  ),
                                                                  child: Slider(
                                                                    activeColor: Color.fromARGB(255, 109, 138, 255),
                                                                    inactiveColor: Color.fromARGB(255, 49, 49, 91),
                                                                    value: selectedIndexPomodoro.toDouble(),
                                                                    label: incrementsPomodoro[double.parse(valuesPomodoro[selectedIndexPomodoro].toStringAsFixed(2))],
                                                                    min: 0,
                                                                    max: valuesPomodoro.length - 1,
                                                                    divisions: valuesPomodoro.length - 1,
                                                                    onChanged: (double value) {
                                                                      state((){
                                                                        selectedIndexPomodoro = value.toInt();
                                                                        displayValuePomodoro = incrementsPomodoro[double.parse(valuesPomodoro[selectedIndexPomodoro].toStringAsFixed(2))];
                                                                      });
                                                                    },
                                                                      ),
                                                                ),
                                                              ),
                                                              // ignore: unnecessary_string_interpolations
                                                          Text("${displayValuePomodoro.split(":")[0]}:${displayValuePomodoro.split(":")[1]}", style: const TextStyle(fontFamily: 'Google Sans', fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(232, 109, 138, 255))),
                                                            ],
                                                          );
                                                        }
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 22.5),
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text("Short Break",
                                                          style: TextStyle(
                                                              fontFamily: "Google Sans",
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white)),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        child: StatefulBuilder(
                                                          builder: (context, state) {
                                                            return Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 280,
                                                                child: SliderTheme(
                                                                  data: SliderThemeData(
                                                                    activeTrackColor: Color.fromARGB(255, 49, 49, 91),
                                                                    inactiveTrackColor: Colors.transparent,
                                                                    activeTickMarkColor: Color.fromARGB(255, 49, 49, 91),
                                                                    inactiveTickMarkColor: Color.fromARGB(255, 49, 49, 91),
                                                                    overlayColor: Color.fromARGB(255, 49, 49, 91),
                                                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                                                                  ),
                                                                  child: Slider(
                                                                    activeColor: Color.fromARGB(255, 109, 138, 255),
                                                                    inactiveColor: Color.fromARGB(255, 49, 49, 91),
                                                                    value: selectedIndexShortBreak.toDouble(),
                                                                    label: incrementsShortBreak[double.parse(valuesShortBreak[selectedIndexShortBreak].toStringAsFixed(2))],
                                                                    min: 0,
                                                                    max: valuesShortBreak.length - 1,
                                                                    divisions: valuesShortBreak.length - 1,
                                                                    onChanged: (double value) {
                                                                      
                                                                      state((){
                                                                        selectedIndexShortBreak = value.toInt();
                                                                        displayValueShortBreak = incrementsShortBreak[double.parse(valuesShortBreak[selectedIndexShortBreak].toStringAsFixed(2))];
                                                                      });
                                                                    },
                                                                      ),
                                                                ),
                                                              ),
                                                              // ignore: unnecessary_string_interpolations
                                                              Text("${displayValueShortBreak.split(":")[0]}:${displayValueShortBreak.split(":")[1]}", style: const TextStyle(fontFamily: 'Google Sans', fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(232, 109, 138, 255))),                                                            ],
                                                          );
                                                        }
                                                        ),
                                                      ),
                                                          //Text("${_currentSliderValue.toStringAsFixed(2)}", style: const TextStyle(fontFamily: 'Google Sans', fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(232, 109, 138, 255))),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 22.5),
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text("Long Break",
                                                          style: TextStyle(
                                                              fontFamily: "Google Sans",
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white)),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        child: SliderTheme(
                                                          data: SliderThemeData(
                                                            overlayColor: Colors.transparent,
                                                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                                                              ),
                                                          child: StatefulBuilder(
                                                            builder: (context, state) {
                                                              return Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 280,
                                                                child: SliderTheme(
                                                                  data: SliderThemeData(
                                                                    activeTrackColor: Color.fromARGB(255, 49, 49, 91),
                                                                    inactiveTrackColor: Colors.transparent,
                                                                    activeTickMarkColor: Color.fromARGB(255, 49, 49, 91),
                                                                    inactiveTickMarkColor: Color.fromARGB(255, 49, 49, 91),
                                                                    overlayColor: Color.fromARGB(255, 49, 49, 91),
                                                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                                                                  ),
                                                                  child: Slider(
                                                                    activeColor: Color.fromARGB(255, 109, 138, 255),
                                                                    inactiveColor: Color.fromARGB(255, 49, 49, 91),
                                                                    value: selectedIndexLongBreak.toDouble(),
                                                                    label: incrementsLongBreak[double.parse(valuesLongBreak[selectedIndexLongBreak].toStringAsFixed(2))],
                                                                    min: 0,
                                                                    max: valuesLongBreak.length - 1,
                                                                    divisions: valuesLongBreak.length - 1,
                                                                    onChanged: (double value) {
                                                                      
                                                                      state((){
                                                                        selectedIndexLongBreak = value.toInt();
                                                                        displayValueLongBreak = incrementsLongBreak[double.parse(valuesLongBreak[selectedIndexLongBreak].toStringAsFixed(2))];
                                                                      });
                                                                    },
                                                                      ),
                                                                ),
                                                              ),
                                                          Text("${displayValueLongBreak.split(":")[0]}:${displayValueLongBreak.split(":")[1]}", style: const TextStyle(fontFamily: 'Google Sans', fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(232, 109, 138, 255))),
                                                            ],
                                                          );
                                                        }
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 100),
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 70,
                                                              child: OutlinedButton(  
                                                                style: OutlinedButton.styleFrom(side: BorderSide(width: 1.0, color: Color.fromARGB(255, 99, 120, 255), style: BorderStyle.solid,),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),),
                                                                child: Text("Cancel", style: TextStyle(fontFamily: "Google Sans", fontSize: 11, fontWeight: FontWeight.bold, color: Color.fromARGB(250, 109, 138, 255)),),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                }
                                                                ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            SizedBox(
                                                              width: 70,
                                                              child: RawMaterialButton(
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                                fillColor: Color.fromARGB(255, 109, 138, 255),
                                                                child: Text("Save", style: TextStyle(fontFamily: "Google Sans", fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                  setState(() {
                                                                    controllerPomodoro.duration = Duration(minutes: int.parse(incrementsPomodoro[valuesPomodoro[selectedIndexPomodoro]].split(':')[0]), seconds: int.parse(incrementsPomodoro[valuesPomodoro[selectedIndexPomodoro]].split(':')[1]));
                                                                    controllerShortBreak.duration = Duration(minutes: int.parse(incrementsShortBreak[valuesShortBreak[selectedIndexShortBreak]].split(':')[0]), seconds: int.parse(incrementsShortBreak[valuesShortBreak[selectedIndexShortBreak]].split(':')[1]));
                                                                    controllerLongBreak.duration = Duration(minutes: int.parse(incrementsLongBreak[valuesLongBreak[selectedIndexLongBreak]].split(':')[0]), seconds: int.parse(incrementsLongBreak[valuesLongBreak[selectedIndexLongBreak]].split(':')[1]));
                                                                    if (autoTransition) {
                                                                      toPomodoro();
                                                                      toBreak();

                                                                    }
                                                                  },);
                                                                }
                                                                ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      shape: const CircleBorder(),
                                      fillColor: const Color.fromARGB(
                                          255, 73, 75, 122),
                                      child: Image.asset(
                                        'lib/icons/edit_icon.png',
                                        color: Colors.white,
                                        scale: 4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: GestureDetector(
          onTap: () {
            if (controllerPomodoro.isAnimating) {
              controllerPomodoro.stop();
              setState(() {
                isPlayingPomodoro = false;
              });
            }
            if (controllerShortBreak.isAnimating) {
              controllerShortBreak.stop();
              setState(() {
                isPlayingShortBreak = false;
              });
            }
            if (controllerLongBreak.isAnimating) {
              controllerLongBreak.stop();
              setState(() {
                isPlayingLongBreak = false;
              });
            } else {
              controllerPomodoro.reverse(
                  from: controllerPomodoro.value == 0.0
                      ? 1.0
                      : controllerPomodoro.value);
              controllerShortBreak.reverse(
                  from: controllerShortBreak.value == 0.0
                      ? 1.0
                      : controllerShortBreak.value);
              controllerLongBreak.reverse(
                  from: controllerLongBreak.value == 0.0
                      ? 1.0
                      : controllerLongBreak.value);
              setState(() {
                isPlayingPomodoro = true;
                isPlayingShortBreak = true;
                isPlayingLongBreak = true;
              });
            }
          },
          child: CircleAvatar(
            radius: 30,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: List<Color>.from([
                    const Color.fromARGB(255, 255, 0, 255),
                    const Color.fromARGB(255, 255, 43, 121),
                  ]),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  transform: const GradientRotation(0.402),
                ),
              ),
              child: isPlayingPomodoro == true
                  ? Image.asset(
                      "lib/icons/pause_icon.png",
                      scale: 1,
                    )
                  : Image.asset(
                      "lib/icons/play_icon.png",
                      scale: 1,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
