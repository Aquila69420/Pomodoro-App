import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]); // Displays System UI
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
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
  

  bool isPlayingPomodoro = false;
  bool isPlayingShortBreak = false;
  bool isPlayingLongBreak = false;
  
  bool terminatedPomodoro = false;
  bool terminatedShortBreak = false;
  bool terminatedLongBreak = false;
  
  bool autoTransition = false;

  

  // Displays the time remaining for Pomodoro Timer
  String get countTextPomodoro {
    Duration count = controllerPomodoro.duration! * controllerPomodoro.value;
    return controllerPomodoro.isDismissed
        ? '${(controllerPomodoro.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controllerPomodoro.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${((controllerPomodoro.duration!.inMinutes - 1) % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }


  // Progress Indicators for each timer
  double progressPomodoro = 1.0;

  Duration timerDurationPomodoro = Duration(minutes: 25);
  

  @override
  void initState() {
    super.initState();

    controllerPomodoro = AnimationController(
      vsync: this,
      // ignore: prefer_const_constructors
      duration: timerDurationPomodoro, // Default Pomodoro Timer Duration
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
          terminatedPomodoro = true;
          
          if (terminatedPomodoro == true) {
            timerDurationPomodoro = Duration(minutes: 5);
            terminatedShortBreak = true;
          }
          else if (terminatedShortBreak == true) {
            timerDurationPomodoro = Duration(minutes: 15);
          }
          else if (terminatedLongBreak == true) {
            timerDurationPomodoro = Duration(minutes: 25);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    controllerPomodoro.dispose();
    super.dispose();
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
                  child: Row(
                    children: [
                      Container(
                        child: Card(
                          color: Color.fromARGB(255, 44, 47, 93),
                          child: Text(
                            "POMODORO",
                            style: TextStyle(
                                fontFamily: "SF Pro Text",
                                fontSize: 10,
                                color: isPlayingPomodoro? Colors.white : Colors.grey,
                                fontWeight: isPlayingPomodoro
                                    ? FontWeight.bold
                                    : FontWeight.normal,),
                          ),
                        ),
                      ),
                      Container(
                        child: Card(
                          color: Color.fromARGB(255, 44, 47, 93),
                          child: Text(
                            "SHORT BREAK",
                            style: TextStyle(
                                fontFamily: "SF Pro Text",
                                fontSize: 10,
                                color: isPlayingShortBreak? Colors.white : Colors.grey,
                                fontWeight: isPlayingShortBreak
                                    ? FontWeight.bold
                                    : FontWeight.normal,),
                          ),
                        ),
                      ),
                      Container(
                        child: Card(
                          color: Color.fromARGB(255, 44, 47, 93),
                          child: Text(
                            "LONG BREAK",
                            style: TextStyle(
                                fontFamily: "SF Pro Text",
                                fontSize: 10,
                                color: isPlayingLongBreak? Colors.white : Colors.grey,
                                fontWeight: isPlayingLongBreak
                                    ? FontWeight.bold
                                    : FontWeight.normal,),
                          ),
                        ),
                      ),
                    ],
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
                                    width: 120,
                                    height: 120,
                                    child: CircularProgressIndicator(
                                      value: progressPomodoro,
                                      color: const Color.fromARGB(
                                          255, 241, 87, 255),
                                      backgroundColor: const Color.fromARGB(
                                          69, 158, 158, 158),
                                      strokeWidth: 5,
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
                                            context: context,
                                            builder: (context) => Container(
                                              height: 300,
                                              child: CupertinoTimerPicker(
                                                  initialTimerDuration:
                                                      controllerPomodoro
                                                          .duration!,
                                                  onTimerDurationChanged:
                                                      (time) {
                                                    setState(() {
                                                      controllerPomodoro
                                                          .duration = time;
                                                    });
                                                  }),
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
            else {
              controllerPomodoro.reverse(
                  from: controllerPomodoro.value == 0.0
                      ? 1.0
                      : controllerPomodoro.value);

              setState(() {
                isPlayingPomodoro = true;
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
