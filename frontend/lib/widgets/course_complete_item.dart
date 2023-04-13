import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Themes/app_colors.dart';
import '../controllers/users/user_controller.dart';
import 'custom_image.dart';
import 'lesson_progress.dart';

class CourseCompleteItem extends StatelessWidget {
  CourseCompleteItem(
      {Key? key, this.onTap, required this.progressValue, required this.data})
      : super(key: key);
  GestureTapCallback? onTap;
  final data;
  double progressValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueGrey.shade100, width: .2),
            boxShadow: [
              BoxShadow(
                  color: shadowColor.withOpacity(0.1),
                  blurRadius: .5,
                  spreadRadius: .5,
                  offset: const Offset(1, 1)
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Hero(
              tag: data.courseImage,
              child: CustomImage(
                data.courseImage,
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
                    data.courseName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: textColor),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 14,
                        color: labelColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${data.numberOfLessons} lessons",
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: labelColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyLinearProgressIndicator(
                    value: progressValue,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15,),
            Icon(
              Icons.play_arrow_rounded,
              color: primaryDark,
              size: 30,
            ),
            const SizedBox(width: 15,),
          ],
        ),
      ),
    );
  }
}
