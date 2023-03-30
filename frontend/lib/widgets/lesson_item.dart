import 'package:flutter/material.dart';

import '../Themes/app_colors.dart';
import 'custom_image.dart';

class LessonItem extends StatelessWidget {
  LessonItem({Key? key, this.onTap, required this.data}) : super(key: key);
  GestureTapCallback? onTap;
  final data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: shadowColor.withOpacity(.07),
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: const Offset(1, 1))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Hero(
              tag: data.image,
              child: CustomImage(
                data.image,
                radius: 10,
                width: 70,
                height: 70,
                isShadow: false,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.lessonName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: textColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_outlined,
                        size: 14,
                        color: labelColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${data.lessonDurationInHours} hours",
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: labelColor),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Icon(
              Icons.play_arrow_rounded,
              color: primaryDark,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}
