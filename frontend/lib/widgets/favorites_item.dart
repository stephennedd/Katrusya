import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../Themes/app_colors.dart';

class FavoritesItem extends StatelessWidget {
  FavoritesItem({Key? key, this.onTap, required this.data}) : super(key: key);
  GestureTapCallback? onTap;
  final data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10, bottom: 10, left: 3, right: 3),
        //padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: shadowColor.withOpacity(.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(1, 1)),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 90,
              height: 90,
              child: CachedNetworkImage(
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover)),
                ),
                imageUrl: data.courseImage,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.courseName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                      fontSize: 15),
                ),
                const SizedBox(height: 5),
                Text(
                  data.coursePrice,
                  maxLines: 1,
                  style: const TextStyle(
                      color: textColor, fontFamily: "Poppins", fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    getAttribute("${data.numberOfLessons} lessons",
                        Icons.play_circle_outline, labelColor),
                    const SizedBox(
                      width: 10,
                    ),
                    getAttribute("${data.durationInHours} hours",
                        Icons.schedule_outlined, labelColor),
                    const SizedBox(
                      width: 10,
                    ),
                    getAttribute(
                        "${data.courseReview}", Icons.star, Colors.yellow),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getAttribute(String info, IconData iconData, Color color) {
    return Row(
      children: [
        Icon(iconData, size: 18, color: color),
        const SizedBox(
          width: 3,
        ),
        Text(
          info,
          style: const TextStyle(
              fontFamily: "Poppins", color: labelColor, fontSize: 13),
        )
      ],
    );
  }
}
