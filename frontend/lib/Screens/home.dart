import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend/utils/data.dart';
import 'package:frontend/widgets/category_box.dart';
import 'package:frontend/widgets/featured_item.dart';
import 'package:frontend/widgets/notification_box.dart';
import 'package:frontend/widgets/recommended_item.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Themes/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String routeName = "/homepage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      appBar: getAppBar(),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      elevation: 0 ,
      backgroundColor: appBarColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 5,),
              // TODO get logged in users username and show here instead of hardcoded name
              Text("Hi Stephen!", style: TextStyle(
                color: textColor,
                fontSize: 25,
                fontWeight: FontWeight.w800,
                fontFamily: 'Nexa-Trial'
              ),
              ),
            ]
          ),
          NotificationBox(
              notifiedNumber: 2,
              onTap: (){
                print("wallet pressed");
              },
          )
        ],
      ),
    );
  }

  Widget buildBody(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getCategories(),
          const Padding(padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
          child: Text(
            "Featured",
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w800,
              fontSize: 26,
              fontFamily: 'Nexa-Trial'
            ),
            ),
          ),
          getFeatured(),
          Padding(padding: const EdgeInsets.fromLTRB(15, 25, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Recommended",
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      fontFamily: 'Nexa-Trial'
                  ),
                ),
                Text(
                  "See all",
                  style: TextStyle(
                      color: labelColor,
                      fontSize: 16,
                      fontFamily: 'Poppins'
                  ),
                ),
              ],
            ),
          ),
          getRecommended()
        ],
      ),
    );
  }

  Widget getRecommended() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 15),
      scrollDirection: Axis.horizontal,
      child: Row(
        //TODO get the list of recommended courses from database
        children: List.generate(recommends.length,
                (index) => Container(
                  margin: const EdgeInsets.only(top: 3, right: 15, bottom: 5),
                  child: RecommendItem(
                    data: recommends[index],
                    onTap: (){
                      print(index);
                    },
                  ),
                ))
      ),
    );
  }
  
  Widget getFeatured() {
    return CarouselSlider(
        options: CarouselOptions(
          height: 290, enlargeCenterPage: true, disableCenter: true),
        // TODO get data from database
        items: List.generate(features.length,
                (index) => FeaturedItem(data: features[index],
                  onTap: (){
                    print(index);
                  })
        )
      );
  }

  Widget getCategories() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            // TODO add backend connection here to get categories from database
          List.generate(categories.length, (index) =>
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: CategoryBox(
                    data: categories[index]),
              ),
          )
      ),
    );
  }

}
