import 'package:flutter/material.dart';
import 'package:frontend/Themes/app_colors.dart';

import 'leaderboard_item.dart';

class LeaderboardPopup extends StatelessWidget {
  const LeaderboardPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Stack(children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [primary, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              borderRadius: BorderRadius.circular(25)),
          child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: appBarOffWhite,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                        color: shadowColor.withOpacity(0.1),
                        blurRadius: 1,
                        spreadRadius: 1,
                        offset: const Offset(1, 1))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 15, left: 15),
                    child: const Text(
                      "leaderboard",
                      style: TextStyle(
                          fontFamily: 'Nexa-Trial',
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    height: 700,
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: getLeaderboardItems(),
                  )
                ],
              )),
        ),
      ]),
    );
  }

  Widget getLeaderboardItems() {
    List items = <dynamic>[];
    items.add({
      "image" : "images/ape.jpg",
      "name" : "Stephen Nedd",
      "score" : "1000"
    });

    items.add({
      "image" : "images/ape.jpg",
      "name" : "Stephen Nedd",
      "score" : "1000"
    });

    items.add({
      "image" : "images/ape.jpg",
      "name" : "Stephen Nedd",
      "score" : "1000"
    });

    items.add({
      "image" : "images/ape.jpg",
      "name" : "Stephen Nedd",
      "score" : "1000"
    });

    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => LeaderboardItem(
          image: items[index]["image"],
          name: items[index]["name"],
          index: index,
          score: items[index]["score"],
        )
    );
  }
}
