import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/controllers/users/user_controller.dart';
import 'package:frontend/widgets/bookmark_box.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Themes/app_colors.dart';
import '../controllers/marketplace/courses/course_controller.dart';

class CourseItem extends StatelessWidget {
  CourseItem({Key? key, required this.data, this.onFavorite, this.onTap})
      : super(key: key);
  dynamic data;
  GestureTapCallback? onFavorite;
  GestureTapCallback? onTap;

  CourseController courseController = Get.put(CourseController());
  UsersController usersController = Get.put(UsersController());

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
                  blurRadius: 0.5,
                  spreadRadius: 0.5,
                  offset: const Offset(0, 0))
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
              child: Obx(() => BookmarkBox(
                    onTap: onFavorite,
                    isFavorited:
                        //courseController.courses.value[data.id - 1].isFavorited
                        usersController.isCourseFavoriteForTheUser(data.id),
                  )),
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
                          getAttribute(Icons.play_circle_outline,
                              "${data.numberOfLessons} lessons", labelColor),
                          getAttribute(Icons.schedule_outlined,
                              "${data.durationInHours} hours", labelColor),
                          getAttribute(Icons.star, data.review.toString(),
                              Colors.yellow),
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
