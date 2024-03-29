import 'package:flutter/material.dart';
import 'package:frontend/widgets/animated_complete_task_button.dart';
import 'package:frontend/widgets/lesson_progress.dart';
import '../Themes/app_colors.dart';
import 'custom_image.dart';

class LessonItem extends StatelessWidget {
  LessonItem({
    Key? key,
    this.onTap,
    required this.data,
    required this.isComplete,
    this.onComplete,
    this.isPlaying = false,
    this.progressValue = 0.1,
  }) : super(key: key);
  GestureTapCallback? onTap;
  final data;
  bool isPlaying;
  double progressValue;
  GestureTapCallback? onComplete;
  late bool isComplete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: isPlaying ? Colors.blueGrey.shade100 : Colors.white,
                width: .2),
            boxShadow: isPlaying
                ? [
                    BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: const Offset(1, 1)),
                    const BoxShadow(
                        color: Colors.white,
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(-1, -1))
                  ]
                : []),
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
                      const Icon(
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
            const SizedBox(
              width: 30,
            ),
            AnimatedCompleteTaskButton(
              onPressed: onComplete!,
              isCompleted: isComplete,
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
      ),
    );
  }
}
