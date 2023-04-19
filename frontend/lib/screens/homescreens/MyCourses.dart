
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/MyList.dart';
import 'package:frontend/screens/watchCourseScreen.dart';
import 'package:page_transition/page_transition.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({super.key});

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class Course {
  final String image;
  final String title;
  final String author;
  final String ratings;
  final String price;
  final String enrolled;
  final String discount;

  Course(
      {required this.image,
      required this.title,
      required this.author,
      required this.ratings,
      required this.price,
      required this.enrolled,
      required this.discount});
}

class _MyCoursesState extends State<MyCourses> {
  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My learning"),
          backgroundColor: Colors.black,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                child: InkWell(
                  child: const Icon(EvaIcons.shoppingCartOutline),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          child: const MyList(),
                          type: PageTransitionType.leftToRightWithFade),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        body: Scaffold(
            backgroundColor: const Color(0xfffbfcff), //homePageBackground
            body: Container(
                padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "My course",
                          style: TextStyle(
                              fontSize: 30,
                              color: Color(0xff302f51), //homePageTitle
                              fontWeight: FontWeight.w700),
                        ),
                        Expanded(child: Container()),
                        const Icon(Icons.arrow_back_ios,
                            size: 20, color: Color(0xff3b3c5c)),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                          color: Color(0xff3b3c5c),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            size: 20, color: Color(0xff3b3c5c))
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(children: [
                      const Text(
                        "My course",
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff414160), //homePaheSubtitle
                            fontWeight: FontWeight.w700),
                      ),
                      Expanded(child: Container()),
                      const Text("Details",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff6588f4))), //homePageDetail
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                  child: const WatchCourse(),
                                  type: PageTransitionType.leftToRightWithFade),
                            );
                            // Get.to(() => WatchCourse());
                          },
                          child: const Icon(Icons.arrow_forward,
                              size: 20, color: Colors.blue))
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 220,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Color(0xff0f17ad), //gradientFirst,
                                Color(0xff6985e8) //gradientSecond
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.centerRight),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(80)),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(5, 10),
                                blurRadius: 20,
                                color: Color(0xff6985e8))
                          ]),
                      child: Container(
                          padding: const EdgeInsets.only(
                              left: 20, top: 25, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Next workout",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(
                                          0xfff4f5fd) //homePageContainerTextSmall
                                      )),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Legs Toning",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Color(0xfff4f5fd),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "and Glutes Workout",
                                style: TextStyle(
                                    fontSize: 25, color: Color(0xfff4f5fd)),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.timer,
                                          size: 20, color: Color(0xfff4f5fd)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "60 min",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xfff4f5fd)),
                                      )
                                    ],
                                  ),
                                  Expanded(child: Container()),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Color(0xff0f17ad),
                                              blurRadius: 10,
                                              offset: Offset(4, 8))
                                        ]),
                                    child: const Icon(
                                      Icons.play_circle_fill,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                  )
                                ],
                              )
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                        height: 180,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: const DecorationImage(
                                        image: AssetImage(
                                            "images/course-header.jpg"),
                                        fit: BoxFit.fill),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 40,
                                          offset: const Offset(8, 10),
                                          color: const Color(0xff6985e8)
                                              .withOpacity(0.3)),
                                      BoxShadow(
                                          blurRadius: 10,
                                          offset: const Offset(-1, -5),
                                          color: const Color(0xff6985e8)
                                              .withOpacity(0.3))
                                    ])),
                            Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                  right: 200,
                                  bottom: 60,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: const DecorationImage(
                                      image:
                                          AssetImage("images/studyingMan.png")),
                                )),
                            Container(
                                width: double.maxFinite,
                                height: 100,
                                margin:
                                    const EdgeInsets.only(left: 150, top: 30),
                                child: Column(
                                  children: [
                                    const Text(
                                      "You are doing great",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff414160)),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    RichText(
                                        text: const TextSpan(
                                            text: "Keep it up\n",
                                            style: TextStyle(
                                              color: Color(0xff414160),
                                              fontSize: 16,
                                            ),
                                            children: [
                                          TextSpan(text: "Stick to your plan")
                                        ]))
                                  ],
                                )),
                          ],
                        )),
                  ],
                ))));
  }
}
