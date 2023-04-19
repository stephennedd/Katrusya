import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../Themes/app_colors.dart';

class FeaturedItem extends StatelessWidget {
  const FeaturedItem({Key? key, required this.data, this.onTap}) : super(key: key);
  final data;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        height: 400,
        //padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.only(bottom: 5, top: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: shadowColor.withOpacity(.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 0))
            ]),
        child: Stack(
          children: [
            Hero(
              tag: data.id.toString() + data.image,
              child: SizedBox(
                width: double.infinity,
                height: 190,
                child: CachedNetworkImage(
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover)),
                  ),
                  imageUrl: data.image,
                ),
              ),
            ),
            Positioned(
              top: 170,
              right: 15,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: primaryDark,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  data.price,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: primary),
                ),
              ),
            ),

            Positioned(
              top: 210,
              left: 10,
              child: SizedBox(
                width: 270,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getAttribute("${data.numberOfLessons} lessons",
                            Icons.play_circle_outline, labelColor),
                        const SizedBox(width: 10),
                        getAttribute("${data.durationInHours} lessons",
                            Icons.schedule_outlined, labelColor),
                        const SizedBox(width: 10),
                        getAttribute(data.review, Icons.star, Colors.yellow),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
          width: 4,
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
