import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/controllers/marketplace/categories/category_controller.dart';
import 'package:frontend/controllers/marketplace/courses/course_controller.dart';
import 'package:frontend/controllers/users/user_controller.dart';
import 'package:frontend/screens/account.dart';
import 'package:frontend/screens/course_landing_page.dart';
import 'package:frontend/screens/start.dart';
import 'package:frontend/storage/secure_storage.dart';
import 'package:frontend/themes/app_colors.dart';
import 'package:frontend/widgets/category_box.dart';
import 'package:frontend/widgets/featured_item.dart';
import 'package:frontend/widgets/recommended_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String routeName = "/homepage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CourseController courseController = Get.put(CourseController());
  CategoryController categoryController = Get.put(CategoryController());
  UsersController usersController = Get.put(UsersController());
  final GetStorage _getStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: FutureBuilder<AppBar>(
          future: getAppBar(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            } else {
              return AppBar();
            }
          },
        ),
      ),
    );
  }

  Future<AppBar> getAppBar() async {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: appBarOffWhite,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const SizedBox(
              height: 15,
            ),
            Text(
              "welcome",
              style: TextStyle(
                fontFamily: 'Nexa-Trial',
                fontSize: 14,
                color: textColor
              ),
            ),
            // Done get logged in users username and show here instead of hardcoded name
            Obx(() => Text(
                  usersController.isUserLoggedIn.value
                      ? "${_getStorage.read("username")}"
                      : "Traveller",
                  style: const TextStyle(
                      color: textColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Nexa-Trial',
                  ),
                )),
          ]),

          GestureDetector(
            onTap: () {
              showLogoutDialog(context);
            },
            child: CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage("images/ape.png"),
            ),
          ),

          //icon: const Icon(Icons.logout_outlined, color: primaryDark))
          /*NotificationBox(
            notifiedNumber: 2,
            onTap: () async {
              await SecureStorage.deleteAccessToken();
              usersController.isUserLoggedIn.value = false;
              print("wallet pressed");
            },
          )*/
        ],
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCategories(),
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                child: Text(
                  "Featured",
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      fontFamily: 'Nexa-Trial'),
                ),
              ),
              getFeatured(),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 25, 15, 10),
                child: Row(
                  children: const [
                    Text(
                      "Recommended",
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          fontFamily: 'Nexa-Trial'),
                    )
                  ],
                ),
              ),
              getRecommended()
            ],
          )),
    );
  }

  /* Widget getRecommended() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 15),
      scrollDirection: Axis.horizontal,
      child: Row(
          children: List.generate(
              courseController.recommendedCourses.length,
              (index) => Container(
                    margin: const EdgeInsets.only(top: 3, right: 15, bottom: 5),
                    child: RecommendItem(
                      data: courseController.recommendedCourses[index],
                      onTap: () async {
                        await courseController.getCourseDetails(
                            courseController.recommendedCourses[index].id);
                        courseController.currentCourseId.value =
                            courseController.recommendedCourses[index].id;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CourseLandingPage(
                                  course: courseController
                                      .recommendedCourses[index],
                                )));
                      },
                    ),
                  ))),
    );
  }*/

  Widget getRecommended() {
    return CarouselSlider(
        options: CarouselOptions(
            enableInfiniteScroll: false,
            height: 130,
            animateToClosest: false,
            pageSnapping: false),
        items: List.generate(
            courseController.recommendedCourses.length,
            (index) => Container(
                  margin: const EdgeInsets.only(top: 3, right: 10, bottom: 5),
                  child: RecommendItem(
                    data: courseController.recommendedCourses[index],
                    onTap: () async {
                      bool isTheCoursePurchased =
                          await usersController.hasUserPurchasedTheCourse(
                              _getStorage.read("userId"),
                              courseController.recommendedCourses[index].id);
                      courseController.isCurrentCoursePurchased.value =
                          isTheCoursePurchased;

                      await courseController.getCourseQuizzes(
                          courseController.recommendedCourses[index].id);

                      await courseController.getCourseDetails(
                          courseController.recommendedCourses[index].id);
                      courseController.currentCourseId.value =
                          courseController.recommendedCourses[index].id;
                      if (isTheCoursePurchased) {
                        await usersController
                            .getUserCompletedLessonsForCertainCourse(
                                _getStorage.read('userId'),
                                courseController.recommendedCourses[index].id);
                      }
                      Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CourseLandingPage(
                                course:
                                    courseController.recommendedCourses[index],
                              ),
                            settings: const RouteSettings(
                              name: "/course_landing_page",
                              arguments: '/course_landing_page'
                            ),
                          )
                      );
                    },
                  ),
                )));
  }

  Widget getFeatured() {
    return CarouselSlider(
        options: CarouselOptions(
            initialPage: 1,
            enableInfiniteScroll: false,
            height: 290,
            enlargeCenterPage: true,
            disableCenter: true),
        items: List.generate(
            courseController.featuredCourses.length,
            (index) => FeaturedItem(
                data: courseController.featuredCourses[index],
                onTap: () async {
                  bool isTheCoursePurchased =
                      await usersController.hasUserPurchasedTheCourse(
                          _getStorage.read("userId"),
                          courseController.featuredCourses[index].id);
                  courseController.isCurrentCoursePurchased.value =
                      isTheCoursePurchased;

                  await courseController.getCourseQuizzes(
                      courseController.featuredCourses[index].id);
                  await courseController.getCourseDetails(
                      courseController.featuredCourses[index].id);
                  courseController.currentCourseId.value =
                      courseController.featuredCourses[index].id;
                  if (isTheCoursePurchased) {
                    await usersController
                        .getUserCompletedLessonsForCertainCourse(
                            _getStorage.read('userId'),
                            courseController.featuredCourses[index].id);
                  }
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CourseLandingPage(
                            course: courseController.featuredCourses[index],
                          ),
                    settings: const RouteSettings(
                      name: "/course_landing_page",
                      arguments: '/course_landing_page'
                      ),
                    )
                  );
            })
        )
    );
  }

  int selectedCategoryIndex = 0;
  Widget getCategories() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
      scrollDirection: Axis.horizontal,
      child: Row(
          children: List.generate(
        categoryController.categories.length,
        (index) => Padding(
          padding: const EdgeInsets.only(right: 15),
          child: CategoryBox(
              isSelected: selectedCategoryIndex == index,
              onTap: () {
                courseController.getFeaturedCourses(
                    categoryController.categories[index].name);
                courseController.getRecommendedCourses(
                    categoryController.categories[index].name);
                setState(() {
                  selectedCategoryIndex = index;
                });
              },
              data: categoryController.categories[index]),
        ),
      )),
    );
  }

  // Function to show the Cupertino-style popup dialog
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Log Out"),
          content: Text("Are you sure you want to log out?"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            CupertinoDialogAction(
              child: Text("Log Out"),
              onPressed: () async {
                // Perform log out action here
                Navigator.of(context).pop();
                await SecureStorage.deleteAccessToken();
                _getStorage.erase();
                usersController.isUserLoggedIn.value = false;
                Navigator.pushNamed(context, StartPage.routeName);// Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
