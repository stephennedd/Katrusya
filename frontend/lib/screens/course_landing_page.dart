import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/controllers/users/user_controller.dart';
import 'package:frontend/screens/section.dart';
import 'package:frontend/storage/secure_storage.dart';
import 'package:frontend/widgets/app_bar_box.dart';
import 'package:frontend/widgets/bookmark_box.dart';
import 'package:frontend/widgets/button.dart';
import 'package:frontend/widgets/custom_image.dart';
import 'package:frontend/widgets/milestone_item.dart';
import 'package:frontend/widgets/section_item.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:readmore/readmore.dart';

import '../controllers/marketplace/courses/course_controller.dart';
import '../models/courses/course_model.dart';
import '../utils/data.dart';
import 'login.dart';

class CourseLandingPage extends StatefulWidget {
  const CourseLandingPage({Key? key, required this.course}) : super(key: key);
  static const String routeName = "/course_landing_page";
  final CourseModel course;

  @override
  State<CourseLandingPage> createState() => _CourseLandingPageState();
}

class _CourseLandingPageState extends State<CourseLandingPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late CourseModel courseData;
  late final bool isPurchased;

  CourseController courseController = Get.put(CourseController());
  UsersController usersController = Get.put(UsersController());

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    isPurchased = true;
    // TODO check if course is already purchased complete the code below
    //isPurchased == check from database if course is in list of courses. but maybe we can figure out a better more safe solution to enabling courses later.
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: MyAppBar(
        hasAction: true,
        icon: SvgPicture.asset("assets/icons/trophy-star.svg"),
        title: "Details",
        onTap: () {
          print("open leaderboard");
        },
      ),
      body: buildBody(),
      bottomNavigationBar: isPurchased?  null : getBottomBar(),
      backgroundColor: appBarColor,
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Hero(
              tag: widget.course.id.toString() + widget.course.image,
              child: CustomImage(
                widget.course.image,
                radius: 10,
                width: double.infinity,
                height: 200,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: getInfo()),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          getTabBar(),
          getTabBarPages()
        ],
      ),
    );
  }

  Widget getTabBar() {
    return Container(
      child: TabBar(
        indicatorColor: primaryDark,
        controller: tabController,
        tabs: const [
          Tab(
            child: Text(
              "Sections",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: textColor),
            ),
          ),
          Tab(
            child: Text(
              "Milestones",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: textColor),
            ),
          )
        ],
      ),
    );
  }

  Widget getTabBarPages() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      height: 400,
      width: double.infinity,
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          getSections(),
          getMilestones(),
        ],
      ),
    );
  }

  Widget getSections() {
    return ListView.builder(
        itemCount: courseController.currentCourseDetails.value!.sections.length,
        itemBuilder: (context, index) => SectionItem(
              data:
                  courseController.currentCourseDetails.value!.sections[index],
              onTap: () {
                // navigate to new page
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SectionPage(
                          data: courseController
                              .currentCourseDetails.value!.sections[index],
                        )));
              },
            ));
  }

  Widget getMilestones() {
    return ListView.builder(
        itemCount: milestones.length,
        itemBuilder: (context, index) => MilestoneItem(
              data: milestones[index],
              onTap: () {
                print("goto quiz");
              },
            ));
  }

  Widget getInfo() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // Done: get course name from database
                //widget.course.name,
                courseController.currentCourseDetails.value!.courseName,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textColor),
              ),
              BookmarkBox(
                // TODO get from database
                isFavorited: courseController
                    .courses
                    .value[courseController.currentCourseId.value - 1]
                    .isFavorited,
                //widget.course.isFavorited,
                onTap: () {
                  debugPrint(courseController.currentCourseId.value.toString());
                  // print(courseController
                  //     .courses
                  //     .value[courseController.currentCourseId.value - 1]
                  //     .isFavorited);
                  // setState(() {
                  //   courseController
                  //           .courses
                  //           .value[courseController.currentCourseId.value - 1]
                  //           .isFavorited =
                  //       !courseController
                  //           .courses
                  //           .value[courseController.currentCourseId.value - 1]
                  //           .isFavorited;
                  // });
                  // print(courseController
                  //     .courses
                  //     .value[courseController.currentCourseId.value - 1]
                  //     .isFavorited);
                },
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // TODO get token amount per course
              getAttribute(
                  Icons.play_circle_outline,
                  "${courseController.currentCourseDetails.value!.numberOfLessons} lessons",
                  labelColor),
              getAttribute(
                  Icons.schedule_outlined,
                  "${courseController.currentCourseDetails.value!.courseDurationInHours} hours",
                  labelColor),
              getAttribute(
                  Icons.currency_bitcoin_sharp, "earn tokens", primaryDark),
              getAttribute(
                  Icons.star,
                  courseController.courses
                      .value[courseController.currentCourseId.value - 1].review
                      .toString(),
                  Colors.yellow),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Course Description",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: textColor),
              ),
              const SizedBox(
                height: 10,
              ),
              ReadMoreText(
                // Done: get description from database
                courseController
                    .courses
                    .value[courseController.currentCourseId.value - 1]
                    .description,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: labelColor),
                trimLines: 2,
                trimMode: TrimMode.Line,
                trimCollapsedText: " Show more",
                trimExpandedText: " Show less",
                moreStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: primaryDark,
                ),
                lessStyle: const TextStyle(
                    fontWeight: FontWeight.w400, color: primaryDark),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget getAttribute(IconData icon, String info, Color color) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(info,
            style: const TextStyle(fontFamily: 'Poppins', color: labelColor)),
      ],
    );
  }

  Widget getBottomBar() {
    // TODO should only show if user does not already own course
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
          color: appBarColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: shadowColor.withOpacity(.05),
                blurRadius: 1,
                spreadRadius: 1,
                offset: const Offset(0, 0))
          ]),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "price",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: textColor),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                // Done: get price from database
                courseController.courses
                    .value[courseController.currentCourseId.value - 1].price,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ],
          ),
          const SizedBox(
            width: 30,
          ),
          Expanded(
            child: ButtonSimple(
              text: "Buy course",
              color: primary,
              textColor: primaryDark,
              onPressed: () async {
                if (await SecureStorage.getAccessToken() != null) {
                  // TODO add to the logged-in users list of courses

                } else {
                  Navigator.pushNamed(context, LoginPage.routeName);
                }

              },
            ),
          )
        ],
      ),
    );
  }
}
