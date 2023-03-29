import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend/controllers/marketplace/categories/category_controller.dart';
import 'package:frontend/controllers/marketplace/courses/course_controller.dart';
import 'package:frontend/screens/course_landing_page.dart';
import 'package:frontend/utils/data.dart';
import 'package:frontend/widgets/category_box.dart';
import 'package:frontend/widgets/featured_item.dart';
import 'package:frontend/widgets/notification_box.dart';
import 'package:frontend/widgets/recommended_item.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String routeName = "/homepage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CourseController courseController = Get.put(CourseController());
  CategoryController categoryController = Get.put(CategoryController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      appBar: getAppBar(),
      backgroundColor: appBarColor,
    );
  }

  AppBar getAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: appBarColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            SizedBox(
              height: 5,
            ),
            // TODO get logged in users username and show here instead of hardcoded name
            Text(
              "Hi Stephen!",
              style: TextStyle(
                  color: textColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Nexa-Trial'),
            ),
          ]),
          NotificationBox(
            notifiedNumber: 2,
            onTap: () {
              print("wallet pressed");
            },
          )
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
                      fontWeight: FontWeight.w800,
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
                          fontWeight: FontWeight.w800,
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

  Widget getRecommended() {
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
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CourseLandingPage(
                              course: courseController.recommendedCourses[index],
                            )));
                      },
                    ),
                  ))),
    );
  }

  Widget getFeatured() {
    return CarouselSlider(
      options: CarouselOptions(
        initialPage: 1,
        enableInfiniteScroll: false,
        height: 290,
        enlargeCenterPage: true,
        disableCenter: true
      ),
      items: List.generate(
        courseController.featuredCourses.length,
        (index) => FeaturedItem(
            data: courseController.featuredCourses[index],
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CourseLandingPage(
                    course: courseController.featuredCourses[index],
                  )));
            })));
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
}
