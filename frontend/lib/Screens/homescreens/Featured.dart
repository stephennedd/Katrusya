import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/MyList.dart';
import 'package:frontend/Screens/detailsScreen.dart';
import 'package:frontend/Services/DataController.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class Feautured extends StatefulWidget {
  const Feautured({super.key});

  @override
  State<Feautured> createState() => _FeauturedState();
}

class Course {
  final String image;
  final String title;
  final String author;
  final String ratings;
  final String price;
  final String enrolled;

  Course(
      {required this.image,
      required this.title,
      required this.author,
      required this.ratings,
      required this.price,
      required this.enrolled});
}

class _FeauturedState extends State<Feautured> {
  List<Course> data = [
    Course(
        image:
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.edx.org%2Fschool%2Fedx&psig=AOvVaw3vRjaUy3sTcr7qWDXWNx2q&ust=1677924499615000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCKjJ4P_Bv_0CFQAAAAAdAAAAABAE",
        title: "Python course",
        author: "Maksim Maksimovic",
        ratings: "5",
        enrolled: "123654",
        price: "100"),
    Course(
        image:
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Findianexpress.com%2Farticle%2Feducation%2Fhave-a-business-acumen-try-out-these-new-age-short-online-courses-6352687%2F&psig=AOvVaw3vRjaUy3sTcr7qWDXWNx2q&ust=1677924499615000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCKjJ4P_Bv_0CFQAAAAAdAAAAABAI",
        title: "JS course",
        author: "Yehor Zhvarnytskyi",
        ratings: "5",
        enrolled: "125784",
        price: "200")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Featured',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(EvaIcons.shoppingCartOutline),
              onPressed: () => {
                Navigator.push(
                  context,
                  PageTransition(
                      child: MyList(),
                      type: PageTransitionType.leftToRightWithFade),
                )
              },
            )
          ],
          backgroundColor: Colors.black),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 150.0,
                width: 400.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('images/udemy_logo.png'))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 80.0,
                  width: 400.0,
                  color: Colors.blueAccent,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Courses now on sale',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0)),
                        Text('1 Day Left',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold))
                      ])),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('Featured',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
                height: 300.0,
                width: 400.0,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: DetailsScreen(),
                                    type: PageTransitionType.bottomToTop));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 150.0,
                                  width: 350.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              'images/courseImage.jpg'))),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 200.0),
                                      child: Text(
                                        data[index].title,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0),
                                      ))),
                              Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    data[index].author,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12.0),
                                  )),
                              Row(
                                children: [
                                  Icon(EvaIcons.star,
                                      color: Colors.yellowAccent),
                                  Icon(EvaIcons.star,
                                      color: Colors.yellowAccent),
                                  Icon(EvaIcons.star,
                                      color: Colors.yellowAccent),
                                  Icon(EvaIcons.star,
                                      color: Colors.yellowAccent),
                                  Icon(EvaIcons.star,
                                      color: Colors.yellowAccent),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Text(
                                        data[index].ratings,
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 16.0),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(('(${data[index].enrolled})'),
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 16.0)),
                                  ),
                                ],
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Row(
                                    children: [
                                      Icon(FontAwesomeIcons.dollarSign,
                                          color: Colors.grey.shade600),
                                      Text(
                                        data[index].price,
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 22.0),
                                      ),
                                    ],
                                  )),
                            ])),
                          ));
                    }))
          ],
        ),
      ),
    );
  }
}
