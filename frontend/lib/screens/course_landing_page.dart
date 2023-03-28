import 'package:flutter/material.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/screens/section.dart';
import 'package:frontend/widgets/app_bar_box.dart';
import 'package:frontend/widgets/bookmark_box.dart';
import 'package:frontend/widgets/button.dart';
import 'package:frontend/widgets/custom_image.dart';
import 'package:frontend/widgets/section_item.dart';
import 'package:readmore/readmore.dart';

import '../models/courses/course_model.dart';
import '../utils/data.dart';

class CourseLandingPage extends StatefulWidget {
  const CourseLandingPage({Key? key, required this.course}) : super(key: key);
  static const String routeName = "/course_landing_page";
  final CourseModel course;

  @override
  State<CourseLandingPage> createState() => _CourseLandingPageState();
}

class _CourseLandingPageState extends State<CourseLandingPage> with SingleTickerProviderStateMixin{
  late TabController tabController;
  late CourseModel courseData;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        hasAction: true,
        icon:Icons.leaderboard_outlined,
        title: "Details",
        onTap: () {
          print("open leaderboard");
        },
      ),
      body: buildBody(),
      bottomNavigationBar: getBottomBar(),
      backgroundColor: appBarColor,
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(15,10,15,20),
      child: Column(
        children: [
          Hero(
            tag: widget.course.id.toString() + widget.course.image,
            child: CustomImage(
              widget.course.image,
              radius: 10,
              width: double.infinity,
              height: 200,
            ),
          ),
          getInfo(),
          SizedBox(
            height: 10,
          ),
          Divider(),
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
        tabs: [
          Tab(
            child: Text(
              "Sections",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: textColor
              ),
            ),
          ),
          Tab(
            child: Text(
              "Milestones",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: textColor
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getTabBarPages() {
    return Container(
      height: 250,
      width: double.infinity,
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          getSections(),
          Container(
            child: Text("Milestones"),
          ),
        ],
      ),
    );
  }

  Widget getSections() {
    return ListView.builder(
      itemCount: sections.length,
      itemBuilder: (context, index) => SectionItem(
        data: sections[index],
        onTap: () {
          // navigate to new page
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SectionPage(
                data: sections[index],
              )
          ));
        },
      )
    );
  }

  Widget getInfo() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.course.name,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: textColor
                ),
              ),
              BookmarkBox(
                isFavorited: widget.course.isFavorited,
                onTap: () {
                  setState(() {
                    widget.course.isFavorited = !widget.course.isFavorited;
                  });
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
              getAttribute(Icons.play_circle_outline, widget.course.session, labelColor),
              getAttribute(Icons.schedule_outlined, widget.course.duration, labelColor),
              getAttribute(Icons.currency_bitcoin_sharp, "earn tokens", primaryDark),
              getAttribute(Icons.star, widget.course.review.toString(), Colors.yellow),
            ],
          ),

          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Course Description",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: textColor
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ReadMoreText(
                widget.course.description,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: labelColor
                ),
                trimLines: 2,
                trimMode: TrimMode.Line,
                trimCollapsedText: " Show more",
                trimExpandedText: " Show less",
                moreStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: primaryDark,
                ),
                lessStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: primaryDark
                ),
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
        Text(
            info,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: labelColor
            )),
      ],
    );
  }

  Widget getBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: appBarColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(.05),
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(0, 0)
          )
        ]
      ),
      child: Row (
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "price",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: textColor
                ),
              ),
              SizedBox(height: 3,),
              Text(
                widget.course.price,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 18
                ),
              ),
            ],
          ),
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: ButtonSimple(
              text: "Buy course",
              color: primary,
              textColor: primaryDark,
              onPressed: () {

              },
            ),
          )
        ],
      ),
    );
  }
}
