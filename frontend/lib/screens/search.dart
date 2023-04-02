import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/controllers/marketplace/courses/course_controller.dart';
import 'package:frontend/controllers/users/user_controller.dart';
import 'package:frontend/screens/course_landing_page.dart';
import 'package:frontend/screens/homescreens/Featured.dart';
import 'package:frontend/utils/data.dart';
import 'package:frontend/widgets/course_item.dart';
import 'package:frontend/widgets/searchcategory_item.dart';
import 'package:frontend/controllers/marketplace/categories/category_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, this.onTap}) : super(key: key);
  final GestureTapCallback? onTap;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  CategoryController categoryController = Get.put(CategoryController());
  CourseController courseController = Get.put(CourseController());

  UsersController usersController = Get.put(UsersController());
  final GetStorage _getStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: appBarColor,
            pinned: true,
            elevation: 0.5,
            title: getAppBar(),
            automaticallyImplyLeading: false,
          ),
          SliverToBoxAdapter(
            child: getSearchBox(),
          ),
          SliverToBoxAdapter(
            child: getCategories(),
          ),
          Obx(() => SliverList(delegate: getSearchedCourses())),
        ],
      ),
    );
  }

  getAppBar() {
    return Row(
      children: const [
        Text(
          "Search",
          style: TextStyle(
              fontFamily: 'Nexa-Trial',
              fontSize: 24,
              color: textColor,
              fontWeight: FontWeight.w800),
        )
      ],
    );
  }

  // Create a FocusNode for the TextField
  final searchFieldFocusNode = FocusNode();

  getSearchBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              padding: const EdgeInsets.only(bottom: 3, top: 3),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor.withOpacity(.05),
                      spreadRadius: .5,
                      blurRadius: .5,
                      offset: const Offset(0, 0),
                    )
                  ]),
              // Done filter results based on search query
              child: TextField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    hintText: "Search",
                    hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 15)),
                onSubmitted: (value) {
                  courseController.getSearchedCourses(null, value);
                  searchFieldFocusNode.requestFocus();
                },
                focusNode: searchFieldFocusNode,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              print("filter Pressed");
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(7),
              ),
              child: SvgPicture.asset(
                "assets/icons/filter.svg",
                colorFilter:
                    const ColorFilter.mode(primaryDark, BlendMode.srcIn),
              ),
            ),
          )
        ],
      ),
    );
  }

  int selectedItemIndex = 0;
  getCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 5),
      child: Row(
          children: List.generate(
              categoryController.categories.length,
              (index) => CategoryItem(
                    data: categoryController.categories[index],
                    isSelected: selectedItemIndex == index,
                    onTap: () {
                      courseController.getSearchedCourses(
                          categoryController.categories[index].name, null);
                      setState(() {
                        selectedItemIndex = index;
                      });
                    },
                  ))),
    );
  }

  getSearchedCourses() {
    return SliverChildBuilderDelegate(
        childCount: courseController.searchedCourses.length, (context, index) {
      return Padding(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          child: CourseItem(
            data: courseController.searchedCourses[index],
            onFavorite: () {
              if (usersController.isUserLoggedIn.value &&
                  !usersController.isCourseFavoriteForTheUser(
                      courseController.searchedCourses[index].id)) {
                usersController.addCourseToUserFavorites(
                    _getStorage.read('userId'),
                    courseController.searchedCourses[index].id);
              } else if (usersController.isUserLoggedIn.value &&
                  usersController.isCourseFavoriteForTheUser(
                      courseController.searchedCourses[index].id)) {
                usersController.deleteCourseFromUserFavorites(
                    _getStorage.read('userId'),
                    courseController.searchedCourses[index].id);
              }
            },
            onTap: () async {
              bool isTheCoursePurchased =
                  await usersController.hasUserPurchasedTheCourse(
                      _getStorage.read("userId"),
                      courseController.searchedCourses[index].id);
              courseController.isCurrentCoursePurchased.value =
                  isTheCoursePurchased;

              await courseController
                  .getCourseQuizzes(courseController.searchedCourses[index].id);
              await courseController
                  .getCourseDetails(courseController.searchedCourses[index].id);
              courseController.currentCourseId.value =
                  courseController.searchedCourses[index].id;
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CourseLandingPage(
                        course: courseController.searchedCourses.value[index],
                      )));
            },
          ));
    });
  }
}
