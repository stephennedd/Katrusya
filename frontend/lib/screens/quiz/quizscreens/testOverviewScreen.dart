import 'package:flutter/material.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/screens/quiz/quizcomponents/AnswerCard.dart';
import 'package:frontend/screens/components/BackgroundDecoration.dart';
import 'package:frontend/screens/components/ContentArea.dart';
import 'package:frontend/screens/components/CustomAppBar.dart';
import 'package:frontend/screens/components/MainButton.dart';
import 'package:frontend/screens/quiz/quizcomponents/QuestionNumberCard.dart';
import 'package:frontend/screens/quiz/quizcomponents/CountdownTimer.dart';
import 'package:frontend/screens/quiz/quizscreens/resultScreen.dart';
import 'package:frontend/Themes/custom_text_styles.dart';
import 'package:frontend/Themes/ui_parameters.dart';
import 'package:frontend/controllers/question_paper/questions_controller.dart';
import 'package:frontend/controllers/question_paper/questions_controller_extension.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TestOverviewScreen extends GetView<QuestionsController> {
  TestOverviewScreen({super.key});
  static const String routeName = "/testoverview";

  final GetStorage _getStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: controller.completedTest,
      ),
      body: BackgroundDecoration(
        child: Column(
          children: [
            Expanded(
                child: ContentArea(
              addPadding: true,
              child: Column(
                children: [
                  Row(
                    children: [
                      CountdownTimer(
                        color: primaryDark,
                        time: '',
                      ),
                      Obx(() => Text(
                            '${controller.time} Remaining',
                            style: countDownTimerTs(),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: GridView.builder(
                          itemCount: controller.allQuestions.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: Get.width ~/ 75,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8),
                          itemBuilder: (_, index) {
                            AnswerStatus? _answerStatus;
                            if (controller.allQuestions[index].selectedAnswer !=
                                null) {
                              _answerStatus = AnswerStatus.answered;
                            }
                            return QuestionNumberCard(
                                index: index + 1,
                                status: _answerStatus,
                                onTap: () => controller.jumpToQuestion(index));
                          })),
                  ColoredBox(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Row(
                        children: [
                          Expanded(
                              child: MainButton(
                            onTap: () {
                              controller.completeTest(
                                  _getStorage.read("userId"),
                                  controller.questionPaperModel.id,
                                  controller.points,
                              );
                              Navigator.pushReplacementNamed(context, ResultScreen.routeName);
                            },
                            title: 'Complete',
                          ))
                        ],
                      ))

                  // Expanded(
                  //   child: MainButton(
                  //     onTap: () {
                  //       controller.complete();
                  //     },
                  //     title: 'Complete',
                  //   ),
                  // ),
                  // ColoredBox(
                  //   color: Colors.white,
                  //   child: Padding(
                  //     padding: UIParameters.mobileScreenPadding,
                  //     child: MainButton(
                  //       onTap: () {
                  //         // Get.toNamed(ResultScreen.routeName);
                  //         controller.complete();
                  //       },
                  //       title: 'Complete',
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
