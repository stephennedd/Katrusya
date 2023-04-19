import 'package:flutter/material.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/screens/components/BackgroundDecoration.dart';
import 'package:frontend/screens/components/CustomAppBar.dart';
import 'package:frontend/screens/components/MainButton.dart';
import 'package:frontend/screens/quiz/quizcomponents/QuestionPlaceHolder.dart';
import 'package:frontend/screens/quiz/quizscreens/testOverviewScreen.dart';
import 'package:frontend/screens/quiz/quizcomponents/AnswerCard.dart';
import 'package:frontend/screens/quiz/quizcomponents/CountdownTimer.dart';
import 'package:frontend/Themes/custom_text_styles.dart';
import 'package:frontend/controllers/data_uploader_controller.dart';
import 'package:frontend/controllers/question_paper/questions_controller.dart';
import 'package:frontend/models/loading_status_model.dart';
import 'package:get/get.dart';

import '../../components/ContentArea.dart';

class TestScreen extends GetView<QuestionsController> {
  const TestScreen({super.key});
  static const String routeName = "/testscreen";

  @override
  Widget build(BuildContext context) {
    QuestionsController questionsController = Get.put(QuestionsController());
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(
          leading: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

            child: Obx(() => CountdownTimer(
                time: controller.time.value, color: Colors.white)),
          ),
          showActionIcon: true,
          titleWidget: Obx(() => Text(
                "Question ${controller.questionIndex.value + 1}",
                style: const TextStyle(
                  fontFamily: 'Nexa-Trial',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
                ),
              )),
        ),
        body: BackgroundDecoration(
            child: Obx(() => Column(
                  children: [
                    if (controller.loadingStatus.value == LoadingStatus.loading)
                      const Expanded(
                          child: ContentArea(
                              addPadding: true, child: QuestionScreenHolder())),
                    if (controller.loadingStatus.value ==
                        LoadingStatus.completed)
                      Expanded(
                        child: ContentArea(
                          addPadding: true,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(top: 25),
                            child: Column(children: [
                              Text(
                                controller.currentQuestion.value!.question,
                                style: questionTS,
                              ),
                              GetBuilder<QuestionsController>(
                                id: "answers_list",
                                builder: (context) {
                                  return ListView.separated(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.only(top: 25),
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final answer = controller
                                            .currentQuestion
                                            .value!
                                            .answers[index];
                                        return AnswerCard(
                                          answer:
                                              '${answer.identifier}. ${answer.answer}',
                                          onTap: () {
                                            controller.selectedAnswer(
                                                answer.identifier);
                                          },
                                          isSelected: answer.identifier ==
                                              controller.currentQuestion.value!
                                                  .selectedAnswer,
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              const SizedBox(
                                                height: 10,
                                              ),
                                      itemCount: controller.currentQuestion
                                          .value!.answers.length);
                                },
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ColoredBox(
                        color: Colors.white,
                        child: Row(
                          children: [
                            Visibility(
                                visible: controller.isFirstQuestion,
                                child: SizedBox(
                                    width: 55,
                                    height: 55,
                                    child: MainButton(
                                      onTap: () {
                                        controller.prevQuestion();
                                      },
                                      child: Icon(
                                        Icons.arrow_back_ios_new,
                                        color: primaryDark,
                                      ),
                                    ))),
                            Expanded(
                                child: Visibility(
                              visible: controller.loadingStatus.value ==
                                  LoadingStatus.completed,
                              child: MainButton(
                                onTap: () {
                                  controller.isLastQuestion
                                      ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TestOverviewScreen()))
                                          /*Get.toNamed(
                                          TestOverviewScreen.routeName)*/
                                      : controller.nextQuestion();
                                },
                                title: controller.isLastQuestion
                                    ? 'Complete'
                                    : 'Next',
                              ),
                            ))
                          ],
                        ))
                  ],
                ))));
  }
}
