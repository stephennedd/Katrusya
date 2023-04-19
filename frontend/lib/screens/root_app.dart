//import 'package:frontend/controllers/courses/course_controller.dart';
import 'package:frontend/screens/account.dart';
import 'package:frontend/screens/favorites.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/screens/my_courses.dart';
import 'package:frontend/screens/teacher_dashboard.dart';
import 'package:frontend/services/bottom_bar_provider.dart';
import 'package:frontend/widgets/bottombar_item.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/search.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/users/user_controller.dart';
import 'add_course.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);
  static const String routeName = "/root";

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  bool isAccountPage = false;
  UsersController usersController = Get.put(UsersController());

  @override
  Widget build(BuildContext context) {
    final bottomBarProvider =
        Provider.of<BottomBarProvider>(context, listen: false);

    return Scaffold(
      body: Consumer<BottomBarProvider>(
        builder: (context, bottomBarProvider, child) {
          return Obx(() => usersController.isUserTeacher()
              ? buildBodyTeacherMode()
              : buildBody());
        },
      ),
      bottomNavigationBar: Consumer<BottomBarProvider>(
        builder: (context, bottomBarProvider, child) {
          return Obx(() => usersController.isUserTeacher()
              ? buildTeacherBottomBar()
              : buildBottomBar());
        },
      ),
    );
  }

  Widget buildBody() {
    final bottomBarProvider =
        Provider.of<BottomBarProvider>(context, listen: false);
    return IndexedStack(
        //index: activePageIndex,
        index: bottomBarProvider.activePageIndex,
        children:
            List.generate(tabItems.length, (index) => tabItems[index]["page"]));
  }

  Widget buildBodyTeacherMode() {
    final bottomBarProvider =
        Provider.of<BottomBarProvider>(context, listen: false);
    return IndexedStack(
        //index: activePageIndex,
        index: bottomBarProvider.activePageIndex,
        children: List.generate(
            teacherTabItems.length, (index) => teacherTabItems[index]["page"]));
  }

  List tabItems = [
    {"icon": "assets/icons/home.svg", "page": const HomePage()},
    {"icon": "assets/icons/search.svg", "page": const SearchPage()},
    {"icon": "assets/icons/play.svg", "page": const MyCoursesPage()},
    {"icon": "assets/icons/heart.svg", "page": const FavoritesPage()},
    {"icon": "assets/icons/profile.svg", "page": const AccountPage()}
  ];

  int activePageIndex = 0;

  Widget buildBottomBar() {
    final bottomBarProvider =
        Provider.of<BottomBarProvider>(context, listen: false);
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
                  key: Key("bottomBarItem$index"),
                  icon: tabItems[index]["icon"],
                  isActive: bottomBarProvider.activePageIndex == index,
                  onTap: () {
                    onPageIndexChanged(index);
                  }))),
    );
  }

  List teacherTabItems = [
    {"icon": "assets/icons/home.svg", "page": const DashboardPage()},
    {"icon": "assets/icons/square-plus.svg", "page": const AddCoursePage()},
    {"icon": "assets/icons/profile.svg", "page": const AccountPage()}
  ];

  Widget buildTeacherBottomBar() {
    final bottomBarProvider =
        Provider.of<BottomBarProvider>(context, listen: false);

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
          ],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
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
    final bottomBarProvider =
        Provider.of<BottomBarProvider>(context, listen: false);
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
