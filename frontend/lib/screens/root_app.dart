//import 'package:frontend/controllers/courses/course_controller.dart';
import 'package:frontend/controllers/marketplace/courses/course_controller.dart';
import 'package:frontend/screens/favorites.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/screens/homescreens/MyCourses.dart';
import 'package:frontend/screens/my_courses.dart';
import 'package:frontend/widgets/bottombar_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/Screens/search.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);
  static const String routeName = "/root";

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBody() {
    return IndexedStack(
        index: activePageIndex,
        children:
            List.generate(tabItems.length, (index) => tabItems[index]["page"]));
  }

  List tabItems = [
    {"icon": "assets/icons/home.svg", "page": HomePage()},
    {"icon": "assets/icons/search.svg", "page": SearchPage()},
    {"icon": "assets/icons/play.svg", "page": MyCoursesPage()},
    {"icon": "assets/icons/heart.svg", "page": FavoritesPage()},
    {
      "icon": "assets/icons/profile.svg",
      "page": Container(
        child: Center(
          child: Text("Profile"),
        ),
      )
    }
  ];

  int activePageIndex = 0;
  Widget buildBottomBar() {
    return Container(
      width: double.infinity,
      height: 75,
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
      decoration: BoxDecoration(
          color: bottomBarColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
                color: shadowColor.withOpacity(.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(1, 1))
          ]),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
              tabItems.length,
              (index) => BottomBarItem(
                  icon: tabItems[index]["icon"],
                  isActive: activePageIndex == index,
                  onTap: () {
                    onPageIndexChanged(index);
                  }))),
    );
  }

  onPageIndexChanged(index) {
    setState(() {
      activePageIndex = index;
    });
  }
}
