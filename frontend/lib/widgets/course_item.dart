import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/widgets/bookmark_box.dart';

import '../Themes/app_colors.dart';

class CourseItem extends StatelessWidget {
  CourseItem({Key? key, required this.data, this.onFavorite, this.onTap}) : super(key: key);
  dynamic data;
  GestureTapCallback? onFavorite;
  GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 290,
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: shadowColor.withOpacity(.1),
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: const Offset(1, 1))
            ]),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: 200,
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
            Positioned(
              top: 180,
              right: 15,
              child: BookmarkBox(
                onTap: onFavorite,
                isFavorited: data.isFavorited,
              ),
            ),
            Positioned(
                top: 215,
                left: 10,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getAttribute(
                              Icons.sell_outlined, data.price, labelColor),
                          getAttribute(Icons.play_circle_outline, data.session,
                              labelColor),
                          getAttribute(
                              Icons.schedule_outlined, data.duration, labelColor),
                          getAttribute(
                              Icons.star, data.review.toString(), Colors.yellow),
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  getAttribute(IconData icon, String name, Color color) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: color,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          name,
          style: const TextStyle(fontSize: 13, color: labelColor),
        )
      ],
    );
  }
}
