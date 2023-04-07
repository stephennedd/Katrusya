import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Screens/root_app.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/screens/quiz/quizcomponents/AnswerCard.dart';
import 'package:frontend/screens/components/BackgroundDecoration.dart';
import 'package:frontend/screens/components/ContentArea.dart';
import 'package:frontend/screens/components/CustomAppBar.dart';
import 'package:frontend/screens/components/MainButton.dart';
import 'package:frontend/screens/section.dart';
import 'package:frontend/screens/watchCourseScreen.dart';
import 'package:frontend/Themes/custom_text_styles.dart';
import 'package:frontend/controllers/question_paper/questions_controller.dart';
import 'package:frontend/controllers/question_paper/questions_controller_extension.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'answerCheckScreen.dart';
import '../quizcomponents/QuestionNumberCard.dart';

class ResultScreen extends GetView<QuestionsController> {
  ResultScreen({super.key});
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
                        Lottie.asset("assets/lotties/107653-trophy.json",
                          width: 200,
                          repeat: false
                        ),
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
                          'You have ${controller.points} points',
                          style: const TextStyle(
                              fontFamily: 'Nexa-Trial',
                              fontWeight: FontWeight.w600,
                              color: primaryDark),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Text(
                          'Tap below question numbers to view vorrect answers',
                          style: TextStyle(
                              fontFamily: 'Nexa-Trial'
                          ),
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
                                  onTap: () async {
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


