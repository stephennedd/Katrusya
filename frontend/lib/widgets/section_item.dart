import 'package:flutter/material.dart';
import '../Themes/app_colors.dart';
import 'custom_image.dart';

class SectionItem extends StatelessWidget {
  SectionItem({Key? key, required this.data, this.onTap}) : super(key: key);
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
            CustomImage(
              data.image,
              radius: 10,
              width: 70,
              height: 70,
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
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: textColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.play_circle_outline,
                        size: 14,
                        color: labelColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${data.numberOfLessons} lessons",
                        style: TextStyle(
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
              Icons.chevron_right_rounded,
              color: labelColor,
            )
          ],
        ),
      ),
    );
  }
}
