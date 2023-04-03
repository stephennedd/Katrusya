import 'package:flutter/material.dart';
import 'package:frontend/models/courses/favorite_course_model.dart';
import 'package:frontend/widgets/app_bar_box.dart';
import 'package:frontend/widgets/favorites_item.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controllers/marketplace/courses/course_controller.dart';
import '../controllers/users/user_controller.dart';
import '../models/courses/course_model.dart';
import 'course_landing_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);
  static const String routeName = "/favorites";

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  UsersController usersController = Get.put(UsersController());
  CourseController courseController = Get.put(CourseController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Wishlist",
        centerTitle: false,
        hasBackButton: false,
      ),
      body: Obx(() => buildBody()),
    );
  }

  Widget buildBody() {
    // Done: get list of actually favorited courses and add them to 'items'
    List<FavoriteCourseModel> userFavoriteCourses =
        usersController.userFavoriteCourses;

    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: userFavoriteCourses.length,
          itemBuilder: (context, index) {
            return FavoritesItem(
              data: userFavoriteCourses[index],
              onTap: () async {
                CourseModel userFavoriteCourse = courseController
                    .getMyCourse(userFavoriteCourses[index].courseId)!;

                int userFavoriteCourseId = userFavoriteCourse.id;

                courseController.isCurrentCoursePurchased.value = true;

                await courseController.getCourseQuizzes(userFavoriteCourseId);
                await courseController.getCourseDetails(userFavoriteCourseId);
                courseController.currentCourseId.value = userFavoriteCourseId;

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CourseLandingPage(
                          course: userFavoriteCourse,
                        )));
                // Done: navigate to course
              },
            );
          }),
    );
  }
}
