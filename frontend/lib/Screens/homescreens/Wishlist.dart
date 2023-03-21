import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/Screens/myList.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:page_transition/page_transition.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
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

class _WishListState extends State<WishList> {
  List<Course> data = [
    Course(
        image:
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.edx.org%2Fschool%2Fedx&psig=AOvVaw3vRjaUy3sTcr7qWDXWNx2q&ust=1677924499615000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCKjJ4P_Bv_0CFQAAAAAdAAAAABAE",
        title: "Python course",
        author: "Maksim Maksimovic",
        ratings: "5",
        enrolled: "123654",
        price: "100",
        discount: "90"),
    Course(
        image:
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Findianexpress.com%2Farticle%2Feducation%2Fhave-a-business-acumen-try-out-these-new-age-short-online-courses-6352687%2F&psig=AOvVaw3vRjaUy3sTcr7qWDXWNx2q&ust=1677924499615000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCKjJ4P_Bv_0CFQAAAAAdAAAAABAI",
        title: "JS course",
        author: "Yehor Zhvarnytskyi",
        ratings: "5",
        enrolled: "125784",
        price: "200",
        discount: "170")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Wishlist"),
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
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              direction: DismissDirection.startToEnd,
              resizeDuration: Duration(milliseconds: 200),
              key: ObjectKey(data[index]),
              onDismissed: (direction) {},
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 110.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: FadeInImage(
                              height: 90.0,
                              width: 100.0,
                              fit: BoxFit.fill,
                              image: AssetImage('images/udemy_logo.png'),
                              placeholder: AssetImage("images/udemy_logo.png"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 220.0,
                                  child: Text(
                                    data[index].title,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey.shade300,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Text(
                                  data[index].author,
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 18.0,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 18.0,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 18.0,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 18.0,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 18.0,
                                    ),
                                    Text(
                                      data[index].ratings,
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    Text(
                                      " (" + data[index].enrolled + ")",
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(FontAwesomeIcons.dollarSign,
                                        color: Colors.white),
                                    Text(
                                      data[index].discount != ""
                                          ? data[index].discount
                                          : data[index].price,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7.0,
                                    ),
                                    Text(
                                      data[index].discount != ""
                                          ? data[index].price
                                          : "",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15.0,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
