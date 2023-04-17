import 'package:flutter/material.dart';
import 'package:frontend/Themes/app_colors.dart';

class LeaderboardItem extends StatelessWidget {
  LeaderboardItem({Key? key, required this.image, required this.name, required this.score, required this.index}) : super(key: key);
  String image;
  String name;
  String score;
  int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.1),
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(1,1),
          )
        ]
      ),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("$index." ,style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w500),),
          CircleAvatar(
            backgroundColor: lightGrey,
            radius: 19,
            child: CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage(image),
            ),
          ),
          Text(name, style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600),),
          Text("$score pts", style: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: labelColor),)
        ],
      ),
    );
  }
}
