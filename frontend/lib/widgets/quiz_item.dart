import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Themes/app_colors.dart';
import 'custom_image.dart';

class QuizItem extends StatelessWidget {
  QuizItem({Key? key, this.onTap, required this.data}) : super(key: key);
  final data;
  GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: primaryDark,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: shadowColor.withOpacity(.3),
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: const Offset(1, 1))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomImage(
              data.imageUrl,
              radius: 10,
              height: 70,
              width: 70,
              isShadow: false,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: primary),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/comment-question.svg",
                        width: 15,
                        height: 15,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${data.numberOfQuestions} questions",
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Icon(
              Icons.play_arrow_rounded,
              color: primary,
            )
          ],
        ),
      ),
    );
  }
}
