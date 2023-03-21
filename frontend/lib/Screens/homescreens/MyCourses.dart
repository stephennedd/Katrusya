import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/Screens/MyList.dart';
import 'package:frontend/Screens/components/ProgressingBar.dart';
import 'package:frontend/Screens/watchCourseScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:get/get.dart';

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
  // List<Course> data = [
  //   Course(
  //       image:
  //           "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.edx.org%2Fschool%2Fedx&psig=AOvVaw3vRjaUy3sTcr7qWDXWNx2q&ust=1677924499615000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCKjJ4P_Bv_0CFQAAAAAdAAAAABAE",
  //       title: "Python course",
  //       author: "Maksim Maksimovic",
  //       ratings: "5",
  //       enrolled: "123654",
  //       price: "100",
  //       discount: "90"),
  //   Course(
  //       image:
  //           "https://www.google.com/url?sa=i&url=https%3A%2F%2Findianexpress.com%2Farticle%2Feducation%2Fhave-a-business-acumen-try-out-these-new-age-short-online-courses-6352687%2F&psig=AOvVaw3vRjaUy3sTcr7qWDXWNx2q&ust=1677924499615000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCKjJ4P_Bv_0CFQAAAAAdAAAAABAI",
  //       title: "JS course",
  //       author: "Yehor Zhvarnytskyi",
  //       ratings: "5",
  //       enrolled: "125784",
  //       price: "200",
  //       discount: "170")
  // ];
  @override
  void initState() {
    super.initState();
    _initData();
  }

  //List info = [];
  _initData() {
    // DefaultAssetBundle.of(context).loadString("json/info.json").then((value) {
    //   info = json.decode(value);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My learning"),
          backgroundColor: Colors.black,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                child: InkWell(
                  child: Icon(EvaIcons.shoppingCartOutline),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          child: MyList(),
                          type: PageTransitionType.leftToRightWithFade),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        body: Scaffold(
            backgroundColor: Color(0xfffbfcff), //homePageBackground
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
                    SizedBox(height: 20),
                    Row(children: [
                      const Text(
                        "My course",
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff414160), //homePaheSubtitle
                            fontWeight: FontWeight.w700),
                      ),
                      Expanded(child: Container()),
                      Text("Details",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff6588f4))), //homePageDetail
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                  child: WatchCourse(),
                                  type: PageTransitionType.leftToRightWithFade),
                            );
                            // Get.to(() => WatchCourse());
                          },
                          child: Icon(Icons.arrow_forward,
                              size: 20, color: Colors.blue))
                    ]),
                    SizedBox(
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
                              Text("Next workout",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(
                                          0xfff4f5fd) //homePageContainerTextSmall
                                      )),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Legs Toning",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Color(0xfff4f5fd),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "and Glutes Workout",
                                style: TextStyle(
                                    fontSize: 25, color: Color(0xfff4f5fd)),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
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
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xff0f17ad),
                                              blurRadius: 10,
                                              offset: Offset(4, 8))
                                        ]),
                                    child: Icon(
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
                    SizedBox(
                      height: 25,
                    ),
                    Container(
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
                                          offset: Offset(8, 10),
                                          color: Color(0xff6985e8)
                                              .withOpacity(0.3)),
                                      BoxShadow(
                                          blurRadius: 10,
                                          offset: Offset(-1, -5),
                                          color: Color(0xff6985e8)
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
                                    Text(
                                      "You are doing great",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff414160)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RichText(
                                        text: TextSpan(
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
                    // Row(
                    //   children: const [
                    //     Text(
                    //       "Area of focus",
                    //       style: TextStyle(
                    //           fontSize: 25,
                    //           fontWeight: FontWeight.w500,
                    //           color: Color(0xff302f51)),
                    //     )
                    //   ],
                    // ),
                    // Expanded(
                    //     child: ListView.builder(
                    //         itemCount: (info.length.toDouble() / 2).toInt(),
                    //         itemBuilder: (_, i) {
                    //           int a = 2 * i;
                    //           int b = 2 * i + 1;

                    //           return Row(
                    //             children: [
                    //               Container(
                    //                 width: 200,
                    //                 height: 170,
                    //                 padding: EdgeInsets.only(bottom: 5),
                    //                 decoration: BoxDecoration(
                    //                     color: Colors.white,
                    //                     borderRadius: BorderRadius.circular(15),
                    //                     image: DecorationImage(
                    //                         image: AssetImage(info[i]['img'])),
                    //                     boxShadow: [
                    //                       BoxShadow(
                    //                           blurRadius: 3,
                    //                           offset: Offset(5, 5),
                    //                           color: Color(0xff6985e8)
                    //                               .withOpacity(0.1)),
                    //                       BoxShadow(
                    //                           blurRadius: 3,
                    //                           offset: Offset(-5, -5),
                    //                           color: Color(0xff6985e8)
                    //                               .withOpacity(0.1))
                    //                     ]),
                    //                 child: Center(
                    //                     child: Align(
                    //                         alignment: Alignment.bottomCenter,
                    //                         child: Text(info[i]["title"],
                    //                             style: TextStyle(
                    //                                 fontSize: 20,
                    //                                 color:
                    //                                     Color(0xff6588f4))))),
                    //               ),
                    //               // Container(
                    //               //   width: 200,
                    //               //   height: 170,
                    //               //   padding: EdgeInsets.only(bottom: 5),
                    //               //   decoration: BoxDecoration(
                    //               //       color: Colors.white,
                    //               //       borderRadius: BorderRadius.circular(15),
                    //               //       image: DecorationImage(
                    //               //           image: AssetImage(info[i]['img'])),
                    //               //       boxShadow: [
                    //               //         BoxShadow(
                    //               //             blurRadius: 3,
                    //               //             offset: Offset(5, 5),
                    //               //             color: Color(0xff6985e8)
                    //               //                 .withOpacity(0.1)),
                    //               //         BoxShadow(
                    //               //             blurRadius: 3,
                    //               //             offset: Offset(-5, -5),
                    //               //             color: Color(0xff6985e8)
                    //               //                 .withOpacity(0.1))
                    //               //       ]),
                    //               //   child: Center(
                    //               //       child: Align(
                    //               //           alignment: Alignment.bottomCenter,
                    //               //           child: Text(info[i]["title"],
                    //               //               style: TextStyle(
                    //               //                   fontSize: 20,
                    //               //                   color:
                    //               //                       Color(0xff6588f4))))),
                    //               // )
                    //             ],
                    //           );
                    //         }))
                  ],
                )))
        // body: ListView.builder(
        //   scrollDirection: Axis.vertical,
        //   itemCount: data.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     return Dismissible(
        //       direction: DismissDirection.startToEnd,
        //       resizeDuration: Duration(milliseconds: 200),
        //       key: ObjectKey(data[index]),
        //       onDismissed: (direction) {},
        //       child: GestureDetector(
        //         onTap: () {
        //           Navigator.push(
        //             context,
        //             PageTransition(
        //                 child: WatchCourse(),
        //                 type: PageTransitionType.leftToRightWithFade),
        //           );
        //         },
        //         child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Container(
        //             height: 110.0,
        //             width: 150.0,
        //             decoration: BoxDecoration(
        //               color: Colors.grey[900],
        //             ),
        //             child: Padding(
        //               padding: const EdgeInsets.only(left: 10.0),
        //               child: Row(
        //                 children: [
        //                   ClipRRect(
        //                     borderRadius: BorderRadius.circular(5.0),
        //                     child: FadeInImage(
        //                       height: 90.0,
        //                       width: 100.0,
        //                       fit: BoxFit.fill,
        //                       image: AssetImage('images/udemy_logo.png'),
        //                       placeholder: AssetImage("images/udemy_logo.png"),
        //                     ),
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.only(left: 10.0),
        //                     child: Column(
        //                       mainAxisAlignment: MainAxisAlignment.center,
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         SizedBox(
        //                           width: 220.0,
        //                           child: Text(
        //                             data[index].title,
        //                             overflow: TextOverflow.ellipsis,
        //                             style: TextStyle(
        //                               color: Colors.grey.shade300,
        //                               fontSize: 18.0,
        //                             ),
        //                           ),
        //                         ),
        //                         Text(
        //                           data[index].author,
        //                           style: TextStyle(
        //                             color: Colors.grey.shade500,
        //                             fontSize: 14.0,
        //                           ),
        //                         ),
        //                         // LinearProgressIndicator(
        //                         //   value: 50.0,
        //                         //   backgroundColor: Colors.grey[200],
        //                         //   valueColor: AlwaysStoppedAnimation<Color>(
        //                         //       Colors.blue),
        //                         //   semanticsLabel: 'Loading...',
        //                         // )
        //                         SizedBox(
        //                           width: 200.0,
        //                           child: LinearProgressIndicator(
        //                             value: 0.1,
        //                             backgroundColor: Colors.grey[200],
        //                             valueColor: AlwaysStoppedAnimation<Color>(
        //                                 Colors.blue),
        //                             semanticsLabel: 'Loading...',
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // ));
        );
  }
}
