//import 'package:frontend/controllers/courses/course_controller.dart';
import 'package:frontend/screens/account.dart';
import 'package:frontend/screens/favorites.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/screens/my_courses.dart';
import 'package:frontend/services/bottom_bar_provider.dart';
import 'package:frontend/widgets/bottombar_item.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/search.dart';
import 'package:provider/provider.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);
  static const String routeName = "/root";

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  bool isAccountPage = false;
  @override
  Widget build(BuildContext context) {
    final bottomBarProvider = Provider.of<BottomBarProvider>(context, listen: false);

    return Scaffold(
      body: Consumer<BottomBarProvider>(
        builder: (context, bottomBarProvider, child) {
          return bottomBarProvider.isTeacherMode
              ? buildBodyTeacherMode()
              : buildBody();
        },
      ),
      bottomNavigationBar: Consumer<BottomBarProvider>(
          builder: (context, bottomBarProvider, child) {
            return bottomBarProvider.isTeacherMode
              ?  buildTeacherBottomBar()
              : buildBottomBar();
          },
      ),
    );
  }

  Widget buildBody() {
    final bottomBarProvider = Provider.of<BottomBarProvider>(context, listen: false);
    return IndexedStack(
        //index: activePageIndex,
        index: bottomBarProvider.activePageIndex,
        children:
            List.generate(tabItems.length, (index) => tabItems[index]["page"]));
  }

  Widget buildBodyTeacherMode() {
    final bottomBarProvider = Provider.of<BottomBarProvider>(context, listen: false);
    return IndexedStack(
        //index: activePageIndex,
        index: bottomBarProvider.activePageIndex,
        children:
            List.generate(teacherTabItems.length, (index) => teacherTabItems[index]["page"]));
  }

  List tabItems = [
    {"icon": "assets/icons/home.svg", "page": HomePage()},
    {"icon": "assets/icons/search.svg", "page": SearchPage()},
    {"icon": "assets/icons/play.svg", "page": MyCoursesPage()},
    {"icon": "assets/icons/heart.svg", "page": FavoritesPage()},
    {"icon": "assets/icons/profile.svg", "page": AccountPage()}
  ];

  int activePageIndex = 0;
  Widget buildBottomBar() {
    final bottomBarProvider = Provider.of<BottomBarProvider>(context, listen: false);
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
                  isActive: bottomBarProvider.activePageIndex == index,
                  onTap: () {
                    onPageIndexChanged(index);
                  }))),
    );
  }

  List teacherTabItems = [
    {"icon": "assets/icons/home.svg", "page": Container(
      child: const Center(
        child: Text(
          "Teacher Dashboard"
        ),
      ),
    )},
    {"icon": "assets/icons/square-plus.svg", "page": Container(
      child: const Center(
        child: Text(
          "Add Course"
        ),
      ),
    )},
    {"icon": "assets/icons/profile.svg", "page": AccountPage()}
  ];

  Widget buildTeacherBottomBar() {
    final bottomBarProvider = Provider.of<BottomBarProvider>(context, listen: false);

    return Container(
      width: double.infinity,
      height: 75,
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
      decoration: BoxDecoration(
          color: bottomBarColor,
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
              teacherTabItems.length,
                  (index) => BottomBarItem(
                  icon: teacherTabItems[index]["icon"],
                  isActive: bottomBarProvider.activePageIndex == index,
                  onTap: () {
                    onPageIndexChanged(index);
                  }))),
    );
  }

  onPageIndexChanged(index) {
    final bottomBarProvider = Provider.of<BottomBarProvider>(context, listen: false);
    setState(() {
      if (index == 4) {
        isAccountPage = true;
      } else {
        isAccountPage = false;
      }
      bottomBarProvider.activePageIndex = index;
      //activePageIndex = index;
    });
  }
}
