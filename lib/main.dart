import 'package:flutter/material.dart';
import 'widgets/button_widget.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Counter',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(title: 'Simple Counter Page'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const int maxSeconds = 60;
  int seconds = maxSeconds;
  Timer? timer;

  void startTimer({bool reset = true, String test = ""}) {
    if (reset) {
      resetTimer();
    }
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        stopTimer(reset: false);
      }
    });
  }

  void resetTimer() {
    setState(() {
      seconds = maxSeconds;
    });
  }

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }

    setState(() {
      timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.grey,
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTimer(),
                    const SizedBox(height: 80),
                    buildButtons()
                  ]),
            )));
  }

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = seconds == maxSeconds || seconds == 0;

    return isRunning || !isCompleted
        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ButtonWidget(
              text: isRunning ? "Pause" : "Resume",
              onClicked: () {
                if (isRunning) {
                  stopTimer(reset: false);
                } else {
                  startTimer(reset: false);
                }
              },
            ),
            const SizedBox(
              width: 16,
            ),
            ButtonWidget(
              text: "Cancel",
              onClicked: () {
                stopTimer();
              },
            ),
          ])
        : ButtonWidget(
            text: "Start Timer",
            color: Colors.black,
            backgroundColor: Colors.white,
            onClicked: () {
              startTimer();
            },
          );
  }

  Widget buildTimer() => SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: seconds / maxSeconds,
            color: Colors.black,
            valueColor: AlwaysStoppedAnimation(Colors.white),
            strokeWidth: 12,
            backgroundColor: Colors.greenAccent,
          ),
          Center(
            child: buildTime(),
          )
        ],
      ));

  Widget buildTime() {
    if (seconds == 0) {
      return Icon(
        Icons.done,
        color: Colors.greenAccent,
        size: 112,
      );
    } else {
      return Text(
        "$seconds",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 80,
        ),
      );
    }
  }
}
