import 'package:flutter/material.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/controllers/marketplace/courses/course_controller.dart';
import 'package:frontend/controllers/users/user_controller.dart';
import 'package:frontend/models/courses/course_model.dart';
import 'package:frontend/models/courses/my_course_model.dart';
import 'package:frontend/widgets/app_bar_box.dart';
import 'package:frontend/widgets/course_complete_item.dart';
import 'package:frontend/widgets/course_item.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import 'course_landing_page.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({Key? key}) : super(key: key);
  static const String routeName = "/my_courses";

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int incompleteCourses = 1;
  final int completeCourses = 2;

  UsersController usersController = Get.put(UsersController());
  CourseController courseController = Get.put(CourseController());
  final GetStorage _getStorage = GetStorage();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBarColor,
        appBar: MyAppBar(
          title: "My Courses",
          hasBackButton: false,
          centerTitle: false,
        ),
        body: buildBody());
  }

  Widget buildBody() {
    return Column(children: [Obx(() => getTabBar()), getTabBarPages()]);
  }

  Widget getTabBar() {
    //UsersController usersController = Get.put(UsersController());
    return Container(
        child: TabBar(
            indicatorWeight: 2,
            indicatorColor: primary,
            controller: _tabController,
            tabs: [
          Tab(
            child: Text(
              // Done: update with real number
              "Progress (${usersController.getNumberOfIncompleteByUserCourses()})",
              style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
          Tab(
            child: Text(
              // Done: update with real number
              "Completed (${usersController.getNumberOfCompleteByUserCourses()})",
              style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  overflow: TextOverflow.ellipsis),
            ),
          )
        ]));
  }

  Widget getTabBarPages() {
    var deviceDisplayHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      width: double.infinity,
      height: deviceDisplayHeight - 231,
      child: TabBarView(
        physics: const ScrollPhysics(),
        controller: _tabController,
        children: [
          Obx(() => getIncompleteCourses()),
          Obx(() => getCompleteCourses()),
        ],
      ),
    );
  }

  Widget getCompleteCourses() {
    final userCourses = usersController.userCourses;
    final completedByUserCourses = userCourses
        .where((userCourse) => userCourse.isComplete == true)
        .toList();

    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: completedByUserCourses.length,
        itemBuilder: (context, index) => CourseCompleteItem(
              data: completedByUserCourses[index],
              onTap: () async {
                // Done: navigate to course page
                CourseModel myCourse = courseController
                    .getMyCourse(completedByUserCourses[index].courseId)!;

                int myCourseId = myCourse.id;

                courseController.isCurrentCoursePurchased.value = true;

                await courseController.getCourseQuizzes(myCourseId);
                await courseController.getCourseDetails(myCourseId);
                courseController.currentCourseId.value = myCourseId;

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CourseLandingPage(
                          course: myCourse,
                        )));
              },
            ));
  }

  Widget getIncompleteCourses() {
    final userCourses = usersController.userCourses;
    final incompletedByUserCourses = userCourses
        .where((userCourse) => userCourse.isComplete == false)
        .toList();

    return ListView.builder(
        itemCount: incompletedByUserCourses.length,
        itemBuilder: (context, index) => CourseCompleteItem(
              data: incompletedByUserCourses[index],
              onTap: () async {
                CourseModel myCourse = courseController
                    .getMyCourse(incompletedByUserCourses[index].courseId)!;

                int myCourseId = myCourse.id;

                courseController.isCurrentCoursePurchased.value = true;

                await courseController.getCourseQuizzes(myCourseId);
                await courseController.getCourseDetails(myCourseId);
                courseController.currentCourseId.value = myCourseId;

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CourseLandingPage(
                          course: myCourse,
                        )));
                // Done: navigate to course page
              },
            ));
  }
}
