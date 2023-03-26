import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/controllers/marketplace/courses/course_controller.dart';
import 'package:frontend/utils/data.dart';
import 'package:frontend/widgets/course_item.dart';
import 'package:frontend/widgets/searchcategory_item.dart';
import 'package:frontend/controllers/marketplace/categories/category_controller.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, this.onTap}) : super(key: key);
  final GestureTapCallback? onTap;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  CategoryController categoryController = Get.put(CategoryController());
  CourseController courseController = Get.put(CourseController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: appBarColor,
            pinned: true,
            elevation: 0.5,
            title: getAppBar(),
          ),
          SliverToBoxAdapter(
            child: getSearchBox(),
          ),
          SliverToBoxAdapter(
            child: getCategories(),
          ),
          Obx(() => SliverList(delegate: getCourses())),
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
              height: 40,
              padding: const EdgeInsets.only(bottom: 3),
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
              // TODO filter results based on search query
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    hintText: "Search",
                    hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 15)),
                onSubmitted: (value) {
                  courseController.getCourses(null, value);
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
                      courseController.getCourses(
                          categoryController.categories[index].name, null);
                      setState(() {
                        selectedItemIndex = index;
                      });
                    },
                  ))),
    );
  }

  getCourses() {
    return SliverChildBuilderDelegate(
        childCount: courseController.courses.value.length, (context, index) {
      return Padding(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          child: CourseItem(
            data: courseController.courses.value[index],
            onFavorite: () {
              setState(() {
                courseController.courses.value[index].isFavorited =
                    !courseController.courses.value[index].isFavorited;
              });
            },
          ));
    });
  }
}
