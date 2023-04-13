import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/courses/favorite_course_model.dart';
import 'package:frontend/themes/app_colors.dart';
import 'package:frontend/widgets/app_bar_box.dart';
import 'package:frontend/widgets/favorites_item.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
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
  final GetStorage _getStorage = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        backgroundColor: appBarOffWhite,
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
            return Dismissible(
              key: Key(userFavoriteCourses[index].courseId.toString()),
              direction: DismissDirection.startToEnd,
              onDismissed: (direction) async {
                await usersController.deleteCourseFromUserFavorites(
                    _getStorage.read('userId'),
                    userFavoriteCourses[index].courseId);
                setState(() {
                  // TODO remove from the favorites
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Course removed")),
                );
              },
              background: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                margin: EdgeInsets.only(top: 10, bottom: 10),
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: AlignmentDirectional.centerStart,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              confirmDismiss: (direction) => promptUser(direction),
              child: FavoritesItem(
                data: userFavoriteCourses[index],
                onTap: () async {
                  CourseModel userFavoriteCourse = courseController
                      .getMyCourse(userFavoriteCourses[index].courseId)!;

                  int userFavoriteCourseId = userFavoriteCourse.id;

                  courseController.isCurrentCoursePurchased.value = true;

                  await courseController.getCourseQuizzes(userFavoriteCourseId);
                  await courseController.getCourseDetails(userFavoriteCourseId);
                  courseController.currentCourseId.value = userFavoriteCourseId;

                  if (await usersController.hasUserPurchasedTheCourse(
                      _getStorage.read('userId'), userFavoriteCourseId)) {
                    await usersController
                        .getUserCompletedLessonsForCertainCourse(
                            _getStorage.read('userId'), userFavoriteCourseId);
                  }

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CourseLandingPage(
                            course: userFavoriteCourse,
                          )));
                  // Done: navigate to course
                },
              ),
            );
          }),
    );
  }

  Future<bool> promptUser(DismissDirection direction) async {
    String action = "remove";
    return await showCupertinoDialog<bool>(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            content: Text("Are you sure you want to $action the course?"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("Ok"),
                onPressed: () {
                  // Dismiss the dialog and
                  // also dismiss the swiped item
                  Navigator.of(context).pop(true);
                },
              ),
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: () {
                  // Dismiss the dialog but don't
                  // dismiss the swiped item
                  return Navigator.of(context).pop(false);
                },
              )
            ],
          ),
        ) ??
        false; // In case the user dismisses the dialog by clicking away from it
  }
}
