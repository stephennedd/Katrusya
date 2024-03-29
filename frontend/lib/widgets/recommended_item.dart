import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../Themes/app_colors.dart';

class RecommendItem extends StatelessWidget {
  const RecommendItem({Key? key, required this.data, this.onTap}) : super(key: key);
  final data;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 320,
        //padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: shadowColor.withOpacity(.1),
                  spreadRadius: 0.5,
                  blurRadius: 0.5,
                  offset: const Offset(0, 0)),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 125,
              child: CachedNetworkImage(
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover)),
                ),
                imageUrl: data.image,
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
                  data.name,
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
                  data.price,
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
                    )
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
