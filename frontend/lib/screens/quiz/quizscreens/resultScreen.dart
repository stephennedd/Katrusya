import 'package:flutter/material.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/controllers/marketplace/courses/course_controller.dart';
import 'package:frontend/screens/quiz/quizcomponents/AnswerCard.dart';
import 'package:frontend/screens/components/BackgroundDecoration.dart';
import 'package:frontend/screens/components/ContentArea.dart';
import 'package:frontend/screens/components/CustomAppBar.dart';
import 'package:frontend/screens/components/MainButton.dart';
import 'package:frontend/screens/section.dart';
import 'package:frontend/controllers/question_paper/questions_controller.dart';
import 'package:frontend/controllers/question_paper/questions_controller_extension.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'answerCheckScreen.dart';
import '../quizcomponents/QuestionNumberCard.dart';

class ResultScreen extends GetView<QuestionsController> {
  ResultScreen({super.key});

  static const String routeName = "/resultscreen";

  CourseController courseController = Get.put(CourseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundDecoration(
        child: Column(
          children: [
            CustomAppBar(
              leading: const SizedBox(
                height: 80,
              ),
              title: controller.correctAmsweredQuestions,
            ),
            Expanded(
                child: ContentArea(
                    addPadding: true,
                    child: Column(
                      children: [
                        Lottie.asset("assets/lotties/107653-trophy.json",
                            width: 200, repeat: false),
                        const Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 5),
                          child: Text(
                            'Congratulations',
                            style: TextStyle(
                                fontFamily: 'Nexa-Trial',
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: primaryDark),
                          ),
                        ),
                        Text(
                          'You earned ${controller.points} points',
                          style: const TextStyle(
                              fontFamily: 'Nexa-Trial',
                              fontWeight: FontWeight.w600,
                              color: primaryDark),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Text(
                          'Tap the question number to view the correct answer',
                          style: TextStyle(fontFamily: 'Nexa-Trial'),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Expanded(
                            child: GridView.builder(
                          itemCount: controller.allQuestions.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: Get.width ~/ 75,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8),
                          itemBuilder: (_, index) {
                            final question = controller.allQuestions[index];
                            AnswerStatus status = AnswerStatus.notanswered;
                            final selectedAnswer = question.selectedAnswer;
                            final correctAnswer = question.correctAnswer;
                            if (selectedAnswer == correctAnswer) {
                              status = AnswerStatus.correct;
                            } else if (question.selectedAnswer == null) {
                              status = AnswerStatus.wrong;
                            } else {
                              status = AnswerStatus.wrong;
                            }
                            return QuestionNumberCard(
                              index: index + 1,
                              status: status,
                              onTap: () {
                                controller.jumpToQuestion(index,
                                    isGoBack: false);
                                Get.toNamed(AnswerCheckScreen.routeName);
                              },
                            );
                          },
                        )),
                        ColoredBox(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Row(
                              children: [
                                Expanded(
                                    child: MainButton(
                                  onTap: () async {
                                    final section = courseController
                                        .currentCourseDetails.value!.sections
                                        .firstWhere(
                                      (section) =>
                                          section.sectionId ==
                                          courseController
                                              .currentSectionId.value,
                                    );
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SectionPage(data: section)));
                                    // TODO route to the previously closed section page
                                  },
                                  title: 'Complete',
                                ))
                              ],
                            ))
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
