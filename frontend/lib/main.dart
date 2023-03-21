import 'package:flutter/material.dart';
import 'package:frontend/Screens/homescreens/MyCourses.dart';
import 'package:frontend/Screens/landingPage.dart';
import 'package:frontend/Screens/questionsScreen.dart';
import 'package:frontend/Screens/quizScreen.dart';
import 'package:frontend/Screens/splashScreen.dart';
import 'package:frontend/Screens/testScreen.dart';
import 'package:frontend/Screens/watchCourseScreen.dart';
import 'package:frontend/bindings/initial_bindings.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:get/get.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //InitialBindings().dependencies();
  runApp(GetMaterialApp(
    getPages: AppRoutes.routes(),
    home: const MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const MyCourses()
        //const QuizScreen()
        //const TestScreen()
        //const QuizScreen()

        //const SplashScreen(),

        //const MyCourses()
        //WatchCourse(),
        //const SplashScreen(),
        );
  }
}
