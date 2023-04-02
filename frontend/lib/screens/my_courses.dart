import 'package:flutter/material.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/models/courses/course_model.dart';
import 'package:frontend/widgets/app_bar_box.dart';
import 'package:frontend/widgets/course_complete_item.dart';
import 'package:frontend/widgets/course_item.dart';

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
    return Column(
      children: [
        getTabBar(),
        getTabBarPages()
      ]
    );
  }

  Widget getTabBar() {
    return Container(
      child: TabBar(
          indicatorWeight: 2,
          indicatorColor: primary,
          controller: _tabController,
          tabs:  [
            Tab(
              child: Text(
                // TODO update with real number
              "Progress ($incompleteCourses)",
                style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                    overflow: TextOverflow.ellipsis
                ),
              ),
            ),
            Tab(
              child: Text(
                // TODO update with real number
                "Completed ($completeCourses)",
                style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                    overflow: TextOverflow.ellipsis
                ),
              ),
            )
          ]
      )
    );
  }

  Widget getTabBarPages() {
    var deviceDisplayHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      width: double.infinity,
      height: deviceDisplayHeight - 221,
      child: TabBarView(
        physics: ScrollPhysics(),
        controller: _tabController,
        children: [
          getCourses(),
          getIncompleteCourses()
        ],
      ),
    );
  }

  Widget getCourses() {
    final items = <CourseModel>[];
    items.add(
      CourseModel(
        id: 1,
        name: "UI/UX",
        image: 'https://images.unsplash.com/photo-1586717791821-3f44a563fa4c?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY3OTEwMTA4Nw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600',
        price: "120,00",
        durationInHours: 3,
        numberOfLessons: 2,
        review: "4",
        isFavorited: false,
        description: "this is a test course",
        isFeatured: false,
        isRecommended: false
      )
    );

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      itemBuilder: (context, index) =>
          CourseCompleteItem(
            data: items[index],
            onTap: () {
              // TODO navigate to course page
            },
          )
    );
  }

  Widget getIncompleteCourses() {
    final items = <CourseModel>[];
    items.add(
      CourseModel(
        id: 1,
        name: "UI/UX",
        image: 'https://images.unsplash.com/photo-1586717791821-3f44a563fa4c?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY3OTEwMTA4Nw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600',
        price: "120,00",
        durationInHours: 3,
        numberOfLessons: 2,
        review: "4",
        isFavorited: false,
        description: "this is a test course",
        isFeatured: false,
        isRecommended: false
      )
    );

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) =>
          CourseCompleteItem(
            data: items[index],
            onTap: () {
              // TODO navigate to course page
            },
          )
    );
  }
}
