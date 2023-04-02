import 'package:flutter/material.dart';
import '../Themes/app_colors.dart';
import 'custom_image.dart';
import 'lesson_progress.dart';

class CourseCompleteItem extends StatelessWidget {
  CourseCompleteItem({Key? key, this.onTap, this.progressValue = 0.4, required this.data}) : super(key: key);
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
            border: Border.all(
                color: Colors.blueGrey.shade100,
                width: .2
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade400,
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset: const Offset(2,2)
              ),
              const BoxShadow(
                  color: Colors.white,
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset: Offset(-2, -2)
              )
            ]
        ),
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
                    data.name,
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
                        Icons.play_circle_outline,
                        size: 14,
                        color: labelColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${data.numberOfLessons } lessons",
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
            Icon(
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
