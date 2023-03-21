import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Screens/quiz/quizcomponents/AnswerCard.dart';
import 'package:frontend/Screens/components/BackgroundDecoration.dart';
import 'package:frontend/Screens/components/ContentArea.dart';
import 'package:frontend/Screens/components/CustomAppBar.dart';
import 'package:frontend/Screens/components/MainButton.dart';
import 'package:frontend/Screens/watchCourseScreen.dart';
import 'package:frontend/Themes/custom_text_styles.dart';
import 'package:frontend/controllers/question_paper/questions_controller.dart';
import 'package:frontend/controllers/question_paper/questions_controller_extension.dart';
import 'package:get/get.dart';

import 'answerCheckScreen.dart';
import '../quizcomponents/QuestionNumberCard.dart';

class ResultScreen extends GetView<QuestionsController> {
  const ResultScreen({super.key});
  static const String routeName = "/resultscreen";

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
                        SvgPicture.asset('images/bulb.svg'),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 5),
                          child: Text(
                            'Congratulations',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.pink[500]),
                          ),
                        ),
                        Text(
                          'You have ${controller.points} points',
                          style: TextStyle(color: Colors.pink[500]),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Text(
                          'Tap below question numbers to view vorrect answers',
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
                            final _question = controller.allQuestions[index];
                            AnswerStatus _status = AnswerStatus.notanswered;
                            final _selectedAnswer = _question.selectedAnswer;
                            final _correctAnswer = _question.correctAnswer;
                            if (_selectedAnswer == _correctAnswer) {
                              _status = AnswerStatus.correct;
                            } else if (_question.selectedAnswer == null) {
                              _status = AnswerStatus.wrong;
                            } else {
                              _status = AnswerStatus.wrong;
                            }
                            return QuestionNumberCard(
                              index: index + 1,
                              status: _status,
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
                                  onTap: () {
                                    Get.offNamedUntil(WatchCourse.routeName,
                                        (route) => false);
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
